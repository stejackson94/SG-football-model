# template-uv-python

A modern Python project template using the [UV package manager](https://github.com/astral-sh/uv). This template provides a solid foundation for Python projects with best practices for development, testing, and deployment.

## Features

- **UV Package Manager** — Fast, reliable Python dependency management
- **Python 3.12+** — Modern Python with type hints support
- **Ruff** — Fast linting and code formatting
- **Pytest** — Testing framework
- **Pre-commit Hooks** — Automated code quality checks before commits
- **Docker Support** — Ready-to-use Dockerfile for containerization
- **GitHub Actions CI** — Automated code quality checks on push/PR
- **Makefile Commands** — Easy-to-use development commands

## Prerequisites

- **uv** — [Install uv](https://github.com/astral-sh/uv#installation)
- **Python 3.12+** — Required by this template
- **Docker** (optional) — For containerized deployment

## Quick Start

1. **Clone and set up the project:**
   ```bash
   git clone <your-repo-url>
   cd template-uv-python
   make setup
   ```

2. **Install dependencies:**
   ```bash
   uv sync --extra dev
   ```

3. **Run code quality checks:**
   ```bash
   make check
   ```

4. **Format and lint code:**
   ```bash
   make format
   make lint
   ```

## Usage

### Development

- `make setup` — Initialize development environment with pre-commit hooks
- `make install-dev` — Install development dependencies
- `make check` — Run all code quality checks (linting, formatting)
- `make format` — Format code with ruff
- `make lint` — Lint and fix code with ruff
- `make commit` — Interactive conventional commit helper

### Running the Application

```bash
uv run python src/main.py
```

### Testing

```bash
uv run pytest
```

### Docker

Build and run with Docker:

```bash
docker build -t template-app .
docker run template-app
```

*Note: Update the `CMD` in the Dockerfile with your application's start command.*

## Project Structure

```
.
├── src/                    # Application source code
│   ├── __init__.py
│   ├── main.py            # Entry point
│   └── utils/             # Utility modules
├── .github/workflows/      # GitHub Actions CI/CD
├── pyproject.toml          # Project configuration and dependencies
├── uv.lock                 # Locked dependency versions
├── Dockerfile              # Container configuration
├── Makefile                # Development commands
└── README.md               # This file
```

## Configuration

### Python Version
Update `requires-python` in `pyproject.toml` to change the minimum Python version.

### Dependencies
Add dependencies to `pyproject.toml`:
```toml
[project]
dependencies = [
    "requests>=2.28.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "ruff>=0.1.0",
    "pre-commit>=4.5.0",
]
```

Then run: `uv sync --extra dev`

### Ruff Configuration
Customize linting and formatting rules in `pyproject.toml`:
```toml
[tool.ruff]
line-length = 100

[tool.ruff.format]
quote-style = "double"
```

## License

MIT

## Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Python Packaging Guide](https://packaging.python.org/)
