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
├── _data/                # Data files
│   └── youtube_videos.json  # YouTube video data (auto-updated by GitHub Actions)
├── _layouts/             # Layout templates
│   └── default.html      # Default layout with Bootstrap 5 integration
├── _includes/            # Reusable components
│   ├── body_header.html  # Site header with navigation menu
│   ├── body_footer.html  # Site footer
│   ├── box.html          # Box component for homepage
│   └── consult_button.html  # "Let's Chat" button component
├── _plugins/             # Custom Jekyll plugins
│   ├── bootstrap_gem_path.rb  # Adds Bootstrap gem to Sass load paths
│   └── bootstrap_js_copier.rb # Copies Bootstrap JS from gem to assets
├── _sass/                # Sass partials
│   ├── _home.scss        # Homepage styles
│   ├── _about.scss       # About page styles
│   ├── _contact.scss     # Contact page styles
│   ├── _videos.scss      # Videos page styles
│   ├── _body_header.scss # Header styles
│   └── _body_footer.scss # Footer styles
├── assets/
│   ├── css/              # Compiled CSS
│   │   └── main.scss     # Main stylesheet with Bootstrap imports
│   ├── js/               # JavaScript files
│   │   └── vendor/       # Third-party JS (Bootstrap copied here at build)
│   └── images/           # Image assets
│       ├── home/         # Homepage images
│       ├── about/        # About page images
│       ├── contact/      # Contact page images
│       └── footer/       # Footer images
├── scripts/              # Utility scripts
│   └── fetch-youtube-videos.sh  # Script to fetch YouTube videos
├── _site/                # Generated site (excluded from git)
├── .github/
│   └── workflows/
│       ├── jekyll.yml    # GitHub Actions deployment workflow
│       └── fetch-youtube-videos.yml  # YouTube video fetch workflow
├── pages/                # Site pages
│   ├── index.html        # Homepage (permalink: /)
│   ├── about.md          # About page (permalink: /about/)
│   ├── contact.md        # Contact page (permalink: /contact/)
│   └── videos.html       # SaturdayMP Show videos page (permalink: /videos/)
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
- Excludes: Gemfile, Gemfile.lock, vendor/, docker files, LICENSE, README.md, CLAUDE.md, AGENTS.md, scripts/

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

The site automatically deploys to GitHub Pages via GitHub Actions. The deployment workflow is triggered when:

1. Changes are pushed to the `main` branch
2. Manual workflow dispatch from the Actions tab
3. The "Fetch YouTube Videos" workflow completes successfully (ensures new videos are deployed automatically)

The workflow ([.github/workflows/jekyll.yml](.github/workflows/jekyll.yml)):
1. Checks out the repository
2. Sets up Ruby 3.4 with bundler caching
3. Sets up GitHub Pages
4. Builds the site with Jekyll in production mode
5. Uploads the build artifact
6. Deploys to GitHub Pages

**Note**: The YouTube fetch workflow only triggers a deployment when videos are actually updated, avoiding unnecessary rebuilds.

## YouTube Videos Integration

The site displays videos from The SaturdayMP Show YouTube channel. Videos are fetched automatically via GitHub Actions.

### How It Works

1. **GitHub Actions Workflow** ([.github/workflows/fetch-youtube-videos.yml](.github/workflows/fetch-youtube-videos.yml)):
   - Runs weekly on Sunday at midnight UTC
   - Can be triggered manually from the Actions tab
   - Fetches latest 10 videos from the YouTube API
   - Creates a PR with auto-merge enabled
   - When changes are detected, triggers the Jekyll deployment workflow via repository_dispatch

2. **Fetch Script** ([scripts/fetch-youtube-videos.sh](scripts/fetch-youtube-videos.sh)):
   - Standalone bash script that fetches videos from YouTube API
   - Can be run manually for testing:
     ```bash
     YOUTUBE_API_KEY=your_key ./scripts/fetch-youtube-videos.sh
     ```

