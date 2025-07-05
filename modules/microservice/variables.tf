variable "name" {
  description = "Nombre del microservicio"
  type        = string
}

variable "image" {
  description = "Imagen Docker"
  type        = string
}

variable "port" {
  description = "Puerto expuesto"
  type        = number
}

variable "branch" {
  description = "Tag de Docker"
  type        = string
}

variable "vpc_id" {
  type    = string
  default = "vpc-0697808a974fef452"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-0049cf73cb42dc01f", "subnet-03bd5e4b54dfcfb6e"]
}

variable "ami_id" {
  type    = string
  default = "ami-020cba7c55df1f615"
}

variable "jwt_secret" {
  description = "Secret para el microservicio JWT"
  type        = string
}
