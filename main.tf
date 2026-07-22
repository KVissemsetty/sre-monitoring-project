provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  name = "sre-monitoring"
  azs = ["us-east-1a","us-east-1b"]
  private_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}