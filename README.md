# Deployments

GitOps deployment configuration

## Creating a cluster from scratch

1. Follow the [steps in the products repo](https://github.com/MHRA/products/tree/master/infrastructure) to set up a Kubernetes cluster on Azure using terraform

2. [Install Istio and the SealedSecrets controller](https://github.com/MHRA/products/tree/master/medicines/doc-index-updater/examples) using these other steps in the products repo (but do _not_ install the `doc-index-updater` manifests)

3. Apply all of the manifests for your cluster. The `overlay` argument specifies the environment you are deploying (e.g. `non-prod`):

   ```sh
   cd cluster-init/

   make overlay=non-prod
   ```

## Deleting the cluster

1. Delete all of the manifest resources for your environment (e.g. `non-prod`):

   ```sh
   cd cluster-init/

   make delete overlay=non-prod
   ```

2. Delete the cluster infrastructure for your environment using terraform in the [products repo](https://github.com/MHRA/products):

   ```sh
   cd infrastructure/environments/non-prod

   terraform destroy
   ```
