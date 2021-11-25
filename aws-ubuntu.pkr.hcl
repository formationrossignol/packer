packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-linux-aws"
  instance_type = "t2.micro"
  region        = "eu-west-3"
  source_ami_filter {
    filters = {
      image-id            = "ami-06d79c60d7454e2af"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners      = ["099720109477"]

  }
  ssh_username = "ubuntu"
}

build {
  name    = "build-nginx"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "shell" {
    inline = [
      "echo Installing nginx",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
}
