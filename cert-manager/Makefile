overlay := non-prod

.PHONY: default
default: init1 helmInstall init2

.PHONY: init1
init1: ## Configure cert-manager namespace
	kustomize build ./overlays-1/$(overlay) | kubectl apply -f -

.PHONY: helmInstall
helmInstall: ## Install cert-manager config using helm
	helm install cert-manager jetstack/cert-manager \
		--namespace cert-manager \
		--version v0.15.1 \
		--set installCRDs=true

.PHONY: init2
init2: ## Configure issuers
	kustomize build ./overlays-2/$(overlay) | kubectl apply -f -

.PHONY: delete
delete: ## Delete
	kustomize build ./overlays-2/$(overlay) | kubectl delete --ignore-not-found -f -
	helm uninstall cert-manager
	kustomize build ./overlays-1/$(overlay) | kubectl delete --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
