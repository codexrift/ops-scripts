# Docker Cheat Sheet

## Images

```bash
docker images
docker pull alpine:latest
docker build -t myapp:dev .
docker rmi <image>
```

## Containers

```bash
docker ps
docker ps -a
docker run --name demo -it --rm alpine sh
docker stop <container>
docker rm <container>
```

Exec / logs:

```bash
docker exec -it <container> sh
docker logs <container>
docker logs -f --tail=200 <container>
```

Inspect:

```bash
docker inspect <container>
docker stats
```

## Networks

```bash
docker network ls
docker network create mynet
docker run --rm --network mynet alpine nslookup example.com
```

## Volumes

```bash
docker volume ls
docker volume create app-data
docker run --rm -v app-data:/data alpine ls -la /data
```

Bind mount current directory:

```bash
docker run --rm -v "$PWD":/work -w /work alpine ls
```

## Compose (common)

```bash
docker compose up -d
docker compose ps
docker compose logs -f --tail=200
docker compose down
```

## Cleanup (use with care)

```bash
docker system df
docker system prune
docker volume prune
docker image prune
```

