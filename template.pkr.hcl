variable "vagrant_cloud_access_token" {
  type = string
}

variable "vagrant_cloud_box_tag" {
  type = string
}

source "vagrant" "bionic" {
  source_path  = "ubuntu/bionic64"
  communicator = "ssh"
  provider     = "virtualbox"
}

build {
  sources = [
    "sources.vagrant.bionic"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python python-pip",
      "sudo pip install aws-sam-cli"
    ]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }

  post-processor "vagrant-cloud" {
    box_tag = var.vagrant_cloud_box_tag
    access_token = var.vagrant_cloud_access_token
    version = "0.1.0"
  }
}
