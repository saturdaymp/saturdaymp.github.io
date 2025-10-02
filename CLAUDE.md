# CLAUDE.md

This is a Jekyll-based GitHub Pages website for Saturday Morning Productions.

## Project Overview

- **Site Title**: Saturday Morning Productions
- **URL**: https://saturdaymp.github.io
- **Description**: The Saturday Morning Productions website
- **Jekyll Version**: Uses GitHub Pages gem which includes Jekyll and dependencies

## Project Structure

```
.
├── _config.yml           # Jekyll configuration
├── _layouts/             # Layout templates
│   └── default.html      # Default layout with header/footer
├── _site/                # Generated site (excluded from git)
├── .github/
│   └── workflows/
│       └── jekyll-gh-pages.yml  # GitHub Actions deployment workflow
├── index.md              # Homepage content
├── Gemfile               # Ruby dependencies
├── docker-compose.yml    # Docker setup for local development
└── docker-entrypoint.sh  # Docker initialization script
```

## Configuration

The site is configured in `_config.yml`:
- Markdown processor: kramdown
- Syntax highlighter: rouge
- Plugins: jekyll-sitemap, jekyll-feed

## Local Development

### Using Docker (Recommended)

```bash
docker-compose up
```

The site will be available at:
- Website: http://localhost:4000
- LiveReload: Port 35729 (automatic browser refresh on file changes)

The Docker setup:
- Uses Ruby 3.4.6 base image
- Runs Jekyll with watch, force polling, and livereload enabled
- Mounts the current directory as `/app`
- Persists bundle gems in a Docker volume

### Manual Setup

```bash
bundle install
bundle exec jekyll serve --livereload
```

## Deployment

The site automatically deploys to GitHub Pages via GitHub Actions when changes are pushed to the `main` branch.

The workflow (`jekyll-gh-pages.yml`):
1. Checks out the repository
2. Sets up GitHub Pages
3. Builds the site with Jekyll
4. Uploads the build artifact
5. Deploys to GitHub Pages

Manual deployment can be triggered via the Actions tab in GitHub.

## Content Management

### Adding Pages

Create a new `.md` file in the root directory with front matter:

```markdown
---
layout: default
title: Page Title
---

# Page content here
```

### Layouts

The default layout (`_layouts/default.html`) includes:
- Responsive meta tags
- Site title and page title in `<title>`
- Header with site title link
- Main content area
- Footer with copyright notice

## Dependencies

Main dependencies (via `github-pages` gem):
- Jekyll
- jekyll-sitemap
- jekyll-feed
- webrick (for Ruby 3.0+ compatibility)

See `Gemfile.lock` for complete dependency tree.
