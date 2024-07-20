variable "region" { default = "us-east-2" }
variable "owner" {  }
variable "project" { }
variable "environment" {  }
variable "emr_main_instance_type" {}
variable "emr_core_instance_type" {}
variable "emr_core_instance_count" {}


provider "aws" {
  region = var.region 
}

# Configurações do Flink
locals {
  configurations_json = jsonencode([
    {
      "Classification" : "flink-conf",
      "Properties" : {
        "parallelism.default" : "2",
        "taskmanager.numberOfTaskSlots" : "2",
        "taskmanager.memory.process.size" : "2G",
        "jobmanager.memory.process.size" : "1G",
        "execution.checkpointing.interval" : "180000",
        "execution.checkpointing.mode" : "EXACTLY_ONCE"
      }
    }
  ])
}

# Locals
locals {
  tags = {
    "owner"   = var.owner
    "project" = var.project
    "stage"   = var.environment
  }
}

module "ssh" {
  source = "./ssh"
  environment = var.environment
  project = var.project
}

module network {
  source = "./network"
  tags = local.tags
}

module "emr" {
  source = "./emr"
  environment = var.environment
  instance_type = var.emr_main_instance_type
  key_name = module.ssh.deployer_key_name
  core_instance_type = var.emr_core_instance_type
  core_instance_count = var.emr_core_instance_count
  vpc_id = module.network.vpc_id
  applications = ["Hadoop", "Flink", "Zeppelin"]
  project = var.project
  subnet_id = module.network.public_subnets_1
  configurations = local.configurations_json
}

output "emr_main_address" {
  value = module.emr.emr_main_address
}