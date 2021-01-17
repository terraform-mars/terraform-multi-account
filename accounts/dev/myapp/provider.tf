provider "aws" {
  region = local.vars.region
  alias  = "mgt"
}

data "aws_caller_identity" "mgt" {
  provider = aws.mgt
}

provider "aws" {
  region = local.vars.region
  assume_role {
    role_arn     = "arn:aws:iam::${local.vars.accounts.dev.id}:role/${local.vars.accounts.dev.role}"
    session_name = split(":", data.aws_caller_identity.mgt.user_id)[1]
  }
}
