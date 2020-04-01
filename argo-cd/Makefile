overlay := non-prod

.PHONY: default
default: crds install ## Deploy using Kustomize

.PHONY: crds
crds: ## Install ArgoCD CRDs
	kustomize build 1-crds | kubectl apply -f -

.PHONY: install
install: ## Install ArgoCD resources
	@until [ $$(kubectl get crds | grep 'argoproj.io' | wc -l) -eq 2 ] ;\
	do \
		echo "Waiting for CRDs"; \
		sleep 2 ;\
	done ;\
	kustomize build overlays/$(overlay) | kubectl apply -f -

.PHONY: delete
delete: ## Remove ArgoCD
	kustomize build overlays/$(overlay) | kubectl delete  --ignore-not-found -f - || true
	kustomize build 1-crds | kubectl delete  --ignore-not-found -f - || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
