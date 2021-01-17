provider "aws" {
  region = local.vars.region
  alias  = "ops"
}

data "aws_caller_identity" "ops" {
  provider = aws.ops
}

provider "aws" {
  region = local.vars.region
  assume_role {
    role_arn     = "arn:aws:iam::413213983779:role/${local.vars.accounts.dev.role}"
    session_name = split(":", data.aws_caller_identity.ops.user_id)[1]
  }
}
