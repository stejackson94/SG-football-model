# ADR-0001: Docs site with Zensical on GitHub Pages

**Status:** Accepted
**Date:** 2026-10-20
**Ticket:** AIML-59

## Context

Later phases produce ADRs, runbooks, model evaluation write-ups and architecture notes. They need one place to live, and the project wants a public portfolio link.

The ticket's default was MkDocs with the Material theme. Material is now in maintenance mode, and MkDocs 2.0 drops the plugin and theming systems Material depends on, so staying on it means pinning MkDocs 1.x indefinitely.

## Decision

Use [Zensical](https://zensical.org/), the successor to Material for MkDocs from the same team. The site builds from `docs/` and is published to GitHub Pages by GitHub Actions.

- The project is Python-only, so Zensical installs through uv as the `docs` extra. Docusaurus would add a Node toolchain for no gain.
- Config stays in `mkdocs.yml`, which Zensical reads natively.
- The site builds with `--strict` on pull requests, so broken links fail CI.
- The deploy only runs on pushes to `main` that touch docs inputs (`docs/**`, `mkdocs.yml`, `README.md` and the workflow file). Code-only merges don't redeploy.

## Consequences

- Docs are Markdown in the repo and reviewed in the same PRs as code.
- The overview page renders `README.md`, so the README stays the single source for project goals and setup.
- The site is public. Homelab details (hostnames, IPs, Tailscale config) must stay out of `docs/`.
- Zensical is pre-1.0, so it's pinned below 0.1 and upgrades need a local `make docs-build` check. Not every MkDocs plugin is supported yet; check the [compatibility page](https://zensical.org/compatibility/) before adding one.
- Rollback is cheap: because config stays in `mkdocs.yml`, switching back to MkDocs Material means swapping the `docs` extra and the build commands.
- `uv.lock` is in the workflow's path filters, so dependency bumps (including Dependabot's weekly grouped PRs) get a strict docs build. The trade-off is that any lockfile change on `main` redeploys the site.
