variable "aws_iam_role_names" {
  description = <<-DESCRIPTION
    Optional mapping of GitHub repos to names of IAM roles that will be assumed by GitHub for OIDC.
    If set, the IAM role name for the repo will be exactly the variable value (64 characters max).

    Example: `{ "really-long-github-org-name/really-long-github-repo-name" = "custom-role-name" }`

    If unset, the default IAM role name for each repo will be
    `<aws_iam_role_prefix><aws_iam_role_separator><repo_owner><aws_iam_role_separator><repo_name>`,
    truncated to 64 characters.
  DESCRIPTION
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for key, value in var.aws_iam_role_names : length(value) <= 64])
    error_message = "The IAM role name must be less than or equal to 64 characters."
  }
}

variable "aws_iam_role_prefix" {
  description = "Prefix for name of IAM role that will be assumed by GitHub for OIDC"
  type        = string
  default     = "github-actions-oidc"
}

variable "aws_iam_role_separator" {
  description = "Character to use to separate words in name of IAM role"
  type        = string
  default     = "-"
}

variable "create_oidc_provider" {
  description = <<-DESCRIPTION
    Each AWS account can only have one OIDC provider for a given URL. Attempts to create a second
    provider will error with `409 EntityAlreadyExists`. This module accommodates this limitation
    by allowing multiple repos to be passed in. A single module block will create a single OIDC
    provider and a role for each repo. In some cases, such as during testing, it may be useful to
    avoid creating the OIDC provider entirely. Set this variable to `false` to disable creation of
    the OIDC provider.
  DESCRIPTION
  type        = bool
  default     = true
}

variable "github_custom_claim" {
  description = "Custom OIDC claim for more specific access scope within a repository"
  type        = string
  default     = "*"
}

variable "github_repos" {
  description = "Set of GitHub repositories to configure, in owner/repo format"
  type        = set(string)
}
