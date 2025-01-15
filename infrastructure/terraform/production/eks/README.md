This is just an example of how to easily setup a k8 cluster in AWS. There are some variables in here that need to be replaced with your own information.

```
CLUSTER_NAME=eks-helm-test
AWS_REGION=us-east-2

aws eks update-kubeconfig --region us-east-2 --name eks-helm-test

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl apply -f aws/auth/aws-auth-cm.yaml
```
