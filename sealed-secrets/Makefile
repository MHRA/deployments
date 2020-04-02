overlay := non-prod

vault-prod := mhra-prod
vault-non-prod := mhra-non-prod-02
vault-dev := mhra-non-prod-02

.PHONY: default
default: ## Create resources
	az keyvault secret show \
		--vault-name $(vault-$(overlay))  \
		--name sealing-key \
		--query value \
		--output tsv > sealed-secrets-key.yaml && \
	kustomize build . | kubectl apply -f - && \
	rm sealed-secrets-key.yaml

.PHONY: delete
delete: ## Delete resources
	az keyvault secret show \
		--vault-name $(vault-$(overlay)) \
		--name sealing-key \
		--query value \
		--output tsv > sealed-secrets-key.yaml && \
	kustomize build . | kubectl delete  --ignore-not-found -f - && \
	rm sealed-secrets-key.yaml

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
