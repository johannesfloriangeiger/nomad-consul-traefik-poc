server {
  enabled = true
}

client {
  enabled = true

  host_volume {
    wp-server-vol {
      path      = "/tmp/nomad/host-volumes/wp-server"
      read_only = false
    }

    wp-runner-vol {
      path      = "/tmp/nomad/host-volumes/wp-runner"
      read_only = false
    }
  }
}