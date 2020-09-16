overlay := non-prod

vault-prod := mhraproducts4853
vault-non-prod := mhra-non-prod-02

.PHONY: default
default: ## Apply egress configuration
ifeq ($(overlay), prod)
	make prod overlay=$(overlay)
else
	make nonprod overlay=$(overlay)
endif

.PHONY: nonprod
nonprod:
	DEV_SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name $(vault-non-prod)  \
		--name non-prod-dev-sentinel-ip \
		--query value \
		--output tsv) && \
	UAT_SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name $(vault-non-prod)  \
		--name non-prod-uat-sentinel-ip \
		--query value \
		--output tsv) && \
	kustomize build ./overlays/$(overlay) | \
		sed -e "s/\$${DEV_SENTINEL_IP_ADDRESS}/$${DEV_SENTINEL_IP_ADDRESS}/g" | \
		sed -e "s/\$${UAT_SENTINEL_IP_ADDRESS}/$${UAT_SENTINEL_IP_ADDRESS}/g" | \
		kubectl apply -f -

.PHONY: prod
prod:
	PROD_SENTINEL_IP_ADDRESS=$$(az keyvault secret show \
		--vault-name $(vault-prod)  \
		--name sentinel-ip \
		--query value \
		--output tsv) && \
	kustomize build ./overlays/$(overlay) | \
		sed -e "s/\$${PROD_SENTINEL_IP_ADDRESS}/$${PROD_SENTINEL_IP_ADDRESS}/g" | \
		kubectl apply -f -

.PHONY: delete
delete: ## Remove egress configuration
	kustomize build overlays/$(overlay) | kubectl delete  --ignore-not-found -f - || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
