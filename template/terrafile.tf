provider "aws" {
  region  = "us-east-2"
#  version = "~> 3.0"
}

terraform {
  backend "s3" {
    bucket = "appmetalcorp"
    key    = "app/rapadura-terraform.tfstate"
    region = "us-east-2"
  }
} 

module "app-deploy" {
  source                 = "git::https://github.com/EzzioMoreira/modulo-awsecs-fargate.git?ref=master"
  containers_definitions = data.template_file.containers_definitions_json.rendered
  environment            = "production"
  app_name               = "metalcorp"
  app_count              = "2"
  app_port               = "8080"
  fargate_version        = "1.4.0"
  cloudwatch_group_name  = "metalcorp"
}

output "load_balancer_dns_name" {
  value = "http://${module.app-deploy.loadbalance_dns_name}"
}

data "template_file" "containers_definitions_json" {
  template = file("./containers_definitions.json")

  vars = {
    APP_VERSION = var.APP_VERSION
    APP_IMAGE   = var.APP_IMAGE
    AWS_ACCOUNT = var.AWS_ACCOUNT
  }
}

variable "APP_VERSION" {
  default   = ${TAG_IMAGE}
  description = "Version comes from git commit in Makefile"
}

variable "APP_IMAGE" {
  default   = "metalcorp"
  description = "Name comes from variable APP_IMAGE in Makefile"
}

variable "AWS_ACCOUNT" {
  default   = "520044189785"
  description = "Get the value of variable AWS_ACCOUNT in Makefile"
}
