terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = ""
}



module ecr_business {
  source = "../module/ecr"
  ecr_repos_names = var.ecr_repos_names_business
}



module lambda_business {
  source = "../module/lambda_business"
  lambda_names_business = var.lambda_names_business
  ecr_repos_names_business = var.ecr_repos_names_business
}


module ecr_processor {
  source = "../module/ecr"
  ecr_repos_names = var.ecr_repos_names_processor
}


module "lambda_processor" {
  source = "../module/lambda_processor"
  lambda_names_processor = var.lambda_names_processor
  ecr_repos_names_processor = var.ecr_repos_names_processor
}