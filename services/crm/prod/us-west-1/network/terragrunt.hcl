include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}/modules/terraform-aws-network"
}

inputs = {
  vpc_name = "crm"
  vpc_cidr_block = "10.30.0.0/16"

  private_subnets = [
    {cidr_block: "10.30.0.0/24", availability_zone: "us-west-1a"},
    {cidr_block: "10.30.1.0/24", availability_zone: "us-west-1b"},
    {cidr_block: "10.30.2.0/24", availability_zone: "us-west-1c"}
  ]
  public_subnets = [
    {cidr_block: "10.30.3.0/24", availability_zone: "us-west-1a"},
    {cidr_block: "10.30.4.0/24", availability_zone: "us-west-1b"},
    {cidr_block: "10.30.5.0/24", availability_zone: "us-west-1c"}
  ]
}
