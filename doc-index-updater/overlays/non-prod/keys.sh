#!/bin/bash

# Redis credentials...
REDIS_KEY=$(az redis list-keys \
    --resource-group adazr-rg-1001 \
    --name doc-index-updater-non-prod \
    --output tsv --query 'primaryKey')
kubectl create secret generic redis-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal key="$REDIS_KEY" |
    kubeseal \
        --format yaml >SealedSecret-redis-creds.yaml

# Azure Search Service credentials...
API_KEY=$(az search admin-key show \
    --resource-group adazr-rg-1001 \
    --service-name mhraproductsnonprod \
    --output tsv --query 'primaryKey')
kubectl create secret generic search-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal api_key="$API_KEY" |
    kubeseal \
        --format yaml >SealedSecret-search-creds.yaml

# Sentinel credentials...
SENTINEL_SERVER_IP=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-uat-sentinel-ip \
    --query value \
    --output tsv)
SENTINEL_USERNAME=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-uat-sentinel-username \
    --query value \
    --output tsv)
SENTINEL_PUBLIC_KEY=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-uat-sentinel-public-key \
    --query value \
    --output tsv)
SENTINEL_PRIVATE_KEY=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-uat-sentinel-private-key \
    --query value \
    --output tsv)
SENTINEL_PRIVATE_KEY_PASSWORD=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name non-prod-uat-sentinel-private-key-password \
    --query value \
    --output tsv)
kubectl create secret generic sentinel-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal server="$SENTINEL_SERVER_IP" \
    --from-literal user="$SENTINEL_USERNAME" \
    --from-literal public_key="$SENTINEL_PUBLIC_KEY" \
    --from-literal private_key="$SENTINEL_PRIVATE_KEY" \
    --from-literal private_key_password="$SENTINEL_PRIVATE_KEY_PASSWORD" |
    kubeseal \
        --format yaml >SealedSecret-sentinel-creds.yaml

# Azure Service Bus credentials...
SB_CREATE_KEY=$(az servicebus queue authorization-rule keys list \
    --resource-group adazr-rg-1001 \
    --namespace-name doc-index-updater-non-prod \
    --queue-name doc-index-updater-create-queue \
    --name doc-index-updater-create-auth \
    --query primaryKey \
    --output tsv)
SB_DELETE_KEY=$(az servicebus queue authorization-rule keys list \
    --resource-group adazr-rg-1001 \
    --namespace-name doc-index-updater-non-prod \
    --queue-name doc-index-updater-delete-queue \
    --name doc-index-updater-delete-auth \
    --query primaryKey \
    --output tsv)
kubectl create secret generic service-bus-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal create_key="$SB_CREATE_KEY" \
    --from-literal delete_key="$SB_DELETE_KEY" |
    kubeseal \
        --format yaml >SealedSecret-service-bus-creds.yaml

# Azure Blob Storage credentials...
BLOB_KEY=$(az storage account keys list \
    --account-name=mhraproductsnonprod \
    --query='[0].value' \
    --output=tsv)
kubectl create secret generic storage-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal account="mhraproductsnonprod" \
    --from-literal container="docs" \
    --from-literal container_temporary="temporary-docs" \
    --from-literal key="$BLOB_KEY" |
    kubeseal \
        --format yaml >SealedSecret-storage-creds.yaml

# Azure Log Blob Storage credentials...
LOG_BLOB_KEY=$(az storage account keys list \
    --account-name=mhralogsnonprod \
    --query='[0].value' \
    --output=tsv)
kubectl create secret generic logs-storage-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal account="mhralogsnonprod" \
    --from-literal container="transaction-logs" \
    --from-literal key="$LOG_BLOB_KEY" |
    kubeseal \
        --format yaml >SealedSecret-logs-storage-creds.yaml

# HTTP Basic Auth credentials...
BASIC_AUTH_USERNAME=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name basic-auth-username \
    --query value \
    --output tsv)
BASIC_AUTH_PASSWORD=$(az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name basic-auth-password \
    --query value \
    --output tsv)
kubectl create secret generic basic-auth-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal username="$BASIC_AUTH_USERNAME" \
    --from-literal password="$BASIC_AUTH_PASSWORD" |
    kubeseal \
        --format yaml >SealedSecret-basic-auth-creds.yaml

# Pull and generate wildcard certificate for *.test
az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-cer \
    --query value \
    --output tsv >doc-index-updater.crt
az keyvault secret show \
    --vault-name mhra-non-prod-02 \
    --name doc-index-updater-mhra-gov-uk-key \
    --query value \
    --output tsv >doc-index-updater.key
kubectl create secret tls test-wildcard-cert \
    -n istio-system \
    -o json \
    --dry-run \
    --cert=./doc-index-updater.crt \
    --key=./doc-index-updater.key |
    kubeseal \
        --format yaml >Sealed-secret-test-wildcard-cert.yaml
rm doc-index-updater.crt
rm doc-index-updater.key
