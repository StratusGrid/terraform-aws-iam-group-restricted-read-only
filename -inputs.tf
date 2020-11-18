variable "group_name" {
  description = "Unique string name of iam group to be created. Also prepends supporting resource names"
  type        = string
}

variable "group_path" {
  description = "The path (prefix) for the group in IAM"
  type        = string
  default     = "/"
}

variable "s3_bucket_paths_to_allow" {
  description = "List of bucket matching ARNs which the read only role should be able to get objects from. Commonly used for cloudtrail and logging buckets..."
  type        = list(string)
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

