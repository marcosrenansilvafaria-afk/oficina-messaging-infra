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

# Nenhuma resource policy publica/cross-account e definida no topico - o
# controle de acesso real e feito via IAM identity-based policy (iam.tf),
# que so concede `sns:Publish` para cada servico consumidor. Sem uma policy
# de recurso explicita, o SNS usa a policy default (restrita ao dono da
# conta via IAM), suficiente aqui.
