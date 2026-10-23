provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "oficina"
      Component   = "messaging-infrastructure"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
