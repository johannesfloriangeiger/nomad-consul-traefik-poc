job "poc" {
  datacenters = ["dc1"]

  group "poc" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name     = "poc"
      port     = "http"
      provider = "consul"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Host(`${var.traefik_ip}`) && Path(`/api/hello`)",
      ]
    }

    task "poc" {
      driver = "docker"

      config {
        image = "localhost:5000/example"

        ports = [
          "http"
        ]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}