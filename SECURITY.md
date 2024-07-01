# Security

## Threats

### Internal threats

We don't want our developers to access the Terraform states belonging to other teams. This is for several reasons:
- Developers should be granted access on a need-to-know basis (conforming to SOC2, ISO and other frameworks)
- Sensitive information can show up in the state¹. The file is not encrypted.
- Developers may store sensitive information in the Terraform states by accident (forgetting to use a proper secrets management system)

To address all of these points, we assume that our IAM team is _only_ granting access to the modify the Terraform states belonging to their respective teams. An example to achieve this:

Let's assume we have an S3 bucket per region containing our Terraform states. Within these bucket, we can use different keys to refer to different states, e.g.

```
mercury-terraform-us-east-2/
  services/crm/prod/us-east-2/*tf.tfstate
  services/fraud-detection/dev/us-east-2/*tf.tfstate
```

Then, we define an IAM policy for the role that limits access to a set of files, e.g.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
              "arn:aws:s3:::jesper-tf-state/services/crm/prod/us-east-2/network/tf.tfstate",
              "arn:aws:s3:::jesper-tf-state/services/crm/prod/us-east-2/ecs/tf.tfstate",
              "arn:aws:s3:::jesper-tf-state/services/crm/prod/us-east-2/cloudwatch/tf.tfstate" 
              "arn:aws:s3:::jesper-tf-state/services/crm/prod/us-east-2/opensearch/tf.tfstate"
            ]
        }
    ]
}
```

Ideally, there's a centralized service to deploy all of our Terraform code (e.g. Atlantis). However, there may still be cases where the developers need to directly interact with the Terraform state (e.g. to run `terraform taint` or `terraform state mv`)

¹ A common example is RDS passwords. 

### External threats

When addressing security, it's easy to spend too much time in the defender mindset. As a defender, you have to get things right every time, while the attacker only needs to get one thing right. Because of this, it's often more helpful to imagine yourself as an attacker.

Let's assume we have remote code execution in a container running in Kubernetes. How can we leverage this access, pivot/gain access to other resources on the network? More importantly, which infra-level safety measures can we implement so that even if one of our product teams makes a misconfiguration, attacks will be rendered ineffective?

The first thing that comes to mind is restricting the network traffic. Services such as a database or cache do not need egress networking, so let's not add a NAT gateway to the routing table of their subnets. In other cases, where partial egress networking may be needed, we can whitelist certain CIDRs using a network ACL (in combination with the security groups defined by the applications to follow a "defense in depth" strategy). For ingress, we should only allow access from other internal resources. (e.g. the load balancer)

The second thing that comes to mind is what an attacker can do with service account credentials. Every pod with a service account attached will have a file containg AWS credentials at the `/var/run/secrets/kubernetes.io/serviceaccount/token` path. With these credentials, they can effectively brute-force all of AWS' API methods to determine what they can access. This issue has less to do with networking, but we should encourage developers to use the Access Advisor to determine a set of permissions that's not overreaching¹.

Other things we could consider:
- Obligatory AppArmor or SELinux confinements for compute workloads
- Obligatory mutual TLS (mTLS) between all clients on the network
- SIEM, IDS, or at least AWS GuardDuty
- DLP software
- A network level-firewall

¹ https://aws.amazon.com/blogs/security/remove-unnecessary-permissions-in-your-iam-policies-by-using-service-last-accessed-data/
