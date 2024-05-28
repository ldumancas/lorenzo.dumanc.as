packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "alpine" {
  image  = "alpine:3.19.1"
  commit = true
  changes = [
    "WORKDIR /mnt",
    "ENTRYPOINT hugo"
  ]
}

build {
  name = "hugo-build"
  sources = [
    "source.docker.alpine"
  ]

  provisioner "shell" {
    inline = [
        "apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo",
        "mkdir /mnt/working"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "ldumancas/hugo-build"
      tags       = ["0.1", "latest"]
    }

    post-processor "docker-push" {
        login = true
        login_username = ""
        login_password = ""
    }
  }
}
