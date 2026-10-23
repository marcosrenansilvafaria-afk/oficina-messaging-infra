# Uma fila FIFO (+ DLQ) por servico consumidor do Saga. Cada fila se inscreve
# no topico unico (sns.tf) com uma filter policy que so entrega os tipos de
# evento que aquele servico realmente consome - os outros servicos nem
# recebem a mensagem (menos ruido, menos custo de polling em vao).
locals {
  consumers = {
    os-service = {
      event_types = [
        "PagamentoAprovadoEvent",
        "PagamentoRecusadoEvent",
        "ExecucaoIniciadaEvent",
        "ExecucaoConcluidaEvent",
        "CompensarOSEvent",
      ]
    }
    billing-service = {
      event_types = [
        "OrcamentoGeradoEvent",
        "CompensarOSEvent",
      ]
    }
    execution-service = {
      event_types = [
        "PagamentoAprovadoEvent",
        "CompensarOSEvent",
      ]
    }
  }
}

resource "aws_sqs_queue" "dlq" {
  for_each = local.consumers

  name                        = "oficina-saga-${each.key}-dlq.fifo"
  fifo_queue                  = true
  message_retention_seconds   = var.dlq_message_retention_seconds
  sqs_managed_sse_enabled     = true
  content_based_deduplication = false

  tags = {
    Name = "oficina-saga-${each.key}-dlq.fifo"
  }
}

resource "aws_sqs_queue" "consumer" {
  for_each = local.consumers

  name                        = "oficina-saga-${each.key}.fifo"
  fifo_queue                  = true
  message_retention_seconds   = var.message_retention_seconds
  sqs_managed_sse_enabled     = true
  content_based_deduplication = false

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn
    maxReceiveCount     = var.dlq_max_receive_count
  })

  tags = {
    Name = "oficina-saga-${each.key}.fifo"
  }
}

# Policy de recurso da fila: so o topico SNS deste Saga pode enviar mensagens
# para ela (nenhum outro principal/conta, nenhum acesso publico).
resource "aws_sqs_queue_policy" "consumer" {
  for_each = local.consumers

  queue_url = aws_sqs_queue.consumer[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSagaTopicToSendMessage"
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.consumer[each.key].arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.saga_events.arn
          }
        }
      }
    ]
  })
}

# raw_message_delivery = true: a mensagem na fila e o JSON do evento puro
# (sem o envelope SNS), ja que o proprio evento ja carrega seu envelope
# (SagaEventEnvelope, ver contracts/) - evita double-wrapping.
resource "aws_sns_topic_subscription" "consumer" {
  for_each = local.consumers

  topic_arn            = aws_sns_topic.saga_events.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.consumer[each.key].arn
  raw_message_delivery = true
  filter_policy_scope  = "MessageAttributes"
  filter_policy = jsonencode({
    eventType = each.value.event_types
  })
}
