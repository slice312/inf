packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux-sandbox" {
  region        = "us-east-1"
  ami_name      = var.ami_name
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"


  source_ami_filter {
    owners = ["137112412989"]

    filters = {
      name                = "al2023-ami-2023.5.20240916.0-kernel-6.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
  }

}

build {
  name = "amazon-linux-sandbox"
  sources = [
    "source.amazon-ebs.amazon-linux-sandbox"
  ]

  provisioner "shell" {
    environment_vars = [
      "GREETING=kek",
    ]
    inline = [
      "sudo dnf group install -y 'Development Tools'",
      "sudo dnf install -y nc",
      "sudo dnf install -y telnet",
      "sudo dnf install -y jq",
      # TODO: yaml query yq
      "sudo dnf install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl status httpd",
      "echo '&lt;Region&gt; - &lt;Node #&gt' | sudo tee /var/www/html/index.html > /dev/null"
    ]
    expect_disconnect = true
  }

  post-processor "manifest" {
    output     = "manifest.json"
  }
}
