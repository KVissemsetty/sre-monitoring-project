variable "image_id" {
  type = string
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "name" {
  type = string
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "desired_capacity" {
  type = number
}
variable "subnet_ids" {
  type = list(string)
}