variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "AWS_SESSION_TOKEN" {
  type = string
}

variable "BRANCH_NAME" {
  type    = string
  default = "dev"
}

variable "jwt_secret" {
  description = "Secret para el microservicio JWT"
  type        = string
}

variable "vpc_id" {
  type        = string
  default = "vpc-07ed6f622674768b4"
  description = "VPC ID para los recursos"
}

variable "subnet1" {
  type        = string
  default = "subnet-0695499f8e7e48f1f"
  description = "ID de la primera subnet"
}

variable "subnet2" {
  type        = string
  default = "subnet-05d8f02253a448f99"
  description = "ID de la segunda subnet"
}

variable "image_jwt_validate" {
  description = "Imagen Docker para jwt-validate"
  type        = string
}