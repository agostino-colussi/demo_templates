#####################################################################
##
## Created 5/7/19 by Ago/Radu for IBM Cloudant_credentials_creation
##
#####################################################################

output "apikey" {
  value = "${camc_scriptpackage.apikey.result["stdout"]}"
}

output "host" {
  value = "${camc_scriptpackage.host.result["stdout"]}"
}

output "iam_apikey_description" {
  value = "${camc_scriptpackage.iam_apikey_description.result["stdout"]}"
}

output "iam_apikey_name" {
  value = "${camc_scriptpackage.iam_apikey_name.result["stdout"]}"
}

output "iam_serviceid_crn" {
  value = "${camc_scriptpackage.iam_serviceid_crn.result["stdout"]}"
}

output "password" {
  value = "${camc_scriptpackage.password.result["stdout"]}"
}

output "port" {
  value = "${camc_scriptpackage.port.result["stdout"]}"
}

output "url" {
  value = "${camc_scriptpackage.url.result["stdout"]}"
}

output "username" {
  value = "${camc_scriptpackage.username.result["stdout"]}"
}

