terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket        = "hanny-terraform-state"
    key           = "devops/terraform.tfstate"
    region        = "ap-southeast-3"
    use_lockfile  = true
    encrypt       = true
  }
}

# Primary provider for CloudFront (must be us-east-1)
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "PersonalWebsite"
      Environment = var.environment
      ManagedBy   = "OpenTofu"
      Owner       = "HannyPrastya"
    }
  }
}

# Provider for ACM certificate (CloudFront requires certificates in us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "PersonalWebsite"
      Environment = var.environment
      ManagedBy   = "OpenTofu"
      Owner       = "HannyPrastya"
    }
  }
}
