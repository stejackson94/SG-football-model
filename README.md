# SG Football Model

**Docs:** https://stejackson94.github.io/SG-football-model/

A football ML/AI project built by Ste and George to learn and build up their portfolios. It's a personal project, unrelated to any employer's data or systems.

## Goals

The project ingests football match data, starting with the Premier League, and predicts the winner of each week's games.

Once the prediction model works, it grows into a wider platform. Experiments are tracked in MLflow and predictions are served through FastAPI. An LLM analyst sits on top and answers questions from real data, using tool calling and RAG with a free hosted LLM API. Everything runs on Ste's homelab Kubernetes cluster, deployed with Helm, built by GitHub Actions and monitored with Prometheus and Grafana.

**Principle:** build a reliable prediction engine first, then add LLM features around it. The analyst must answer from backend data, not guess statistics.

## MVP

A basic prediction model for the Premier League:

- **Input:** historical Premier League results from [football-data.co.uk](https://www.football-data.co.uk/data.php)
- **Output:** home win, draw and away win probabilities for each fixture in the upcoming gameweek, using only data available before kick-off
- **Acceptance criteria:** beats a reasonable baseline (for example, historical home/draw/away rates) on log loss, evaluated on held-out future seasons rather than a random split

## Longer-term goals

- Ingest and validate historical match data, with a team-name mapping across seasons
- Build team-form and match features from prior matches only, so no future information leaks in
- Train and evaluate home/draw/away probability models, adding expected goals later
- Benchmark against margin-free bookmaker implied probabilities, using log loss, Brier score, accuracy and calibration
- Track experiments and register model versions in MLflow
- Serve predictions through FastAPI (`/health`, `/teams`, `/matches`, `/predict`)
- Add an LLM analyst with controlled tools (`get_team_form`, `compare_teams`, `predict_match`, ...) and pgvector RAG with cited sources
- Deploy to homelab Kubernetes with Docker and Helm, using CI/CD, immutable image tags and a tested rollback plan
- Monitor API health, latency, errors, model version and LLM usage

## Architecture

```text
Web UI (Next.js / React)
        ↓
FastAPI — REST endpoints, prediction endpoint, AI analyst endpoint
        ├── Football data / statistics services ── PostgreSQL
        ├── ML inference service ── versioned model artifact
        └── AI analyst ── LLM API + controlled tools + RAG (pgvector)

Offline ML workflow:
Historical data → validation → feature engineering → train/evaluate → MLflow → register/promote model

Homelab Kubernetes:
Frontend · API · PostgreSQL · MLflow · training Jobs · model serving · Prometheus · Grafana
```

The architecture is built incrementally. It starts as a single API with local PostgreSQL, and microservices are added only if they're needed.

## Tech Stack

| Area | Technology |
|------|------------|
| Language / environment | Python 3.12+, uv |
| API | FastAPI + Pydantic |
| Database / migrations | PostgreSQL, Alembic, pgvector |
| Data / ML | pandas, scikit-learn, XGBoost |
| Experiment tracking | MLflow |
| LLM | Free hosted LLM API (OpenAI SDK-compatible) behind a provider abstraction |
| Frontend | Next.js + TypeScript (added after the API and model work) |
| Deployment | Docker, Kubernetes, Helm (homelab) |
| CI/CD | GitHub Actions |
| Monitoring | Prometheus + Grafana |
| Quality | Ruff, pytest, httpx, pre-commit |

## Roadmap

Work is tracked in [Plane](https://plane.so/) in project `AIML` ("Ai/ML Football Analytics"). Epics AIML-1 to AIML-9 cover phases P0 to P8, and each phase's tasks are nested under its epic.

| Phase | Focus | Exit criterion |
|-------|-------|----------------|
| P0 | Scope and setup | Reproducible local env, green CI on `main`, one season in PostgreSQL |
| P1 | Data platform | Repeatable ingestion and tested data access functions |
| P2 | First ML model | Benchmarked model, reproducible evaluation, no temporal leakage |
| P3 | MLflow and model serving | Versioned model behind a tested API |
| P4 | Homelab Kubernetes | API runs in the cluster, both contributors have secure access, rollback documented |
| P5 | LLM analyst and tools | Analyst answers by calling real backend functions |
| P6 | RAG and evaluation | Grounded answers with visible sources and repeatable evaluation |
| P7 | CD and observability | Monitored deployment pipeline with operational dashboards |
| P8 | Polish and portfolio | Portfolio-ready system (optional) |

## Data

The data comes from the [football-data.co.uk](https://www.football-data.co.uk/data.php) CSVs. They're free for personal use but **must not be redistributed**, so this repo commits a download script, not the data. Raw files go in `data/raw/` and are git-ignored.

## Prerequisites

- **uv** — [Install uv](https://github.com/astral-sh/uv#installation)
- **Python 3.12+**
- **Docker** (optional) — For containerized deployment

## Quick Start

1. **Clone and set up the project:**
   ```bash
   git clone <your-repo-url>
   cd SG-football-model
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

### Documentation

The docs site is built with [Zensical](https://zensical.org/) from `docs/` and published to GitHub Pages.

- `make docs-serve` — Serve the site locally with live reload
- `make docs-build` — Build the site with `--strict`, so broken links fail

The `Docs` workflow builds on pull requests that touch `docs/**`, `mkdocs.yml` or `README.md`, and deploys on merge to `main` when those paths change. Code-only merges don't redeploy. The overview page renders this README, so edit it here.

The site is public: keep homelab hostnames, IPs and Tailscale details out of `docs/`.

### Docker

Build and run with Docker:

```bash
docker build -t sg-football-model .
docker run sg-football-model
```

*Note: Update the `CMD` in the Dockerfile with your application's start command.*

## Project Structure

Monorepo layout. Folders other than `src/` are placeholders until their roadmap phase lands.

```
.
├── src/                    # Shared Python package and tests (uv template)
│   ├── main.py             # Entry point
│   ├── utils/              # Utility modules
│   └── test/               # pytest suite
├── apps/api/               # FastAPI service (P3)
├── ml/                     # Feature engineering, training and evaluation (P2)
├── ai/                     # LLM analyst, tools and RAG (P5–P6)
├── db/                     # PostgreSQL schema and Alembic migrations (P1)
├── infra/helm/             # Helm charts for homelab Kubernetes (P4)
├── monitoring/             # Prometheus and Grafana config (P7)
├── docs/                   # Docs site source: ADRs, data, models, API, runbooks
├── mkdocs.yml              # Docs site config and nav (read by Zensical)
├── scripts/                # Data download and helper scripts
├── data/                   # Local data only, git-ignored
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
