#!/bin/bash

kubectl create secret generic sentinel-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal server="127.0.0.1" \
    --from-literal user="insert here" \
    --from-literal pass="insert here" |
    kubeseal \
        --format yaml >SealedSecret-sentinel-creds.yaml

kubectl create secret generic storage-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal account="insert here" \
    --from-literal container="insert here" \
    --from-literal key="insert here" |
    kubeseal \
        --format yaml >SealedSecret-storage-creds.yaml

kubectl create secret generic search-creds \
    -n doc-index-updater \
    -o json \
    --dry-run \
    --from-literal service="insert here" \
    --from-literal index="insert here" \
    --from-literal api_key="insert here" \
    --from-literal query_key="insert here" |
    kubeseal \
        --format yaml >SealedSecret-search-creds.yaml
