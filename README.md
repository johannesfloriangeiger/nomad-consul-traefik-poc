# Prerequisite

A Docker registry runs under `localhost:5000`.

# Setup

Create temporary folders:

```
mkdir -p /tmp/nomad/host-volumes/wp-server
mkdir -p /tmp/nomad/host-volumes/wp-runner
```

Build PoC:

```
mvn clean install \
    && docker build . -t localhost:5000/example \
    && docker push localhost:5000/example
```

Set variables (replace network adapter `en0` if necessary):

```
NETWORK_ADAPTER=en0
ifconfig $NETWORK_ADAPTER | grep "inet " | read -r ignore IP ignore
```

# Shell 1

Run Consul:

```
consul agent -dev \
    -bind $IP \
    -client 0.0.0.0 \
    -log-level INFO
```

Consul can be queried e.g. showing the installed services via `consul catalog services`.

# Shell 2

Run Nomad:

```
nomad agent -dev \
    -network-interface=$NETWORK_ADAPTER \
    -config=nomad-server-client.hcl
```

Open `http://localhost:4646` to see the Nomad UI.

# Shell 3

Install Waypoint:

```
waypoint install -platform=nomad -accept-tos \
  -nomad-host-volume=wp-server-vol \
  -nomad-runner-host-volume=wp-runner-vol \
  -nomad-consul-service=false
```

Install Traefik:

```
nomad job run -var="consul_ip="$IP traefik.nomad
```

Open `http://$IP:8081` to see the Traefik UI.

Install and call PoC:

```
waypoint up -var="traefik_ip="$IP
sleep 5
curl $IP:8080/api/hello
```

You should see the output `Hello, Spring Boot via Waypoint in Docker/Nomad!`.