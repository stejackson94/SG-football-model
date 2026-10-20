setup: ## Set up development environment
	@echo "🚀 Setting up development environment with uv..."
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "❌ uv is not installed. Please install it first:"; \
		echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"; \
		exit 1; \
	fi
	@make install-dev
	@make setup-hooks
	@echo "🟢🟢🟢 You are all set! 🟢🟢🟢"

install-dev: #installs development dependencies
	@echo "📦 Installing dependencies..."
	uv sync --extra dev

setup-hooks: ## Set up pre-commit hooks
	@echo "🪝 Setting up pre-commit hooks..."
	uv pip install pre-commit
	uv run pre-commit install

check: #runs checks
	@echo "🚀 Checking lock file consistency with 'pyproject.toml'"
	uv lock --locked
	@echo "🔍 Linting code: Running ruff check"
	uv run ruff check .
	@echo "🎨 Checking code formatting: Running ruff format --check"
	uv run ruff format .
	@echo "✅ All code quality checks passed!"

commit: ## Interactive conventional commit helper
	./scripts/commit.sh

format: ## Format code with ruff
	@echo "🎨 Formatting code: Running ruff format"
	uv run ruff format .

lint: ## Run ruff linting and apply safe fixes
	@echo "🔧 Linting and fixing code: Running ruff check --fix"
	uv run ruff check . --fix
