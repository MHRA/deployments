overlay := local

.PHONY: default
default: ## Create resources
	kustomize build overlays/$(overlay) | kubectl apply -f -

.PHONY: delete
delete: ## Delete resources
	kustomize build overlays/$(overlay) | kubectl delete  --ignore-not-found -f - || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
