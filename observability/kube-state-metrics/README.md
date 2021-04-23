# kube-state-metrics install

The `generated` folder contains the vanilla installation manifests for `kube-state-metrics`. To refresh generated manifests, fetch the helm repo (see below) and split them into the `generated` folder, like this:

```bash

helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update

helm template kube-state-metrics kube-state-metrics/kube-state-metrics >install.yaml

# install https://github.com/mogensen/kubernetes-split-yaml
go get -v github.com/mogensen/kubernetes-split-yaml

# splits the yaml into resource oriented manifests and stores them in the `generated` folder
~/go/bin/kubernetes-split-yaml install.yaml

```
