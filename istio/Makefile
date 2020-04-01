overlay := non-prod

.PHONY: default
default: operator profile custom ## Install Istio

.PHONY: operator
operator: ## Install Istio Operator
	istioctl operator init
	kubectl wait --for=condition=ready pod -l name=istio-operator -n istio-operator --timeout=480s

.PHONY: profile
profile: ## Install Istio Profile
	kustomize build profile | kubectl apply -f -
	@until kubectl wait --for=condition=ready pod -l app=istiod -n istio-system --timeout=480s; \
	do \
		echo "Waiting for istiod"; \
		sleep 10 ;\
	done

.PHONY: custom
custom: ## Install custom Istio config
ifeq ($(overlay), local)
	./certs.sh
endif

	kustomize build overlays/$(overlay) | kubectl apply -f -	

.PHONY: delete
delete: ## Remove Istio
	kubectl delete istiooperators.install.istio.io -n istio-system istiocontrolplane || true
	istioctl operator remove

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
