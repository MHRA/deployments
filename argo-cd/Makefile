overlay := non-prod

.PHONY: default
default: init1 init2 ## Deploy using Kustomize

.PHONY: init1
init1: ## Install ArgoCD CRDs and secrets
	kustomize build overlays-1/$(overlay) | kubectl apply -f -

.PHONY: init2
init2: ## Install ArgoCD resources
	@until [ $$(kubectl get crds | grep 'argoproj.io' | wc -l) -eq 2 ] && \
				 [ $$(kubectl get -n argocd secret --no-headers -l unsealing=unsealed | wc -l) -eq \
				   $$(kubectl get -n argocd sealedsecret --no-headers -l unsealing=block | wc -l) ] ;\
	do \
		echo "Waiting for CRDs and secrets"; \
		sleep 2 ;\
	done ;\
	kustomize build overlays-2/$(overlay) | kubectl apply -f - 

.PHONY: delete
delete: ## Remove ArgoCD
	kustomize build overlays-2/$(overlay) | kubectl delete  --ignore-not-found -f - || true
	kustomize build overlays-1/$(overlay) | kubectl delete  --ignore-not-found -f - || true

.PHONY: open
open: ## Open the UI in your default browser
	( sleep 1 && open http://localhost:23001 ) &
	kubectl port-forward -n argocd svc/argocd-server 23001:80

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
