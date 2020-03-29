overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	az keyvault secret show \
		--vault-name mhra-non-prod-02  \
		--name sentinel-non-prod \
		--query value \
		--output tsv > ./base/sentinel.yaml && \
	kustomize build ./overlays/$(overlay) | kubectl apply -f - && \
	rm ./base/sentinel.yaml

.PHONY: delete
delete: ## Deploy using Kustomize
	kustomize build ./overlays/$(overlay) | kubectl delete  --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
