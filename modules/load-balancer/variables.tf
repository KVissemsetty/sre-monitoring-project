variable "name" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "app_port" {
  type = number
}
variable "vpc_id" {
  type = string
}
variable "health_check_path" {
  type = string
  default = "/"
}