# terraform-multi-account

(Work-In-Progress)

An example of how to manage a terraform project with multiple AWS accounts.

### AWS Organizations
* Ops is the Master account
  * Maintains the S3 bucket for terraform state files
* Dev/Stage/Prod are child accounts
  * Allow Ops account to access them via the IAM role _OrganizationAccountAccessRole_

### Shared variables

Variables in a file named "vars.yml" in any level of directory will be read.
The closest relative path of a vars file to the current module directory takes precedence.
