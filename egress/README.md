## Setup

Store the IP address for Sentinel in Azure Vault as a secret (ip address below is an example):

```sh
az keyvault secret set --vault-name mhra-non-prod-02 --name non-prod-sentinel-ip --value 10.1.1.1
```
