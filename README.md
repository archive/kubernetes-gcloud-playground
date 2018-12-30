# kubernetes-gcloud-playground

## nodejs test service

### run without docker

```
yarn start
```

http://localhost:5010/

### run in docker

```
docker-compose up

or

docker-compose up --force-recreate --build
```

http://localhost:8090/

## dotnetcore test service

### run without docker

```
dotnet run --project TestSvc/TestSvc.csproj
```

http://localhost:5000/

### run in docker

```
docker-compose up

or

docker-compose up --force-recreate --build
```

http://localhost:8080/

## cluster

set env variables:

- GCLOUD_PROJECT_ID
- GCLOUD_CLUSTER_NAME
- KUBECTL_CONFIG_CONTEXT_NAME

### create

```
bash cluster/build.sh
```

### teardown

```
bash cluster/teardown.sh
```

### rename local context

```
kubectl config rename-context <from> <to>
```
