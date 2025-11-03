# AGENTS.md

This is a Jekyll-based GitHub Pages website for Saturday Morning Productions.

## Project Overview

- **Site Title**: Saturday Morning Productions
- **URL**: https://saturdaymp.github.io
- **Description**: The Saturday Morning Productions website
- **Jekyll Version**: 4.4.0 (standalone, not using GitHub Pages gem)
- **Bootstrap Version**: 5.3.0

## Project Structure

```
.
├── _config.yml           # Jekyll configuration
├── _layouts/             # Layout templates
│   └── default.html      # Default layout with Bootstrap 5 integration
├── _includes/            # Reusable components
│   ├── body_header.html  # Site header
│   ├── body_footer.html  # Site footer
│   ├── box.html          # Box component for homepage
│   └── consult_button.html  # Consultation button component
├── _plugins/             # Custom Jekyll plugins
│   └── bootstrap_gem_path.rb  # Adds Bootstrap gem to Sass load paths
├── _sass/                # Sass partials
│   ├── _home.scss        # Homepage styles
│   ├── _about.scss       # About page styles
│   ├── _contact.scss     # Contact page styles
│   ├── _body_header.scss # Header styles
│   ├── _body_footer.scss # Footer styles
│   └── _media.scss       # Media queries
├── assets/
│   ├── css/              # Compiled CSS
│   │   ├── main.scss     # Main stylesheet with Bootstrap imports
│   │   ├── _about.scss   # About page styles
│   │   └── _contact.scss # Contact page styles
│   └── images/           # Image assets
│       ├── home/         # Homepage images
│       ├── about/        # About page images
│       ├── contact/      # Contact page images
│       └── footer/       # Footer images
├── _site/                # Generated site (excluded from git)
├── .github/
│   └── workflows/
│       └── jekyll.yml    # GitHub Actions deployment workflow
├── index.html            # Homepage (HTML with Liquid templates)
├── about.md              # About page
├── contact.md            # Contact page
├── favicon.ico           # Site favicon
├── Gemfile               # Ruby dependencies
├── docker-compose.yml    # Docker setup for local development
└── docker-entrypoint.sh  # Docker initialization script
```

## Configuration

The site is configured in [_config.yml](_config.yml):
- Markdown processor: kramdown
- Syntax highlighter: rouge
- SASS deprecation warnings silenced for:
  - `import` (Bootstrap 5.3 compatibility)
  - `color-functions` (Bootstrap 5.3 compatibility)
  - `global-builtin` (Bootstrap 5.3 compatibility)
- Excludes: Gemfile, Gemfile.lock, vendor/, docker files, LICENSE, README.md, CLAUDE.md, AGENTS.md

**Note**: When adding new configuration files, documentation files, or development-related files to the repository, remember to update the `exclude` list in [_config.yml](_config.yml) to prevent them from being processed and published to the live site.

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

The workflow ([.github/workflows/jekyll.yml](.github/workflows/jekyll.yml)):
1. Checks out the repository
2. Sets up Ruby 3.4 with bundler caching
3. Sets up GitHub Pages
4. Builds the site with Jekyll in production mode
5. Uploads the build artifact
6. Deploys to GitHub Pages

Manual deployment can be triggered via the Actions tab in GitHub using the `workflow_dispatch` event.

## Content Management

### Pages

The site includes the following pages:

1. **Homepage** ([index.html](index.html))
   - Uses Liquid templating and Bootstrap 5 components
   - Features: hero image, tagline section, three-column feature boxes
   - Includes: consult_button.html and box.html components

2. **About Page** ([about.md](about.md))
   - Permalink: `/about/`
   - Content: Company history and Weekly Dev Chat sponsorship
   - Includes: consult_button.html component

3. **Contact Page** ([contact.md](contact.md))
   - Permalink: `/contact/`
   - Content: Contact information, business hours, and email addresses
   - Features: Phone and email CTAs

### Adding New Pages

Create a new `.md` file in the root directory with front matter:

```markdown
---
layout: default
title: Page Title
permalink: /page-url/
description: Page description for SEO
---

# Page content here
```

### Layouts

The default layout ([_layouts/default.html](_layouts/default.html)) includes:
- HTML5 structure with Bootstrap 5
- Responsive meta tags
- Page-specific or site-wide description meta tag
- Favicon link
- Bootstrap CSS (via [assets/css/main.css](assets/css/main.css))
- Header (via `body_header.html` include)
- Main content area with flexbox min-height layout
- Footer (via `body_footer.html` include)
- Bootstrap 5.1.3 JavaScript bundle from CDN

### Includes

Reusable components in [_includes/](_includes/):
- `body_header.html` - Site navigation header
- `body_footer.html` - Site footer with copyright and links
- `box.html` - Feature box component (used on homepage)
- `consult_button.html` - Call-to-action consultation button

## Styling

The site uses a custom Bootstrap 5.3.0 integration:

### Sass Architecture

- **Main stylesheet**: [assets/css/main.scss](assets/css/main.scss)
  - Imports Bootstrap from the gem
  - Imports custom Sass partials from `_sass/`
  - Custom partials are also duplicated in `assets/css/` for specific pages

- **Custom partials** (in [_sass/](_sass/) directory):
  - `_home.scss` - Homepage-specific styles
  - `_about.scss` - About page styles
  - `_contact.scss` - Contact page styles
  - `_body_header.scss` - Header component styles
  - `_body_footer.scss` - Footer component styles
  - `_media.scss` - Media queries and responsive design

### Bootstrap Integration

The site uses a custom Jekyll plugin ([_plugins/bootstrap_gem_path.rb](_plugins/bootstrap_gem_path.rb)) to:
- Dynamically locate the Bootstrap gem installation
- Add Bootstrap's stylesheet path to Jekyll's Sass load paths
- Enable importing Bootstrap directly in Sass files

## Dependencies

Main dependencies (defined in [Gemfile](Gemfile)):
- **Jekyll**: ~> 4.4.0 (static site generator)
- **Bootstrap**: ~> 5.3.0 (CSS framework via Ruby gem)
- **webrick**: ~> 1.7 (for Ruby 3.0+ compatibility)

Note: The site previously used the `github-pages` gem but now uses standalone Jekyll for more control over versions.

See [Gemfile.lock](Gemfile.lock) for complete dependency tree.
