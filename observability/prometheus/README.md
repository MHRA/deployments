# Prometheus install

The `generated` folder contains the vanilla installation manifests for Prometheus from the Istio repository. To refresh generated manifests, fetch the relevant source yaml (see below) and split them into the `generated` folder, like this:

```bash

# the url will probably change for newer versions of Istio
curl https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml -o install.yaml

# install https://github.com/mogensen/kubernetes-split-yaml
go get -v github.com/mogensen/kubernetes-split-yaml

# splits the yaml into resource oriented manifests and stores them in the `generated` folder
~/go/bin/kubernetes-split-yaml install.yaml

```
