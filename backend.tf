# Backend remoto (S3 + DynamoDB lock) - reaproveita o MESMO bucket e tabela de
# lock dos demais repositorios da Fase 3/4, com uma "key" propria para isolar
# o state deste repositorio.
#
# Os valores reais de bucket/region/dynamodb_table sao passados no
# `terraform init` via `-backend-config` (local) ou ja resolvidos no workflow
# de CI/CD, para evitar hardcode de nomes especificos de conta/ambiente aqui.
terraform {
  backend "s3" {
    key            = "oficina-messaging/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "oficina-db-terraform-locks"
  }
}
