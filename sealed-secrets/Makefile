overlay := non-prod

vault-prod := mhraproducts4853
vault-non-prod := mhra-non-prod-02
vault-dev := mhra-non-prod-02
vault-local := mhra-non-prod-02

.PHONY: default
default: ## Create resources
	[ $$(kubectl get secret \
		-n kube-system \
		--selector "sealedsecrets.bitnami.com/sealed-secrets-key=active" \
		--no-headers | wc -l) -gt 0 ] || ( \
			az keyvault secret show \
				--vault-name $(vault-$(overlay))  \
				--name sealing-key \
				--query value \
				--output tsv > init-1/sealing-key.yaml && \
			kustomize build init-1 | kubectl apply -f - && \
			rm init-1/sealing-key.yaml )
	kustomize build init-2 | kubectl apply -f -
	@until kubectl wait --for=condition=ready pod -l name=sealed-secrets-controller -n kube-system; \
	do \
		echo "Waiting for sealed secrets controller"; \
		sleep 10 ;\
	done

.PHONY: delete
delete: ## Delete resources
	kubectl delete secret -n kube-system --selector "sealedsecrets.bitnami.com/sealed-secrets-key=active" || true
	kustomize build init-2 | kubectl delete  --ignore-not-found -f - || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
