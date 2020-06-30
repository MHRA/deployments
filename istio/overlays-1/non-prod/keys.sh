CER=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-cer \
    --query value \
    --output tsv)
KEY=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-key \
    --query value \
    --output tsv)
kubectl create secret generic istio-ingressgateway-certs \
    -n istio-system \
    -o json \
    --dry-run \
    --from-literal tls.crt="$CER" \
    --from-literal tls.key="$KEY" |
    kubeseal \
        --format yaml >sealed-secret-ingressgateway-certs.yaml

NONPROD_CER=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-mhra-gov-uk-cer \
    --query value \
    --output tsv)
NONPROD_KEY=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-mhra-gov-uk-key \
    --query value \
    --output tsv)
kubectl create secret generic non-prod-istio-ingressgateway-certs \
    -n istio-system \
    -o json \
    --dry-run \
    --from-literal tls.crt="$CER" \
    --from-literal tls.key="$KEY" |
    kubeseal \
        --format yaml >sealed-secret-non-prod-ingressgateway-certs.yaml
