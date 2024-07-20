
variable "subnet_id" {}
variable "instance_type" {}
variable "core_instance_type" {}
variable "core_instance_count" {}
variable "vpc_id" {}
variable "key_name" {}
variable "project" {}
variable "environment" {}
variable "configurations" {}
variable "applications" {}
variable "bucket_log_uri" {
    default = "s3://<emr-logs-<account-id>"
}

# variable "steps" {
#   type = list(object(
#     {
#       name = string
#       action_on_failure = string
#       hadoop_jar_step = list(object(
#         {
#           args       = list(string)
#           jar        = string
#           main_class = string
#           properties = map(string)
#         }
#       ))
#     }
#   ))
#   default = null
# }

resource "aws_emr_cluster" "cluster" {
  name          = "emr-flink-cluster"
  release_label = "emr-7.0.0"
  applications  = var.applications
  log_uri = var.bucket_log_uri
  configurations = var.configurations
  service_role = aws_iam_role.erm_service_role.arn 
  #step = var.steps 


  #termination_protection            = false
  #keep_job_flow_alive_when_no_steps = false

  ec2_attributes {
    key_name = var.key_name
    subnet_id                         = var.subnet_id
    instance_profile                  = aws_iam_instance_profile.emr_ec2_instance_profile.arn
    emr_managed_master_security_group = aws_security_group.main_security_group.id
    emr_managed_slave_security_group  = aws_security_group.core_security_group.id

  }

  master_instance_group {
    instance_type = var.instance_type
    instance_count = 1
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
    ebs_config {
      size                 = "80"
      type                 = "gp2"
      volumes_per_instance = 1
    }

  }
  tags = {
    cluster-name = "emr-flink-cluster"
    env  = "env"
  }


#  lifecycle {
#     ignore_changes = [
#       step
#     ]
#   }

}

output "emr_main_address" {
  value = aws_emr_cluster.cluster.master_public_dns
}