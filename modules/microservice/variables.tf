variable "name" {
  description = "Nombre del microservicio"
  type        = string
}

variable "branch" {
  description = "Tag de Docker"
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
variable "ami_id" {
  type    = string
  default = "ami-020cba7c55df1f615"
}

variable "jwt_secret" {
  description = "Secret para el microservicio JWT"
  type        = string
}

variable "image_encrypt" {
  description = "Imagen Docker para encrypt"
  type        = string
}

variable "port_encrypt" {
  description = "Puerto para encrypt"
  type        = number
}

variable "image_jwt" {
  description = "Imagen Docker para jwt"
  type        = string
}

variable "port_jwt" {
  description = "Puerto para jwt"
  type        = number
}

variable "image_jwt_validate" {
  description = "Imagen Docker para jwt-validate"
  type        = string
}

variable "port_jwt_validate" {
  description = "Puerto para jwt-validate"
  type        = number
}

variable "tag_encrypt" {
  description = "Tag de Docker para encrypt"
  type        = string
}

variable "tag_jwt" {
  description = "Tag de Docker para jwt"
  type        = string
}

variable "tag_jwt_validate" {
  description = "Tag de Docker para jwt-validate"
  type        = string
}
