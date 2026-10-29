# Uma IAM policy autonoma por servico consumidor (nao uma role - os repos dos
# 3 microsservicos ainda nao existem nesta sprint). Cada policy e
# least-privilege: so publica no topico unico e so consome a propria fila.
# Quando os repos oficina-os-service / oficina-billing-service /
# oficina-execution-service forem criados, a IAM Role de CI/runtime de cada
# um so precisa dar `attach` na policy correspondente.
resource "aws_iam_policy" "consumer" {
  for_each = local.consumers

  name        = "oficina-saga-${each.key}-policy"
  description = "Acesso least-privilege ao Saga: publish no topico unico + consume na fila/DLQ do ${each.key}."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PublishToSagaTopic"
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.saga_events.arn
      },
      {
        Sid    = "UseSagaTopicKmsKey"
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt",
        ]
        Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "sns.${var.aws_region}.amazonaws.com"
          }
        }
      },
      {
        Sid    = "ConsumeOwnQueue"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ]
        Resource = aws_sqs_queue.consumer[each.key].arn
      },
      {
        Sid    = "ReadOwnDlqForInvestigation"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes",
        ]
        Resource = aws_sqs_queue.dlq[each.key].arn
      },
    ]
  })

  tags = {
    Name = "oficina-saga-${each.key}-policy"
  }
}
