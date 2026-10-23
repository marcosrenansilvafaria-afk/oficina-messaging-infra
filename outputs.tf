output "sns_topic_arn" {
  description = "ARN do topico SNS FIFO unico do Saga."
  value       = aws_sns_topic.saga_events.arn
}

output "consumer_queue_urls" {
  description = "URLs das filas SQS FIFO de cada servico consumidor."
  value       = { for k, q in aws_sqs_queue.consumer : k => q.id }
}

output "consumer_queue_arns" {
  description = "ARNs das filas SQS FIFO de cada servico consumidor."
  value       = { for k, q in aws_sqs_queue.consumer : k => q.arn }
}

output "dlq_arns" {
  description = "ARNs das DLQs de cada servico consumidor."
  value       = { for k, q in aws_sqs_queue.dlq : k => q.arn }
}

output "consumer_policy_arns" {
  description = "ARNs das IAM policies least-privilege de cada servico consumidor, para attach nas futuras IAM Roles de CI/runtime dos repos de servico."
  value       = { for k, p in aws_iam_policy.consumer : k => p.arn }
}
