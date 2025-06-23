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
  default = "vpc-0bd3d78866e1a84fe"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-069c95c7245ffac3b", "subnet-0920caca965c22b39"]
}

variable "ami_id" {
  type    = string
  default = "ami-04b4f1a9cf54c11d0"
}
