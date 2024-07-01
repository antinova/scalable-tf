include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}/modules/terraform-aws-network"
}

inputs = {
  vpc_name = "transaction-processing"
  vpc_cidr_block = "10.60.0.0/16"

  private_subnets = [
    {cidr_block: "10.60.0.0/24", availability_zone: "us-east-2a"},
    {cidr_block: "10.60.1.0/24", availability_zone: "us-east-2b"},
    {cidr_block: "10.60.2.0/24", availability_zone: "us-east-2c"}
  ]
  public_subnets = [
    {cidr_block: "10.60.3.0/24", availability_zone: "us-east-2a"},
    {cidr_block: "10.60.4.0/24", availability_zone: "us-east-2b"},
    {cidr_block: "10.60.5.0/24", availability_zone: "us-east-2c"}
  ]
}
