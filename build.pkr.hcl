packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

source "amazon-ebs" "windows-2022" {
  ami_name      = "${local.group}-${local.division}-${local.platform}-Windows-2022-Full-Base-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  user_data_file   = "./winrm_bootstrap.txt"
  force_deregister = true
  winrm_insecure   = true
  winrm_username   = "Administrator"
  winrm_use_ssl    = true
}

// source "amazon-ebs" "rhel-9" {
//   ami_name = ""
//   communicator = "ssh"
//   instance_type = "ssh"
//   region = var.region
//   source_ami_filter {
//     filters = {
//       name = ""
//       root-device-type = "ebs"
//       virtualization-type = "hvm"
//     }
//     most_recent = true
//     owners = ["amazon"]
//   }

//   user_data_file = ""
//   force_deregister = true 
// }

build {
  // name    = "temp-build-windows-2022"
  sources = ["source.amazon-ebs.windows-2022"]

  // provisioner "ansible" {
  //   playbook_file = "./cis-security/roles/cis_security/tasks/main.yml"
  //   extra_arguments = [
  //     "--extra-vars",
  //     "ansible_distribution=${var.ansible_distribution}",
  //     "ansible_distribution_major_version=${var.ansible_distribution_major_version}"
  //   ]
  // }
}