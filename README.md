<!-- BEGIN_TF_DOCS -->
<p align="center">                                                                                                                                            
                                                                                
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us Test</a>
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a>
    <a href="https://stratusgrid.com">StratusGrid Home</a>
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>
</p>

# terraform-aws-iam-group-restricted-read-only

GitHub: [StratusGrid/terraform-aws-iam-group-restricted-read-only](https://github.com/StratusGrid/terraform-aws-iam-group-restricted-read-only)

iam-group-restricted-read-only creates a group and associated policies/roles to be able to grant users a restricted read only policy (full read only minus deletion of getting bucket objects, downloading lambda code, etc.) in addition to user self service rights. The default policy requires MFA access for console, but not role assumption(though the role can be switched into), and requires role assumption for cli (best way to do MFA in cli).

This is meant to be used as a one and done solution for people with a single AWS account who want to have/enforce MFA access on their admins.

## Examples

```hcl
module "iam_group_restricted_read_only" {
  source  = "github.com/StratusGrid/terraform-aws-iam-group-restricted-read-only"

  group_name = "${name_prefix}-restricted-read-only"

  s3_bucket_paths_to_allow = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}
```
---
## Using different policies

To use this as a template for a different set of permissions, delete iam-read-only-policy.tf, change the inputs, and policy document/description in iam-policy.tf

---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.role_assumption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.user_self_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Unique string name of iam group to be created. Also prepends supporting resource names | `string` | n/a | yes |
| <a name="input_group_path"></a> [group\_path](#input\_group\_path) | The path (prefix) for the group in IAM | `string` | `"/"` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "StratusGrid",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_s3_bucket_paths_to_allow"></a> [s3\_bucket\_paths\_to\_allow](#input\_s3\_bucket\_paths\_to\_allow) | List of bucket matching ARNs which the read only role should be able to get objects from. Commonly used for cloudtrail and logging buckets... | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_group_id"></a> [iam\_group\_id](#output\_iam\_group\_id) | ID of IAM Group created |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role created |
| <a name="output_iam_role_assumption_url"></a> [iam\_role\_assumption\_url](#output\_iam\_role\_assumption\_url) | URL to assume role in Console |

---

Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->