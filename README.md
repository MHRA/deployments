# Deployments repo

This repo contains all the manifests for resources running under [Kubernetes](https://kubernetes.io/) (with [Istio](https://istio.io/)) at MHRA. It declares our intent, and then we use [GitOps](https://www.weave.works/technologies/gitops/) to realise this deployment configuration using [ArgoCD](https://argoproj.github.io/argo-cd/). Note that all secrets in this repo are encrypted using [Bitnami's Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).

![](./docs/ci-cd-gitops.svg)

1. An engineer pushes a change to the [Products monorepo](https://github.com/MHRA/products)
1. A [Github Action](https://github.com/features/actions) runs a workflow
1. The workflow builds a Docker image, which also runs analysis and tests
1. The workflow pushes the image to the relevant registry
1. The workflow clones _this_ repository (shallow clone), uses [Kustomize](https://kustomize.io/) to edit the relevant configuration with the new image's tag (which is the image's content digest [SHA]), commits and pushes back to this repository
1. Argo CD running in the cluster pulls the changed configuration
1. Argo CD synchronises the configuration of the cluster with the configuration specified in _this_ repository
1. If required, new images are pulled (by Kubernetes) from the relevant registry and new pods started
1. Production deployments can be manually synced (although the aim is to have these automatically synchronised as well)

## Creating a cluster from scratch

1. Follow the [steps in the products repo](https://github.com/MHRA/products/tree/master/infrastructure) to set up a Kubernetes cluster on Azure using terraform.

1. Install Istio, Sealed Secrets and ArgoCD. Once installed, ArgoCD will deploy the rest of the configuration (using GitOps). The `overlay` argument specifies the environment you are deploying to (the default is `non-prod`):

   ```sh
   cd cluster-init

   make overlay=non-prod
   ```

## Deleting the cluster

1. If you only want to delete Istio, Sealed Secrets, Argo CD:

   ```sh
   cd cluster-init

   make delete overlay=non-prod
   ```

1. If you want to delete the cluster infrastructure for your environment [you can do this from the products repo](https://github.com/MHRA/products/tree/master/infrastructure/docs/destroy-provision-aks.md).
