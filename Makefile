.DEFAULT_GOAL := help
.PHONY: help dev build up down logs clean migrate seed test lint

# ==============================================================================
# Environment & Setup
# ==============================================================================

help: ## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ==============================================================================
# Container Management (Docker Compose)
# ==============================================================================

build: ## Build all container images (FE, BE, AI Service)
	docker compose build

up: ## Start the entire container stack in detached mode
	docker compose up -d

down: ## Stop and remove all containers, networks, and volumes
	docker compose down

restart: down up ## Restart the entire Docker Compose network

logs: ## Follow logs across all containers
	docker compose logs -f

logs-be: ## Follow Node.js core backend logs
	docker compose logs -f backend

logs-ai: ## Follow FastAPI AI service logs
	docker compose logs -f ai-engine

# ==============================================================================
# Database & Vector Store Operations
# ==============================================================================

migrate: ## Run ORM database migrations (PostgreSQL / pgvector)
	docker compose exec backend npm run migration:run

migrate-dev: ## Generate a new migration based on schema changes
	docker compose exec backend npm run migration:generate

seed: ## Seed the database with initial users and test data
	docker compose exec backend npm run seed

# ==============================================================================
# Ingestion & AI Pipeline
# ==============================================================================

ingest: ## Trigger the AI data ingestion and chunking script
	docker compose exec ai-engine python -m app.scripts.ingest

# ==============================================================================
# Testing, Code Quality & Clean
# ==============================================================================

test: ## Execute test suites across all services
	docker compose exec backend npm test
	docker compose exec ai-engine pytest

lint: ## Run linters across backend and AI engine
	docker compose exec backend npm run lint
	docker compose exec ai-engine ruff check .

clean: ## Remove dangling images, volumes, and temporary cache
	docker system prune -f
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type d -name "node_modules" -prune -o -type d -name "dist" -exec rm -r {} +