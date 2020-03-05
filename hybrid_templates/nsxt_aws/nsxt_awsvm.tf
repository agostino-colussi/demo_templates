#################################################################
# Template that will deploy a switch on NSX-T server and
# one VMs in AWS cloud
# Not a real scenario but an example of template that could be deployed
# on two different cloud connections
#
# Licensed Materials - Property of IBM
#
# ©Copyright IBM Corp. 2020.
#
#################################################################

provider "aws" {
  version = "~> 2.0"
  region  = "${var.aws_region}"
}

variable "hostname-tag" {
  description = "The hostname of server"
  default     = "agostino-ec2"
} 

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "vpc_name_tag" {
  description = "Name of the Virtual Private Cloud (VPC) this resource is going to be deployed into"
}

variable "subnet_name" {
  description = "Subnet Name"
}

variable "aws_image_size" {
  description = "AWS Image Instance Size"
  default     = "t2.small"
}

data "aws_vpc" "selected" {
  state = "available"

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_tag}"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_name}"]
  }
}

variable "public_ssh_key_name" {
  description = "Name of the public SSH key used to connect to the virtual guest"
}

variable "public_ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
}

#Variable : AWS image name
variable "aws_image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default     = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "aws_ami_owner_id" {
  description = "AWS AMI Owner ID"
  default     = "099720109477"
}

# Lookup for AMI based on image name and owner ID
data "aws_ami" "aws_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_image}*"]
  }

  owners = ["${var.aws_ami_owner_id}"]
}

resource "aws_key_pair" "orpheus_public_key" {
  key_name   = "${var.public_ssh_key_name}"
  public_key = "${var.public_ssh_key}"
}

resource "aws_instance" "orpheus_ubuntu_micro" {
  instance_type = "${var.aws_image_size}"
  ami           = "${data.aws_ami.aws_ami.id}"
  subnet_id     = "${data.aws_subnet.selected.id}"
  key_name      = "${aws_key_pair.orpheus_public_key.id}"
  
  tags {
    Name = "${var.hostname-tag}"
  }
  
}

#################################################################
#
# Define a NSX tag which can be used later to easily to
# search for the created objects in NSX.
#
#################################################################

variable "nsxt_tag_scope" {
  type = "string"
}

variable "nsxt_tag" {
  type = "string"
}

#
# Define a NSX transport zone needed by switch
#
variable "nsxt_transport_zone" {
  type = "string"
}

variable "nsxt_logical_switch_name" {
  type = "string"
}

variable "nsxt_logical_switch_desc" {
  type = "string"
}

variable "nsxt_logical_switch_state" {
  default = "UP"
  type = "string"
}

variable "nsxt_logical_switch_repl_mode" {
  default = "MTEP"
  type = "string"
}

##############################################################
# Define the nsxt provider
##############################################################
provider "nsxt" {

}

#
#Transport Zone DS
#
data "nsxt_transport_zone" "transport_zone1" {
  display_name = "${var.nsxt_transport_zone}"
}

#
# Create a NSX logical switch to which you
# can attach virtual machines.
#
resource "nsxt_logical_switch" "switch1" {
  admin_state       = "${var.nsxt_logical_switch_state}"
  description       = "${var.nsxt_logical_switch_desc}"
  display_name      = "${var.nsxt_logical_switch_name}"
  transport_zone_id = "${data.nsxt_transport_zone.transport_zone1.id}"
  replication_mode  = "${var.nsxt_logical_switch_repl_mode}"

  tag {
    scope = "${var.nsxt_tag_scope}"
    tag   = "${var.nsxt_tag}"
  }
}

