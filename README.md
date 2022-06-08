## Authenticate with Docker Hub
Create an access token:
https://hub.docker.com/settings/security

Login:
```
docker login -u <username>
```

## Build The Image
```
docker build -t brandondbest/laravel .
```

Tag the image:
```
docker build -t brandondbest/laravel:8 .
```

## Push the Image

```
docker push brandondbest/laravel
```

Push a tagged Image:
```
docker push brandondbest/laravel:8
```