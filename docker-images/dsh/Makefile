CONTAINER_ENGINE ?= podman
IMAGE_NAME       ?= dsh-assistant
CONTAINER_NAME   ?= dsh
SECRET_NAME      ?= dsh_github_token
SECRET_FILE      ?= ./secrets/github-token
COMPOSE_FILE     ?= compose.yaml
CLOUDFLARE_HOST  ?= ai.frisboolab.com

.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "🚀 DSH Development Environment"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

build: ## Build the container image
	$(CONTAINER_ENGINE) build -t $(IMAGE_NAME) .

rebuild: clean-images build ## Force a clean rebuild (no cache)
	@echo "✅ Image rebuilt without cache"

rmi: ## Remove the built image
	-$(CONTAINER_ENGINE) rmi $(IMAGE_NAME) 2>/dev/null || true

secret-create: ## Create the GitHub token secret in Podman
	@test -f $(SECRET_FILE) || (echo "❌ Secret file not found: $(SECRET_FILE)" && exit 1)
	$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	$(CONTAINER_ENGINE) secret create $(SECRET_NAME) $(SECRET_FILE)
	@echo "✅ Secret '$(SECRET_NAME)' created from $(SECRET_FILE)"

secret-rm: ## Remove the GitHub token secret
	-$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	@echo "🗑️  Secret '$(SECRET_NAME)' removed"

secret-ls: ## List all secrets
	$(CONTAINER_ENGINE) secret ls

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
	@token=$$(podman logs $(CONTAINER_NAME) 2>/dev/null | grep -oE 'token=[A-Za-z0-9_-]+' | tail -1 | cut -d= -f2); \
	if [ -z "$$token" ]; then echo "error: could not find token" >&2; exit 1; fi; \
	echo "http://127.0.0.1:3080/?token=$$token"

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
	@echo "   Run 'make url' to get the GUI URL"

stop: ## Stop the running container
	-$(CONTAINER_ENGINE) stop $(CONTAINER_NAME) 2>/dev/null || true

rm: stop ## Remove the container
	-$(CONTAINER_ENGINE) rm -f $(CONTAINER_NAME) 2>/dev/null || true

restart: rm start ## Restart the container

logs: ## Tail container logs
	$(CONTAINER_ENGINE) logs -f $(CONTAINER_NAME)

shell: ## Open a zsh shell inside the running container
	$(CONTAINER_ENGINE) exec -it $(CONTAINER_NAME) zsh

root-shell: ## Open a root shell (useful for debugging permissions)
	$(CONTAINER_ENGINE) exec -it -u root $(CONTAINER_NAME) zsh

url: ## Print/open the GUI URL
	@token=$$(podman logs $(CONTAINER_NAME) 2>/dev/null | grep -oE 'token=[A-Za-z0-9_-]+' | tail -1 | cut -d= -f2); \
	if [ -z "$$token" ]; then echo "error: could not find token in container logs" >&2; exit 1; fi; \
	url="http://127.0.0.1:3080/?token=$$token"; \
	echo "$$url"; \
	open "$$url" 2>/dev/null || true

exec: ## Run a command inside the dsh container
	@exec podman exec $(CONTAINER_NAME) $$@

token: ## Print the current access token
	@podman logs $(CONTAINER_NAME) 2>/dev/null | grep -oE 'token=[A-Za-z0-9_-]+' | tail -1 | cut -d= -f2

remote: ## Get the remote GUI URL (cloudflare + token, for phone)
	@token=$$(make token); \
	if [ -z "$$token" ]; then echo "error: no token in container logs" >&2; exit 1; fi; \
	echo "https://$(CLOUDFLARE_HOST)/?token=$$token"

status: ## Show container status + health
	@podman inspect $(CONTAINER_NAME) --format \
		'Container: {{.Name}}\nStatus:  {{.State.Status}}\nHealth:  {{.State.Health.Status}}\nStarted: {{.State.StartedAt}}' 2>/dev/null

up: ## Start services via compose (detached)
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) up -d --build

down: ## Stop and remove compose services
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) down

compose-logs: ## Tail compose logs
	$(CONTAINER_ENGINE) compose -f $(COMPOSE_FILE) logs -f

ps: ## List running containers
	$(CONTAINER_ENGINE) ps

clean: rm ## Remove container and dangling images
	-$(CONTAINER_ENGINE) image prune -f
	@echo "🧹 Cleaned up containers and dangling images"

clean-all: clean ## Remove container, images, volumes, and secrets
	-$(CONTAINER_ENGINE) volume rm dsh_dsh-home 2>/dev/null || true
	-$(CONTAINER_ENGINE) rmi $(IMAGE_NAME) 2>/dev/null || true
	-$(CONTAINER_ENGINE) secret rm $(SECRET_NAME) 2>/dev/null || true
	@echo "🧹 Full cleanup complete"

inspect: ## Inspect the image metadata
	$(CONTAINER_ENGINE) inspect $(IMAGE_NAME) | less