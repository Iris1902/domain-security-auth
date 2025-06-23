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
  default = "vpc-07d9bd0b898725449"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-041cbc7f89b590956", "subnet-03a0b49bf24b5e7f9"]
}

variable "ami_id" {
  type    = string
  default = "ami-04b4f1a9cf54c11d0"
}
