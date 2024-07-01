FROM ubuntu:22.04

WORKDIR /app

ENV AWS_VERSION=2.17.2
ENV TERRAGRUNT_VERSION=v0.59.5
ENV TERRAFORM_VERSION=1.8.5

# Prevent issues with file ownership.
# The ID of the user in the container should match
# that of the user on the host machine.
ARG UID
RUN apt-get update \
  && apt-get install -y curl unzip git \
  && useradd --create-home --uid "$UID" infra

RUN cd /tmp \
  && curl -s -O -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" \
  && unzip "awscli-exe-linux-x86_64-${AWS_VERSION}.zip" \
  && cd aws \
  && ./install \
  && rm -rf /tmp/*

RUN cd /tmp \
  && curl -s -L -O "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && mv terraform /usr/local/bin

RUN curl -s -L -o /usr/local/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
  && chmod 755 /usr/local/bin/terragrunt

USER infra

CMD ["sleep", "infinity"]
