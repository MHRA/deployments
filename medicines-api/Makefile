overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	cat ./$(overlay)/manifests.yaml | kubectl apply --validate=false -f -

.PHONY: delete
delete: ## Delete
	cat ./$(overlay)/manifests.yaml | kubectl delete --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
