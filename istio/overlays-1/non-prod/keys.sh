az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-cer \
    --query value \
    --output tsv >test.crt
az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-key \
    --query value \
    --output tsv >test.key
kubectl create secret tls istio-ingressgateway-certs \
    -n istio-system \
    -o json \
    --dry-run \
    --cert=./test.crt \
    --key=./test.key |
    kubeseal \
        --format yaml >sealed-secret-ingressgateway-certs.yaml
rm test.crt
rm test.key

az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-mhra-gov-uk-cer \
    --query value \
    --output tsv >nonprod.crt
az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-mhra-gov-uk-key \
    --query value \
    --output tsv >nonprod.key
kubectl create secret tls non-prod-istio-ingressgateway-certs \
    -n istio-system \
    -o json \
    --cert=./nonprod.crt \
    --key=./nonprod.key
rm nonprod.crt
rm nonprod.key
