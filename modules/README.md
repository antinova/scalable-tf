# Modules

This directory contains our Terraform modules.

## Not invented here

While I would strongly encourage DRY and leveraging popular Terraform modules (e.g. https://github.com/terraform-aws-modules/terraform-aws-vpc in our case); for the sake of this take home project, I've decided not to go that route so that I can demonstrate my understanding of AWS network configuration in Terraform.

## Naming structure

The naming structure follows the best practice:

> "Name your provider `terraform-<PROVIDER>-<NAME>`. You must follow this convention in order to publish to the HCP Terraform or Terraform Enterprise module registries."

As outlined in https://developer.hashicorp.com/terraform/tutorials/modules/module#module-best-practices

## Versioning

When referencing Terraform modules, the `version` field doesn't work when it's referencing a local path. For the sake of keeping this take home project strictly monorepo, I've left out this important step. However, should this ever get promoted to production, it is essential that we store and version the Terraform module in another repository.
