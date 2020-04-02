overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	DEV_SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name mhra-non-prod-02  \
		--name non-prod-dev-sentinel-ip \
		--query value \
		--output tsv) && \
	UAT_SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name mhra-non-prod-02  \
		--name non-prod-uat-sentinel-ip \
		--query value \
		--output tsv) && \
	kustomize build ./overlays/$(overlay) | \
		sed -e "s/\$${DEV_SENTINEL_IP_ADDRESS}/$${DEV_SENTINEL_IP_ADDRESS}/g" | \
		sed -e "s/\$${UAT_SENTINEL_IP_ADDRESS}/$${UAT_SENTINEL_IP_ADDRESS}/g" | \
		kubectl apply -f -

.PHONY: delete
delete: ## Remove egress rules
	kustomize build ./overlays/$(overlay) | kubectl delete  --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
