# Topico SNS FIFO unico para todos os eventos do Saga. Cada servico consumidor
# tem sua propria SQS FIFO (sqs.tf) inscrita com uma filter policy que so
# entrega os tipos de evento relevantes para aquele servico - assim o topico
# funciona como um "barramento" unico, sem precisar de um topico por evento.
#
# FIFO (em vez de standard) garante ordem de entrega por `MessageGroupId`
# (usado = ordemServicoId) - critico no Saga: um evento posterior (ex.
# ExecucaoIniciadaEvent) nao pode ser processado antes do evento que o
# habilita (PagamentoAprovadoEvent) por causa de retry/entrega fora de ordem.
resource "aws_sns_topic" "saga_events" {
  name                        = "${var.saga_topic_name}.fifo"
  fifo_topic                  = true
  content_based_deduplication = false # dedupe explicito via MessageDeduplicationId = eventId (ver contracts/)

  tags = {
    Name = "${var.saga_topic_name}.fifo"
  }
}

# Policy do topico: so o proprio dono da conta (via IAM, nao resource policy
# publica) pode publicar. Nenhum principal externo/anonimo tem acesso.
resource "aws_sns_topic_policy" "saga_events" {
  arn = aws_sns_topic.saga_events.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AccountOwnerFullAccess"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "sns:*"
        Resource  = aws_sns_topic.saga_events.arn
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
