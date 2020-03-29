overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	cd ../istio && make overlay=$(overlay)
	cd ../sealed-secrets && make overlay=$(overlay)
	cd ../argo-cd && make overlay=$(overlay)

.PHONY: delete
delete: ## Deploy using Kustomize
	cd ../argo-cd && make delete overlay=$(overlay) || true
	cd ../sealed-secrets && make delete overlay=$(overlay) || true
	cd ../istio && make delete overlay=$(overlay) || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
