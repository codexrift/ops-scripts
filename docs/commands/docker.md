# Docker Cheat Sheet

Tip: Docker has two "worlds": **images** (immutable templates) and **containers** (running instances of an image).

## Images

```bash
# List local images
docker images

# Pull an image from a registry
docker pull alpine:latest

# Build an image from a Dockerfile in the current directory
docker build -t myapp:dev .

# Tag an image for a registry/repo
docker tag myapp:dev myrepo/myapp:dev

# Push an image to a registry
docker push myrepo/myapp:dev

# Remove a local image
docker rmi <image>
```

Registry login:

```bash
# Authenticate to a registry
docker login

# Remove saved registry credentials
docker logout
```

## Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Run an interactive shell in a temporary container
docker run --name demo -it --rm alpine sh

# Stop a running container
docker stop <container>

# Remove a stopped container
docker rm <container>
```

Run patterns:

```bash
# Interactive shell, auto-remove on exit
docker run --rm -it alpine sh

# Detached container (runs in background)
docker run -d --name web nginx:alpine

# Restart policy for long-running services
docker run --restart unless-stopped nginx:alpine
```

Ports / env:

```bash
# Publish container port 80 on host port 8080 (host:container)
docker run --rm -p 8080:80 nginx:alpine

# Set an environment variable
docker run --rm -e FOO=bar alpine env

# Load environment variables from a file
docker run --rm --env-file .env alpine env
```

Exec / logs:

```bash
# Run a shell inside a running container
docker exec -it <container> sh

# Run bash inside a running container (if present)
docker exec -it <container> bash

# Show container logs
docker logs <container>

# Follow logs, with a tail limit
docker logs -f --tail=200 <container>
```

Inspect:

```bash
# Show low-level container details as JSON
docker inspect <container>

# Live resource usage stats
docker stats

# Show container processes
docker top <container>
```

Copy files in/out:

```bash
# Copy a local file into a container
docker cp ./local.txt <container>:/tmp/local.txt

# Copy a file from a container to the host
docker cp <container>:/var/log/app.log ./app.log
```

## Networks

```bash
# List networks
docker network ls

# Create a user-defined bridge network
docker network create mynet

# Run a container on a specific network (example uses DNS lookup)
docker run --rm --network mynet alpine nslookup example.com
```

## Volumes

```bash
# List volumes
docker volume ls

# Create a named volume
docker volume create app-data

# Mount a named volume into a container
docker run --rm -v app-data:/data alpine ls -la /data
```

Bind mount current directory:

```bash
# Bind-mount current directory into /work and set working dir
docker run --rm -v "$PWD":/work -w /work alpine ls
```

## Compose (common)

```bash
# Start services in the background
docker compose up -d

# (Re)build images and start services
docker compose up -d --build

# List services/containers
docker compose ps

# Follow logs for all services
docker compose logs -f --tail=200

# Exec into a running service container
docker compose exec <service> sh

# Stop and remove containers/networks
docker compose down
```

Compose troubleshooting:

```bash
# Render the fully merged Compose config
docker compose config

# Pull service images
docker compose pull

# Restart a single service
docker compose restart <service>
```

## Cleanup (use with care)

```bash
# Show disk usage by images/containers/volumes/build cache
docker system df

# Remove unused data (interactive prompt)
docker system prune

# Remove unused volumes
docker volume prune

# Remove unused images
docker image prune
```

More selective cleanup:

```bash
# Remove stopped containers
docker container prune

# Remove all unused images (not just dangling)
docker image prune -a

# Remove unused data including volumes (destructive)
docker system prune --volumes
```

## Quick debugging checklist

```bash
# List containers (including exited) to see status/restarts
docker ps -a

# Check logs for errors
docker logs <container>

# Inspect config, mounts, env, network settings
docker inspect <container> | less

# Watch daemon events (restarts, OOMs, pulls, etc.)
docker events --since 10m
```
