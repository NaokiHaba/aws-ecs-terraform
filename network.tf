module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  public_subnet_names  = ["aws-ecs-terraform-public-subnet-1", "aws-ecs-terraform-public-subnet-2"]
  private_subnet_names = ["aws-ecs-terraform-private-subnet-1", "aws-ecs-terraform-private-subnet-2"]


  enable_dns_hostnames = true
  enable_nat_gateway   = true
  enable_dns_support   = true
}
