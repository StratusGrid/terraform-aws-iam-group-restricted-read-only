# iam-group-restricted-read-only
iam-group-restricted-read-only creates a group and associated policies/roles to be able to grant users a restricted read only policy (full read only minus deletion of getting bucket objects, downloading lambda code, etc.) in addition to user self service rights. The default policy requires MFA access for console, but not role assumption(though the role can be switched into), and requires role assumption for cli (best way to do MFA in cli).

This is meant to be used as a one and done solution for people with a single AWS account who want to have/enforce MFA access on their admins.

### Example Usage:
```
module "iam_group_restricted_read_only" {
  source  = "GenesisFunction/iam-group-restricted-read-only/aws"
  version = "1.0.2"
  # source  = "github.com/GenesisFunction/terraform-aws-iam-group-restricted-read-only"

  group_name = "${name_prefix}-restricted-read-only"

  s3_bucket_paths_to_allow = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}
```

### Using different policies
To use this as a template for a different set of permissions, delete iam-read-only-policy.tf, change the inputs, readme, and policy document/description in iam-policy.tf

NOTE - The MFA restrictions come from the DENY on the user self service policy. If that is removed, you should make two of the restricted-admin(or your replacement) policies, make one be used in the role and not have the BOOL MFA conditions, and have one be for the direct group attachment and have the conditions.
