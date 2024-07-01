include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}/modules/terraform-aws-network"
}

inputs = {
  vpc_name = "fraud-detection"
  vpc_cidr_block = "10.40.0.0/16"

  private_subnets = [
    {cidr_block: "10.40.0.0/24", availability_zone: "us-west-2a"},
    {cidr_block: "10.40.1.0/24", availability_zone: "us-west-2b"},
    {cidr_block: "10.40.2.0/24", availability_zone: "us-west-2c"}
  ]
  public_subnets = [
    {cidr_block: "10.40.3.0/24", availability_zone: "us-west-2a"},
    {cidr_block: "10.40.4.0/24", availability_zone: "us-west-2b"},
    {cidr_block: "10.40.5.0/24", availability_zone: "us-west-2c"}
  ]
}
