#!/bin/bash

# Redis credentials...
REDIS_KEY=$(az redis list-keys \
    --resource-group apazr-rg-1001 \
    --name doc-index-updater-prod \
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
    --resource-group apazr-rg-1001 \
    --service-name mhraproductsprod \
    --output tsv --query 'primaryKey')
kubectl create secret generic search-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal api_key="$API_KEY" |
    kubeseal \
        --format yaml >SealedSecret-search-creds.yaml

# Sentinel credentials...
SENTINEL_SERVER=$(az keyvault secret show \
    --vault-name mhra-prod \
    --name sentinel-ip \
    --query value \
    --output tsv)
SENTINEL_USERNAME=$(az keyvault secret show \
    --vault-name mhra-prod \
    --name sentinel-username \
    --query value \
    --output tsv)
SENTINEL_PASSWORD=$(az keyvault secret show \
    --vault-name mhra-prod \
    --name sentinel-password \
    --query value \
    --output tsv)
kubectl create secret generic sentinel-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal server="$SENTINEL_SERVER" \
    --from-literal user="$SENTINEL_USERNAME" \
    --from-literal pass="$SENTINEL_PASSWORD" |
    kubeseal \
        --format yaml >SealedSecret-sentinel-creds.yaml

# Azure Service Bus credentials...
SB_CREATE_KEY=$(az servicebus queue authorization-rule keys list \
    --resource-group apazr-rg-1001 \
    --namespace-name doc-index-updater-prod \
    --queue-name doc-index-updater-create-queue \
    --name doc-index-updater-create-auth \
    --query primaryKey \
    --output tsv)
SB_DELETE_KEY=$(az servicebus queue authorization-rule keys list \
    --resource-group apazr-rg-1001 \
    --namespace-name doc-index-updater-prod \
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
    --account-name=mhraproductsprod \
    --query='[0].value' \
    --output=tsv)
kubectl create secret generic storage-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal account="mhraproductsprod" \
    --from-literal container="docs" \
    --from-literal key="$BLOB_KEY" |
    kubeseal \
        --format yaml >SealedSecret-storage-creds.yaml

# HTTP Basic Auth credentials...
BASIC_AUTH_USERNAME=$(az keyvault secret show \
    --vault-name mhra-prod \
    --name basic-auth-username \
    --query value \
    --output tsv)
BASIC_AUTH_PASSWORD=$(az keyvault secret show \
    --vault-name mhra-prod \
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
