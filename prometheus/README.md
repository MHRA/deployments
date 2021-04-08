# Prometheus install

```bash
curl https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml -o install.yaml

# https://github.com/mogensen/kubernetes-split-yaml
go get -v github.com/mogensen/kubernetes-split-yaml

~/go/bin/kubernetes-split-yaml install.yaml
```
