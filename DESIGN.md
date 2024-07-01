# Design

This document explains the rationale behind the architectural decisions of this Terraform monorepo, which serves as the foundation for our organization.

## Prelude: Terraform scalability issues

This section covers the primary problem I set out to solve:

When using Terraform in a bigger organization, Terraform configuration becomes daunting. It's easy to lose overview and end up repeating code too many times. Unfortunately, although the DRY (Don't Repeat Yourself) principle is widely spread within the Terraform ecosystem, Terraform itself does not allow us to fully achieve it. Fortunately, Gruntworks developed a tool to address these shortcomings: Terragrunt.

Terragrunt is a thin wrapper around Terraform, which gives the ability to automatically generate backend and provider blocks. Additionally, it:
- Solves the classic dilemma of "Which Terraform state do I need to apply first?". Terragrunt can build a dependency graph between them.
- Simplifies authorization - automatically assumes the correct IAM role for you.

And it provides many other features: https://terragrunt.gruntwork.io/docs/#features

## Current feature set

The repository contains a Terraform module for setting up:
- VPC
- Subnets in 3 AZs
- NAT Gateway
- Internet Gateway
- Route Tables

We've hardcoded some defaults into these modules to ensure parity between environments. Additionally, we've limited the exposed variables to prevent developers from overriding settings that can impact security.

Each of the modules are referenced in an directory that's specific to the service, environment, region, and component. Example:

```
services/
  crm/
    dev/
      us-west-1/
        opensearch/
  fraud-detection/
    prod/
      us-east-1/
        network/
      us-east-2/
        ecs/
```

### Other notable features:

**Dev Containers**

Any developer can get up and running with this Terraform code immediately. All the prerequisites are installed with version contraints, and we can have a reasonable expectation¹ that issues won't arise from differences in environments

¹ It can't be fully eliminated. Case study: ARM64 (M1/2/3 Macs) vs. AMD64 Docker containers

**Traceability**

We're automatically tagging all AWS resources with the path of the Terraform configuration.

## Roadmap

Due to this being a take home project, there were items I wanted to include, but was not able to due to the significant time investment required:

**Setting constraints via OPA**

Although we have provided a solid foundation for other developers to build upon, we don't always know what they will build on top of it. Unfortunately, there are risks that they might introduce code that introduces security risks or doesn't adhere to Terraform best practices. 

One potential solution to this problem is implementing [Open Policy Agent](https://spacelift.io/blog/what-is-open-policy-agent-and-how-it-works) in our CI pipeline².

**Provide a brief internal documentation about best practices**

Examples:
- Instead of remote state, use data sources wherever possible to get the most up-to-date version of a resource
- Don't let the blast radius grow too big
- Convert commonly used configurations into modules
- Use version contraints when calling modules

**Consider refactoring the AWS accounts structure**

Within smaller organizations, it makes sense to limit the number of accounts so that resources can be discovered easily. However, in large organizations, there's often an AWS account per product/service. 

The good news is that our current Terraform codebase is already equipped for such restructuring.

**Add linting and validation to CI**

Add at least: `terraform fmt` and `terraform validate`. Even better, incorporate [tflint](https://github.com/terraform-linters/tflint) which detects issues that `terraform validate` does not.

**Improve the Dockerfile**

Rather than installing packages manually, let's use NixOS with a store that contains the software packages we need (Terraform, Terragrunt, AWS). This will also allow us to address other issues, such as validating the checksums of the downloaded packages from upstream.

**Add `examples` directories in each Terraform module**

We want our users to get up and running quickly, as well as showcasing different ways to use our Terraform modules.

For example, one common mistake users make with load balancers is not setting the ELB tags on the subnets.

**Add VPC endpoints**

For cost savings, let's enable gateway endpoints to services such as S3, so that this traffic doesn't leave the AWS network.

**Add VPC flow logs**

For security and auditing purposes, it's considered best practice to enable VPC flow logs. Let's update our Terraform network module to support this.
