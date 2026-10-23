# -----------------------------------------------------------------------------
# Geral
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente (ex: production, development). Usado em tags e identificadores de recursos."
  type        = string
  default     = "development"
}

# -----------------------------------------------------------------------------
# Saga - topico e filas
# -----------------------------------------------------------------------------

variable "saga_topic_name" {
  description = "Nome base do topico SNS FIFO do Saga (sufixo .fifo adicionado automaticamente)."
  type        = string
  default     = "oficina-saga-events"
}

variable "dlq_max_receive_count" {
  description = "Numero de tentativas de entrega antes de uma mensagem ir para a DLQ da fila."
  type        = number
  default     = 3
}

variable "message_retention_seconds" {
  description = "Retencao de mensagens nas filas principais (padrao SQS: 4 dias)."
  type        = number
  default     = 345600
}

variable "dlq_message_retention_seconds" {
  description = "Retencao de mensagens nas DLQs (14 dias - tempo para investigar falhas antes de perder a mensagem)."
  type        = number
  default     = 1209600
}
