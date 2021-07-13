
# PingPong with GKE and AWS API Gateway

Ping Pong Nodejs websocket implementation with AWS serverless API Gateway and Google Kubernetes Engine.

## Example

![Alt Text](https://github.com/alik116/k8s_aws_webhooks/raw/master/example.gif)

## Installation

#### Kubernetes
To install deployment and dependencies for k8s @ [GKE](https://cloud.google.com/kubernetes-engine/) run:

```bash
kubectl create -f k8s.yaml # Note: Update ConfigMap object for the API Endpoint
```



#### k8s Monitoring (Datadog)

You need to install helm [see here](https://v3.helm.sh/docs/intro/install/)

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install RELEASE_NAME -f monitoring.yaml --set datadog.site='datadoghq.com' --set datadog.apiKey=<API_KEY> datadog/datadog 
```
###### You can use API KEY "c4d8ba55894e4499dfc504ff84bb812d"

#### AWS API Gateway

run [AWS_API_Gateway.yaml]() script via CloudFormation runner or AWS CLI.

This will deploy AWS API Gateway v2 using Websockets. 

***Note!** you have to manually launch Integration Response via GUI or CLI as CloudFormation does not create this resource and Deploy Gateway*


## Test endpoint

```
npm install wscat
wscat -c wss://<endpoint>
```

## Additional information (optional)

#### Creating two endpoints on the Kubernetes

for this we will need to launch **s.js** (Nodejs  WSS server). All dependencies including OpenSSL certificates are already created within a container.

You will need to: 

(a) Ingress controller instead of the load balancer and 

(b) copy deployment with an updated container template section

```
container:
- name: pong
  command: ["node", "/app/s.js"]
  image: alik116/
```
Ingress controller:
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myingress
spec:
  rules:
  - http:
      paths:
      - path: /ping
        pathType: ImplementationSpecific
        backend:
          service:
            name: svc-ping
            port:
              number: 80
      - path: /pong
        pathType: ImplementationSpecific
        backend:
          service:
            name: svc-pong
            port:
              number: 80
```

```
kubectl expose <ping_deployment> --name svc-ping --port=80 --target-port=80 
kubectl expose <ping_deployment> --name svc-pong --port=80 --target-port=80 
```

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
