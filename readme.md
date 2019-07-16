# Monitor your kubernetes cluster with a Led Matrix and a RaspberryPi

This project uses a [Pimoroni's UnicornHat](https://github.com/pimoroni/unicorn-hat)

The command below starts the watcher in python that updates the led matrix. The arg "default" is in fact the namespace that we want to watch.

Make sure to review the names of the nodes on line 6 from [k8s-unicorn-lights.sh](./k8s-unicorn-lights.sh)

```bash
python ./k8s-unicorn-lights.py default
````

Sample
```bash
kubectl run nginx --image nginx
kubectl scale --replicas=10 deployment/nginx
kubectl scale --replicas=15 deployment/nginx
kubectl scale --replicas=1 deployment/nginx
kubectl delete deploymenty nginx
```