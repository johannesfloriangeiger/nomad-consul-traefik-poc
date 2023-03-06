variable "traefik_ip" {
  type        = string
  description = "The IP address of the Traefik host."
}

project = "poc"

app "poc" {
  build {
    use "docker-pull" {
      image = "localhost:5000/example"
      tag   = "latest"
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/poc.nomad.tpl", {
        traefik_ip = var.traefik_ip
      })
    }
  }
}