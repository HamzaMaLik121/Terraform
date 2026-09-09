terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "billionaire-state-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "Hamza-billionaire-state-table"
    
    
  }
}

