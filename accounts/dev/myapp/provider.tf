#
# The credentials type that AWS SSO generates is currently not supported in terraform.
# A lookup for credentials in the aws cli cache is being done as a workaround.
# Important: Make sure that you have "jq" installed.
#

# Create access keys in aws cli cache
data "external" "caller_id" {
  program = ["aws", "sts", "get-caller-identity", "--output", "json"]
}

# Fetch credentials from aws cli cache. Requires jq pkg
data "external" "aws_creds" {
  program    = ["jq", ".Credentials", "${pathexpand("~")}/${tolist(fileset(pathexpand("~"), ".aws/cli/cache/*.json"))[0]}"]
  depends_on = [data.external.caller_id]
}

provider "aws" {
  access_key = data.external.aws_creds.result["AccessKeyId"]
  secret_key = data.external.aws_creds.result["SecretAccessKey"]
  token      = data.external.aws_creds.result["SessionToken"]
  region     = local.vars.aws_region
  alias      = "mgt"
}

data "aws_caller_identity" "mgt" {
  provider = aws.mgt
}

provider "aws" {
  access_key = data.external.aws_creds.result["AccessKeyId"]
  secret_key = data.external.aws_creds.result["SecretAccessKey"]
  token      = data.external.aws_creds.result["SessionToken"]
  region     = local.vars.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${local.vars.aws_accounts["jneves-dev"].id}:role/${local.vars.aws_accounts["jneves-dev"].role}"
    session_name = split(":", data.aws_caller_identity.mgt.user_id)[1]
  }
}
