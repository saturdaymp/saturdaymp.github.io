# AGENTS.md

Jekyll 4.4 site using Bootstrap 5.3 via Ruby gem (not CDN). See `Gemfile`, `_config.yml`, and `README.md` for project details.

## Constraints

- **No AI attribution**: Do not add "Co-Authored-By", "Authored by Claude", or similar AI attribution to commits, PRs, or any content.  The developer is responsible for all changes and content, regardless of whether AI tools were used in the process.
- **Exclude list**: When adding new files to the repo root (config files, docs, scripts), add them to the `exclude` list in `_config.yml` so they aren't published to the live site.
- **Local dev**: Use `docker compose up app` to run locally at http://localhost:4000.
- **GitHub review conversations**: When asked to address feedback from a GitHub PR review (e.g. Copilot), fix the issue and reply to the review comment explaining what was changed and close the conversation.
