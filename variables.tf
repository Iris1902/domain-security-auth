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
