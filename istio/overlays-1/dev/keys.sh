az keyvault secret show \
    --vault-name mhra-dev \
    --name doc-index-updater-mhra-gov-uk-cer \
    --query value \
    --output tsv >doc-index-updater.crt
az keyvault secret show \
    --vault-name mhra-dev \
    --name doc-index-updater-mhra-gov-uk-key \
    --query value \
    --output tsv >doc-index-updater.key
kubectl create secret tls istio-ingressgateway-certs \
    -n istio-system \
    -o json \
    --dry-run \
    --cert=./doc-index-updater.crt \
    --key=./doc-index-updater.key |
    kubeseal \
        --format yaml >sealed-secret-ingressgateway-certs.yaml
rm doc-index-updater.crt
rm doc-index-updater.key
