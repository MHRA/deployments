overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	kustomize build ./init | kubectl apply --validate=false -f -
	@until [ $$(kubectl get crds | grep 'cert-manager.io' | wc -l) -eq 6 ] ;\
	do \
		echo "Waiting for CRDs"; \
		sleep 1 ;\
	done ;\
	kustomize build ./overlays/$(overlay) | kubectl apply --validate=false -f -

.PHONY: delete
delete: ## Deploy using Kustomize
	kustomize build ./base | kubectl delete --ignore-not-found -f -
	kustomize build ./overlays/$(overlay) | kubectl delete --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'