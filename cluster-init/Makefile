overlay := non-prod

.PHONY: default
default: ## Deploy cluster management tools
	cd ../sealed-secrets && make overlay=$(overlay)
	cd ../cert-manager && make overlay=$(overlay)
	cd ../istio && make overlay=$(overlay)
	cd ../observability/kube-state-metrics/ && make
	cd ../observability/prometheus && make
	cd ../observability/oms-agent && make
	cd ../egress && make overlay=$(overlay)
	cd ../argo-cd && make overlay=$(overlay)

.PHONY: delete
delete: ## Remove cluster management tools
	cd ../argo-cd && make delete overlay=$(overlay) || true
	cd ../egress && make delete overlay=$(overlay) || true
	cd ../observability/oms-agent && make delete || true
	cd ../observability/prometheus && make delete || true
	cd ../observability/kube-state-metrics/ && make delete || true
	cd ../istio && make delete overlay=$(overlay) || true
	cd ../cert-manager && make delete overlay=$(overlay) || true
	cd ../sealed-secrets && make delete overlay=$(overlay) || true

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
