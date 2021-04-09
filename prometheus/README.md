# Prometheus install

```bash
curl https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml -o install.yaml

# https://github.com/mogensen/kubernetes-split-yaml
go get -v github.com/mogensen/kubernetes-split-yaml

~/go/bin/kubernetes-split-yaml install.yaml

# remove annotation to prevent sidecar injection and create new manifest with a sidecar injected...
cat generated/prometheus-deployment.yaml \
    | grep -v sidecar.istio.io/inject \
    | istioctl kube-inject -f - \
    > prometheus-deployment.yaml
```
