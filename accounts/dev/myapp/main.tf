terraform {
  backend "local" {}
}

locals {
  relpath_to_root = "../../.."
  
  vars = yamldecode(join("\n", [
    for dir in sort(compact([
      for vf in fileset(path.module, "${local.relpath_to_root}/**/vars.yml") :
      substr(abspath(path.module), 0, length(abspath(dirname(vf)))) == abspath(dirname(vf)) ? abspath(dirname(vf)) : ""
    ])) : file("${dir}/vars.yml")
  ]))
}

module "myapp" {
  source = "../../../modules/myapp"

  env  = "dev"
  name = "myapp"
}
