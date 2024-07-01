include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}/modules/terraform-aws-network"
}

inputs = {
  vpc_name = "treasury-app"
  vpc_cidr_block = "10.0.0.0/16"

  private_subnets = [
    {cidr_block: "10.0.0.0/24", availability_zone: "us-east-1a"},
    {cidr_block: "10.0.1.0/24", availability_zone: "us-east-1b"},
    {cidr_block: "10.0.2.0/24", availability_zone: "us-east-1c"}
  ]
  public_subnets = [
    {cidr_block: "10.0.3.0/24", availability_zone: "us-east-1a"},
    {cidr_block: "10.0.4.0/24", availability_zone: "us-east-1b"},
    {cidr_block: "10.0.5.0/24", availability_zone: "us-east-1c"}
  ]
}
