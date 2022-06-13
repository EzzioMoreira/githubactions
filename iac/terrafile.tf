provider "aws" {
  region  = "us-east-2"
  version = "~> 3.0"
}

terraform {
  backend "s3" {
    bucket = "your-bucket-here"
    key    = "path/keyname-terraform-.tfstate"
    region = "us-east-2"
  }
} 

module "app-deploy" {
  source                 = "git@github.com:EzzioMoreira/modulo-awsecs-fargate.git?ref=master"
  containers_definitions = data.template_file.containers_definitions_json.rendered
  environment            = "your-environment"
  app_name               = "your-app-name"
  app_count              = "2"
  app_port               = "80"
  fargate_version        = "1.4.0"
  cloudwatch_group_name  = "your-grouplog-name"
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
  default   = "latest"
  description = "Version comes from git commit in Makefile"
}

variable "APP_IMAGE" {
  default   = "your-image-name"
  description = "Name comes from variable APP_IMAGE in Makefile"
}

variable "AWS_ACCOUNT" {
  default   = "your-account-id"
  description = "Get the value of variable AWS_ACCOUNT in Makefile"
}
