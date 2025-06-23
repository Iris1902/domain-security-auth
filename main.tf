terraform {
  backend "s3" {
    bucket         = "domain-security-auth-tfstate"
    key            = "terraform.tfstate"
    region         = var.AWS_REGION
    dynamodb_table = "domain-security-auth-tfstate-locks"
    encrypt        = true
  }
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

# --- Recursos para crear S3 y DynamoDB para el backend remoto (SOLO USAR SI NECESITAS CREARLOS DE NUEVO) ---
# resource "aws_s3_bucket" "terraform_state" {
#   bucket        = "domain-security-auth-tfstate"
#   force_destroy = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "domain-security-auth-tfstate-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# Módulos para cada microservicio que desees desplegar
module "encrypt" {
  source       = "./modules/microservice"
  name         = "encrypt"
  image        = "ievinan/microservice-encrypt"
  port         = 8080
  branch       = "dev"
}