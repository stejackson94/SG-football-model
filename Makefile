.DEFAULT_GOAL := help

.PHONY: help setup install-dev setup-hooks check test format lint docs-serve docs-build

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

setup: ## Set up development environment
	@echo "🚀 Setting up development environment with uv..."
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "❌ uv is not installed. Please install it first:"; \
		echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"; \
		exit 1; \
	fi
	@$(MAKE) install-dev
	@$(MAKE) setup-hooks
	@echo "🟢🟢🟢 You are all set! 🟢🟢🟢"

install-dev: ## Install project and dev dependency group
	@echo "📦 Installing dependencies..."
	uv sync

setup-hooks: ## Install pre-commit git hooks
	@echo "🪝 Setting up pre-commit hooks..."
	uv run pre-commit install

check: ## Verify lock file, lint and formatting (no changes made)
	@echo "🚀 Checking lock file consistency with 'pyproject.toml'"
	uv lock --locked
	@echo "🔍 Linting code: Running ruff check"
	uv run ruff check .
	@echo "🎨 Checking code formatting: Running ruff format --check"
	uv run ruff format --check .
	@echo "✅ All code quality checks passed!"

test: ## Run pytest with coverage
	uv run pytest --cov --cov-report=term-missing

format: ## Format code with ruff
	@echo "🎨 Formatting code: Running ruff format"
	uv run ruff format .

lint: ## Run ruff linting and apply safe fixes
	@echo "🔧 Linting and fixing code: Running ruff check --fix"
	uv run ruff check . --fix

docs-serve: ## Serve the docs site locally with live reload
	uv run --group docs zensical serve

docs-build: ## Build the docs site with strict link checking
	uv run --group docs zensical build --clean --strict
