# ==============================================================================
# Configuration
# ==============================================================================
CONTAINER_ENGINE ?= podman
IMAGE_NAME       ?= dsh-assistant
CONTAINER_NAME   ?= dsh
SECRET_NAME      ?= dsh_github_token
SECRET_FILE      ?= ./secrets/github-token
COMPOSE_FILE     ?= compose.yaml

# ==============================================================================
# Default target
# ==============================================================================
.DEFAULT_GOAL := help

# ==============================================================================
# Help
# ==============================================================================
.PHONY: help
help: ## Show this help message
	@echo "🚀 DSH Development Environment"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the container image
	$(CONTAINER_ENGINE) build -t $(IMAGE_NAME) .

.PHONY: rebuild
rebuild: clean-images build ## Force a clean rebuild (no cache)
	@echo "✅ Image rebuilt without cache"

.PHONY: rmi
rmi: ## Remove the built image
	-$(CONTAINER_ENGINE) rmi $(IMAGE_NAME) 2>/dev/null || true

.PHONY: secret-create
secret-create: ## Create the GitHub token secret in Podman
	@test -f $(SECRET_FILE) || (echo "❌ Secret file not found: $(SECRET_FILE)" && exit 1)
	$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	$(CONTAINER_ENGINE) secret create $(SECRET_NAME) $(SECRET_FILE)
	@echo "✅ Secret '$(SECRET_NAME)' created from $(SECRET_FILE)"

.PHONY: secret-rm
secret-rm: ## Remove the GitHub token secret
	-$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	@echo "🗑️  Secret '$(SECRET_NAME)' removed"

.PHONY: secret-ls
secret-ls: ## List all secrets
	$(CONTAINER_ENGINE) secret ls

.PHONY: run
run: secret-create ## Run the container with secret mounted (foreground)
	-$(CONTAINER_ENGINE) rm -f $(CONTAINER_NAME) 2>/dev/null || true
	$(CONTAINER_ENGINE) run -d \
		--name $(CONTAINER_NAME) \
		--secret $(SECRET_NAME) \
		-p 3080:3080 \
		-v dsh-home:/home/dsh \
		-v $(HOME)/.agents:/home/dsh/.agents:rw \
		$(IMAGE_NAME)
	@sleep 3
	@./dsh-cli url --print-only

.PHONY: start
start: secret-create ## Start the container in detached mode
	-$(CONTAINER_ENGINE) rm -f $(CONTAINER_NAME) 2>/dev/null || true
	$(CONTAINER_ENGINE) run -d \
		--name $(CONTAINER_NAME) \
		--secret $(SECRET_NAME) \
		-p 3080:3080 \
		-v dsh-home:/home/dsh \
		-v $(HOME)/.agents:/home/dsh/.agents:rw \
		$(IMAGE_NAME)
	@echo "✅ Container '$(CONTAINER_NAME)' started"
	@echo "   Run 'dsh-cli url' to get the GUI URL (uses SSH tunnel)"

.PHONY: stop
stop: ## Stop the running container
	-$(CONTAINER_ENGINE) stop $(CONTAINER_NAME) 2>/dev/null || true

.PHONY: rm
rm: stop ## Remove the container
	-$(CONTAINER_ENGINE) rm -f $(CONTAINER_NAME) 2>/dev/null || true

.PHONY: restart
restart: rm start ## Restart the container

.PHONY: logs
logs: ## Tail container logs
	$(CONTAINER_ENGINE) logs -f $(CONTAINER_NAME)

.PHONY: shell
shell: ## Open a zsh shell inside the running container
	$(CONTAINER_ENGINE) exec -it $(CONTAINER_NAME) zsh

.PHONY: root-shell
root-shell: ## Open a root shell (useful for debugging permissions)
	$(CONTAINER_ENGINE) exec -it -u root $(CONTAINER_NAME) zsh

.PHONY: up
up: ## Start services via compose (detached)
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) up -d --build

.PHONY: down
down: ## Stop and remove compose services
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) down

.PHONY: compose-logs
compose-logs: ## Tail compose logs
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) logs -f

.PHONY: ps
ps: ## List running containers
	$(CONTAINER_ENGINE) ps

.PHONY: clean
clean: rm ## Remove container and dangling images
	-$(CONTAINER_ENGINE) image prune -f
	@echo "🧹 Cleaned up containers and dangling images"

.PHONY: clean-all
clean-all: clean ## Remove container, images, volumes, and secrets
	-$(CONTAINER_ENGINE) volume rm dsh_dsh-home 2>/dev/null || true
	-$(CONTAINER_ENGINE) rmi $(IMAGE_NAME) 2>/dev/null || true
	-$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	@echo "🧹 Full cleanup complete"

.PHONY: inspect
inspect: ## Inspect the image metadata
	$(CONTAINER_ENGINE) inspect $(IMAGE_NAME) | less
