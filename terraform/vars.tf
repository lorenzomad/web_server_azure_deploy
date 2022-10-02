variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = udacity
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "South Central US"
}

variable "username" {
  description = "the username of the virtual machine"
  default = udacity_username 
}

variable "password" {
  description = "the password for the account of the virtual machine"
  default = "defauLTPAssword"
}
variable "counter" {
  description = "the number of virtual machines to create"
  type = number
  default = 2
}

