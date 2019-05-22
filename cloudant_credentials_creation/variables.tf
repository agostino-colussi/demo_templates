#####################################################################
##
## Created 5/7/19 by Ago/Radu for IBM Cloudant_credentials_creation
##
#####################################################################

variable "vm_address" {
  description = "The IPv4 address of virtual machine where IBM CLI is installed"
}

variable "ssh_user" {
  description = "The user for ssh connection, which is default in template"
  default     = "root"
}

variable "ssh_user_password" {
  description = "The user password for ssh connection, which is default in template"
  default = "passw0rd"
}

variable "bluemix_key" {
  description = "The IBM Cloud key to access Cloud"
}

variable "service_instance_name" {
  description = "Cloudant service instance name"
}

variable "service_credentials_name" {
  description = "The Service Key name"
}