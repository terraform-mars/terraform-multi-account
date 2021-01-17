provider "aws" {
  region = local.vars.aws_region
  alias  = "mgt"
}

data "aws_caller_identity" "mgt" {
  provider = aws.mgt
}

provider "aws" {
  region = local.vars.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${local.vars.aws_accounts.dev.id}:role/${local.vars.aws_accounts.dev.role}"
    session_name = split(":", data.aws_caller_identity.mgt.user_id)[1]
  }
}
