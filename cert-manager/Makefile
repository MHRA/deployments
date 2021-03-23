overlay := non-prod

.PHONY: default
default: init1 helmInstall init2

.PHONY: init1
init1: ## Configure cert-manager namespace
	kustomize build ./overlays-1/$(overlay) | kubectl apply -f -

.PHONY: helmInstall
helmInstall: ## Install cert-manager config using helm
	helm upgrade cert-manager jetstack/cert-manager \
		--install \
		--namespace cert-manager \
		--version  v1.2.0 \
		--set installCRDs=true
	@until kubectl wait --for=condition=ready pod -l app=webhook -n cert-manager --timeout=480s; \
	do \
		echo "Waiting for cert-manager webhook"; \
		sleep 10 ;\
	done
	@until kubectl wait --for=condition=ready pod -l app=cainjector -n cert-manager --timeout=480s; \
	do \
		echo "Waiting for cert-manager cainjector"; \
		sleep 10 ;\
	done
	@until kubectl wait --for=condition=ready pod -l app=cert-manager -n cert-manager --timeout=480s; \
	do \
		echo "Waiting for cert-manager"; \
		sleep 10 ;\
	done
	sleep 20


.PHONY: init2
init2: ## Configure issuers
	kustomize build ./overlays-2/$(overlay) | kubectl apply -f -

.PHONY: delete
delete: ## Delete
	kustomize build ./overlays-2/$(overlay) | kubectl delete --ignore-not-found -f -
	helm --namespace cert-manager delete cert-manager
	kustomize build ./overlays-1/$(overlay) | kubectl delete --ignore-not-found -f -

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
