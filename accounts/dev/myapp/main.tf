terraform {
  backend "local" {}
}

locals {
  # Must be updated if you move this directory to another dir level
  relpath_to_root = "../../.."
  
  # Look for shared vars in every dir level up to the repo root directory
  # Variables in nearest files takes precedence
  vars = yamldecode(join("\n", [
    for dir in sort(compact([
      for vf in fileset(path.module, "${local.relpath_to_root}/**/vars.yml") :
      substr(abspath(path.module), 0, length(abspath(dirname(vf)))) == abspath(dirname(vf)) ? abspath(dirname(vf)) : ""
    ])) : file("${dir}/vars.yml")
  ]))
}

module "myapp" {
  source = "../../../modules/myapp"

  env  = local.vars.env
  name = "myapp"
}
