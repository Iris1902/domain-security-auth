terraform {
  backend "s3" {
    bucket         = "domain-security-auth-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
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

# Módulos para cada microservicio que desees desplegar
module "encrypt" {
  source       = "./modules/microservice"
  name         = "encrypt"
  image        = "ievinan/microservice-encrypt"
  port         = 8080
  branch       = "dev"
}