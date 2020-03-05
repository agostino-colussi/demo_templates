##############################################################
# Define the output variables
##############################################################

output "public_ip" {
  value = "${aws_instance.orpheus_ubuntu_micro.public_ip}"
}