3. **Data Storage** (`_data/youtube_videos.json`):
   - Stores video metadata (id, title, description, thumbnail URLs)
   - Automatically updated by the GitHub Actions workflow

### Setup Requirements

1. **YouTube Data API Key**:
   - Create a Google Cloud project
   - Enable YouTube Data API v3
   - Create an API key
   - Add as GitHub Secret: `YOUTUBE_API_KEY`

2. **Repository Settings**:
   - Enable "Allow auto-merge" in Settings > General > Pull Requests

## Content Management

### Pages

The site includes the following pages:

1. **Homepage** ([pages/index.html](pages/index.html))
   - Permalink: `/`
   - Uses Liquid templating and Bootstrap 5 components
   - Features: hero image, tagline section, three-column feature boxes
   - SaturdayMP Show section with latest video and show description
   - Includes: consult_button.html and box.html components

2. **Videos Page** ([pages/videos.html](pages/videos.html))
   - Permalink: `/videos/`
   - Displays The SaturdayMP Show episodes
   - Features latest video embed and grid of previous episodes
   - Data loaded from `_data/youtube_videos.json`

3. **About Page** ([pages/about.md](pages/about.md))
   - Permalink: `/about/`
   - Content: Company history and Weekly Dev Chat sponsorship
   - Includes: consult_button.html component

4. **Contact Page** ([pages/contact.md](pages/contact.md))
   - Permalink: `/contact/`
   - Content: Contact information, business hours, and email addresses
   - Features: Phone and email CTAs

### Adding New Pages

Create a new `.md` file in the `pages/` directory with front matter:

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
- Bootstrap JavaScript (copied from gem via plugin)

### Includes

Reusable components in [_includes/](_includes/):
- `body_header.html` - Site navigation header with responsive menu (Home, SaturdayMP Show, About, Contact) and "Let's Chat" button
- `body_footer.html` - Site footer with logo, sitemap links, social media icons, and contact info
- `box.html` - Feature box component (used on homepage)
- `consult_button.html` - "Let's Chat" call-to-action button (opens Calendly widget)

## Styling

The site uses a custom Bootstrap 5.3.0 integration:

### Sass Architecture

- **Main stylesheet**: [assets/css/main.scss](assets/css/main.scss)
  - Imports Bootstrap from the gem
  - Imports custom Sass partials from `_sass/`

- **Custom partials** (in [_sass/](_sass/) directory):
  - `_home.scss` - Homepage-specific styles (including SaturdayMP Show section)
  - `_about.scss` - About page styles
  - `_contact.scss` - Contact page styles
  - `_videos.scss` - Videos page styles
  - `_body_header.scss` - Header and navigation styles
  - `_body_footer.scss` - Footer component styles

### Bootstrap Integration

The site uses custom Jekyll plugins for Bootstrap integration:

1. **[_plugins/bootstrap_gem_path.rb](_plugins/bootstrap_gem_path.rb)**:
   - Dynamically locates the Bootstrap gem installation
   - Adds Bootstrap's stylesheet path to Jekyll's Sass load paths
   - Enables importing Bootstrap directly in Sass files

2. **[_plugins/bootstrap_js_copier.rb](_plugins/bootstrap_js_copier.rb)**:
   - Copies Bootstrap JavaScript from the gem to `assets/js/vendor/`
   - Runs at build time, ensuring JS matches the gem version
   - Eliminates need for CDN-hosted JavaScript

## Dependencies

Main dependencies (defined in [Gemfile](Gemfile)):
- **Jekyll**: ~> 4.4.0 (static site generator)
- **Bootstrap**: ~> 5.3.0 (CSS framework via Ruby gem)
- **webrick**: ~> 1.7 (for Ruby 3.0+ compatibility)

Note: The site previously used the `github-pages` gem but now uses standalone Jekyll for more control over versions.

See [Gemfile.lock](Gemfile.lock) for complete dependency tree.
