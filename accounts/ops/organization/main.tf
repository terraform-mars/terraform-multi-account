terraform {
  backend local {}
}

locals {
  # Must be updated if you move this directory to another dir level
  relpath_to_root = "../../.."
  
  vars = yamldecode(join("\n", [
    for dir in sort(compact([
      for vf in fileset(path.module, "${local.relpath_to_root}/**/vars.yml") :
      substr(abspath(path.module), 0, length(abspath(dirname(vf)))) == abspath(dirname(vf)) ? abspath(dirname(vf)) : ""
    ])) : file("${dir}/vars.yml")
  ]))
}

provider "aws" {
  region = local.vars.aws_region
}

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "sso.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_organizations_account" "accounts" {
  for_each = local.vars["aws_accounts"]

  name  = each.key
  email = each.value.email
}
