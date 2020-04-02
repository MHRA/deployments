overlay := non-prod

vault-prod := mhra-prod
vault-non-prod := mhra-non-prod-02
vault-dev := mhra-non-prod-02

.PHONY: default
default: ## Deploy using Kustomize
	SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name $(vault-$(overlay))  \
		--name sentinel-ip \
		--query value \
		--output tsv) && \
	kustomize build . | \
		sed -e "s/\$${SENTINEL_IP_ADDRESS}/$${SENTINEL_IP_ADDRESS}/g" | \
		kubectl apply -f -

.PHONY: delete
delete: ## Deploy using Kustomize
	SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name $(vault-$(overlay))  \
		--name sentinel-ip \
		--query value \
		--output tsv) && \
	kustomize build . | kubectl delete  --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'