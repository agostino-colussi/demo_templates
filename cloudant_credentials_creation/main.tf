####################################################################
##
## Created 5/7/19 by Ago/Radu for IBM Cloudant_credentials_creation
##
#####################################################################

provider "null" {
  version = "~> 0.1"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "null_resource" "cloudant" {
    connection {
      host = "${var.vm_address}"
      type = "ssh"
      user = "${var.ssh_user}"
      password = "${var.ssh_user_password}"
    }
    
    provisioner "remote-exec" {
      inline = [
          "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}",
        ]
    }

    provisioner "file" {
        content = <<EOF
    #!/bin/bash
    #
    export BLUEMIX_API_KEY=${var.bluemix_key}
    ibmcloud config --check-version=false > /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud login -a https://cloud.ibm.com -r us-south >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud target --cf-api https://api.us-south.cf.cloud.ibm.com -o agostino.colussi -s Test >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud service key-create ${var.service_name} ${var.service_credentials_name} >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    com_response=$(ibmcloud service key-show ${var.service_name} ${var.service_credentials_name})
    echo $com_response | awk 'match($0,"{"){print substr($0,RSTART)}' >> /tmp/${random_string.random-dir.result}/com_output
    EOF
        destination = "/tmp/${random_string.random-dir.result}/create_credentials.sh"
    }
    
    provisioner "file" {
        content = <<EOF
    #!/bin/bash
    #
    export BLUEMIX_API_KEY=${var.bluemix_key}
    ibmcloud config --check-version=false >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud login -a https://cloud.ibm.com -r us-south >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud target --cf-api https://api.us-south.cf.cloud.ibm.com -o agostino.colussi -s Test >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    ibmcloud service key-delete ${var.service_name} ${var.service_credentials_name} -f >> /tmp/${random_string.random-dir.result}/create_cloudant_credentials.log 2>&1
    EOF
        destination = "/tmp/${random_string.random-dir.result}/delete_credentials.sh"
    }
 
    provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/${random_string.random-dir.result}/create_credentials.sh",
        "/tmp/${random_string.random-dir.result}/create_credentials.sh",
      ]
    }

    provisioner "remote-exec" {
    when    = "destroy"
    inline = [
      "chmod +x /tmp/${random_string.random-dir.result}/delete_credentials.sh",
      "/tmp/${random_string.random-dir.result}/delete_credentials.sh",
      "rm -fr /tmp/${random_string.random-dir.result}",
    ]
  }
}

resource "camc_scriptpackage" "apikey" {
  program = ["jq", "--raw-output '.apikey' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "host" {
  program = ["jq", "--raw-output '.host' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "iam_apikey_description" {
  program = ["jq", "--raw-output '.iam_apikey_description' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "iam_apikey_name" {
  program = ["jq", "--raw-output '.iam_apikey_name' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "iam_serviceid_crn" {
  program = ["jq", "--raw-output '.iam_serviceid_crn' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "password" {
  program = ["jq", "--raw-output '.password' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "port" {
  program = ["jq", "--raw-output '.port' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "url" {
  program = ["jq", "--raw-output '.url' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}

resource "camc_scriptpackage" "username" {
  program = ["jq", "--raw-output '.username' /tmp/${random_string.random-dir.result}/com_output"]
  depends_on = ["null_resource.cloudant"]
  remote_host = "${var.vm_address}"
  remote_user = "${var.ssh_user}"
  remote_password = "${var.ssh_user_password}"
  on_create = true
}