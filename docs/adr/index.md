# Architecture Decision Records

Each ADR records one significant decision: the context, what was decided and the consequences.

## Adding an ADR

1. Copy the most recent ADR to `docs/adr/NNNN-short-title.md`, using the next number.
2. Fill in **Status**, **Context**, **Decision** and **Consequences**.
3. Add it to the `ADRs` section of `nav` in `mkdocs.yml`.

ADRs are immutable once accepted. To change a decision, write a new ADR that supersedes the old one and set the old one's status to `Superseded by ADR-NNNN`.

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [0001](0001-docs-site-zensical.md) | Docs site with Zensical on GitHub Pages | Accepted |
