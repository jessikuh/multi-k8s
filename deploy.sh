docker build -t jessikuh/multi-client:latest -t jessikuh/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jessikuh/multi-server:latest -t jessikuh/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jessikuh/multi-worker:latest -t jessikuh/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jessikuh/multi-client:latest
docker push jessikuh/multi-server:latest
docker push jessikuh/multi-work:latest

docker push jessikuh/multi-client:$SHA
docker push jessikuh/multi-server:$SHA
docker push jessikuh/multi-worker:$SHA

# APPLY A SPECIFIC HASH IN ORDER FOR K8S TO KNOW DOCKERFILE HAS UPDATED
# OTHERWISE WILL CHOOSE LATEST AND THINK THERE'S NO UPDATE
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=jessikuh/multi-client:$SHA
kubectl set image deployments/server-deployment server=jessikuh/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=jessikuh/multi-worker:$SHA