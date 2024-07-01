# Infra

This monorepo provides a scalable, multi-account Terraform configuration that is suitable for medium and larger sized organizations.

## Preassumptions

We already extensive IAM covering the following:

- Definitions of who the users are (ideally sourced from an IdP)
- Which roles they can assume
- Policies for those roles that set constraints on which resources they can access, which actions they can perform.

## Design

Please refer to the [DESIGN.md](DESIGN.md) and [modules/README.md](modules/README.md) page.

## Security

Please refer to the [SECURITY.md](SECURITY.md) page.

## Usage

Tip: Use the included Dev Container configuration which includes all the software packages.

1. **Patch the user ID in the Dev Container configuration.**
```cli
$ NEW_UID=$(id -u) jq --arg newuid "$NEW_UID" '.build.args.UID = $newuid' .devcontainer.json
```

If you don't have jq installed, please run `id -u` and use that value for `build.args.UID` inside the `.devcontainer.json` file.

Then, you can start the Dev Container and run all future commands from within the container.

2. **Update the S3 bucket prefix**

In `terragrunt.hcl`, update the bucket prefix in the key `remote_state.config.bucket`.

3. **Plan and apply all resources**

```cli 
$ terragrunt run-all plan
$ terragrunt run-all apply
```
