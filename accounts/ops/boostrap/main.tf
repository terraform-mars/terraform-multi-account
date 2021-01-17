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
  region = local.vars.region
}

resource "aws_s3_bucket" "this" {
  bucket = "terraform-states"

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "this" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
