# terraform-multi-account

(Work-In-Progress)

An example of how to manage a terraform project with multiple AWS accounts.

### AWS Organizations
* mgt is the management account
  * Maintains the S3 bucket for terraform state files and dynamodb table for terraform locks
* dev/stage/prod are child accounts
  * Allow mgt account to access them via the IAM role _OrganizationAccountAccessRole_

### AWS SSO

The type of credentials that AWS SSO generates currently is not supported on terraform. A lookup for credentials in the aws cli cache is being done as a workaround.

E.g. https://github.com/terraform-mars/terraform-multi-account/blob/main/accounts/dev/myapp/provider.tf

### Shared variables

Variables in a file named "vars.yml" in any level of directory will be read.
The closest relative path of a vars file to the current module directory takes precedence.
