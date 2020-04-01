#!/bin/bash

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=argocd-mhra/CN=red-badger.dev' -keyout root-key.txt -out root-crt.txt

openssl req -out csr.txt -newkey rsa:2048 -nodes -keyout key.txt -subj "/CN=argocd-mhra.red-badger.dev/O=argocd-mhra"
openssl x509 -req -days 365 -CA root-crt.txt -CAkey root-key.txt -set_serial 0 -in csr.txt -out crt.txt

kubectl delete -n istio-system secret istio-ingressgateway-certs || true
kubectl create -n istio-system secret tls istio-ingressgateway-certs --key key.txt --cert crt.txt
