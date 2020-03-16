overlay := non-prod

.PHONY: default
default: ## Deploy using Kustomize
	kustomize build operator | kubectl apply -f -
	kubectl wait --for=condition=ready pod -l name=istio-operator -n istio-operator --timeout=480s

	kustomize build profile | kubectl apply -f -
	@until kubectl wait --for=condition=ready pod -l app=istiod -n istio-system --timeout=480s; \
	do \
		echo "Waiting for istiod"; \
		sleep 1 ;\
	done

	kustomize build overlays/$(overlay) | kubectl apply -f -
	

.PHONY: delete
delete: ## Deploy using Kustomize
	kustomize build overlays/$(overlay) | kubectl delete  --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'