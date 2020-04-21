### Get (and seal) credentials if they have changed:

```bash
(cd ./overlays/non-prod && ./keys.sh)
```

### Deploy

- Deploy doc-index-updater:

For non-prod cluster in AKS:

```bash
kustomize build ./overlays/non-prod | kubectl apply -f -
```

For local cluster:

```bash
kustomize build ./overlays/local | kubectl apply -f -

# test:
curl -vvv -H Host:doc-index-updater.localhost http://127.0.0.1/non-existent-route # should be 404
```
