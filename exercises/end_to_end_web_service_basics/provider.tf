#################################
# DO NOT MODIFY THIS FILE
# This file configures terraform to interact with AWS, and does not need editing for the exercises.
#################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"

  default_tags {
    tags = {
      Purpose       = "Learner Created Exercise Resource"
      CurriculumKey = "containerised_web_services"
      ModuleKey     = "end_to_end_web_service_basics"
      CreatedBy     = var.attendance_id
      CreatedWith   = "Terraform"
    }
  }
}
