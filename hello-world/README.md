## Hello World deployment

### Deploy

- Deploy hello-world:

For dev cluster in AKS:

```bash
kustomize build overlays/dev | kubectl apply -f -

# or...

make overlay=dev
```

For local cluster:

```bash
kustomize build overlays/local | kubectl apply -f -

# or...

make overlay=local

# test:
curl -vvv -H Host:hello-world.localhost http://127.0.0.1/hello/SomeName # should be 200
```
