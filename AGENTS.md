# AGENTS.md

Jekyll 4.4 site using Bootstrap 5.3 via Ruby gem (not CDN). See `Gemfile`, `_config.yml`, and `README.md` for project details.

## Constraints

- **No AI attribution**: Do not add "Co-Authored-By", "Authored by Claude", or similar AI attribution to commits, PRs, or any content.
- **Exclude list**: When adding new files to the repo root (config files, docs, scripts), add them to the `exclude` list in `_config.yml` so they aren't published to the live site.
- **Local dev**: Use `docker compose up` to run locally at http://localhost:4000.
