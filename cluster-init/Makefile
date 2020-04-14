overlay := non-prod

.PHONY: default
default: ## Deploy cluster management tools
	cd ../kube-state-metrics/ && make
	cd ../sealed-secrets && make overlay=$(overlay)
	cd ../istio && make overlay=$(overlay)
	cd ../egress && make overlay=$(overlay)
	cd ../argo-cd && make overlay=$(overlay)

.PHONY: delete
delete: ## Remove cluster management tools
	cd ../argo-cd && make delete overlay=$(overlay) || true
	cd ../egress && make delete overlay=$(overlay) || true
	cd ../istio && make delete overlay=$(overlay) || true
	cd ../sealed-secrets && make delete overlay=$(overlay) || true
	cd ../kube-state-metrics/ && make delete || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
