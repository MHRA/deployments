overlay := non-prod

resourcegroup-dev := mhra-products-development
resourcegroup-non-prod := adazr-rg-1001
resourcegroup-prod := apazr-rg-1001
resourcegroup-prod-new := apazr-rg-1001
clustername-dev := dev
clustername-non-prod := non-prod
clustername-prod := production
clustername-prod-new := production


.PHONY: default
default: operator init1 init2 ## Install Istio

.PHONY: operator
operator: ## Install Istio Operator
	istioctl operator init
	@until kubectl wait --for=condition=ready pod -l name=istio-operator -n istio-operator --timeout=480s; \
	do \
		echo "Waiting for istio operator"; \
		sleep 10 ;\
	done

.PHONY: init1
init1: ## Install SSL certs and Istio profile
	NODE_RESOURCE_GROUP=$$(az aks show --name $(clustername-$(overlay)) --resource-group $(resourcegroup-$(overlay)) --query nodeResourceGroup -o tsv) && \
	PUBLIC_IP=$$(az network public-ip show --name products-public-ip --resource-group $${NODE_RESOURCE_GROUP} --query ipAddress -o tsv) && \
		kustomize build overlays-1/$(overlay) | \
		sed -e "s/\$${PUBLIC_IP}/$${PUBLIC_IP}/g" | \
		kubectl apply -f -
	@until kubectl wait --for=condition=ready pod -l app=istiod -n istio-system --timeout=480s; \
	do \
		echo "Waiting for istiod"; \
		sleep 10 ;\
	done

.PHONY: init2
init2: ## Install custom manifests
	kustomize build overlays-2/$(overlay) | kubectl apply -f -

.PHONY: delete
delete: ## Remove Istio
	kubectl delete istiooperators.install.istio.io -n istio-system istiocontrolplane --ignore-not-found || true
	istioctl operator remove || true
	kustomize build overlays-1/$(overlay) | kubectl delete -f - --ignore-not-found || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
