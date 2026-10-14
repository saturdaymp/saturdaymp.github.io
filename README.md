# Saturday Morning Productions Website

[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=fe8e86)](https://github.com/sponsors/saturdaymp)

The official website for Saturday Morning Productions, built with Jekyll and hosted on GitHub Pages.  Let me know if you spot any issues, have an improvement, or any questions by opening a [Issue](https://github.com/saturdaymp/saturdaymp.github.io/issues) or [Pull Request](https://github.com/saturdaymp/saturdaymp.github.io/pulls).  This site is public so we can all learn from it!

See how this site was migrated from a Rails app to Jekyll:

https://www.youtube.com/playlist?list=PLYPcrKbLqwutOPHv6zimONxErY7ke9tWn


## About Saturday Morning Productions

Saturday Morning Productions is a software development and consulting company based in Edmonton, Alberta, Canada. Since 2009, we've been helping people ship high-quality software faster.  Feel free to contact us if you are interested in our services or have any questions!

**Contact Us:**
- Email: [support@saturdaymp.com](mailto:support@saturdaymp.com)
- Website: [https://saturdaymp.com](https://saturdaymp.com)

## Running Locally

### Using Docker (Recommended)

```bash
docker compose up app
```

### Manual Setup

Requires Ruby 3.4 or newer. Docker uses Ruby 4.0 and the deployment workflow uses Ruby 3.4.

```bash
bundle install
bundle exec jekyll serve --livereload
```

The site will be available at:
- Website: [http://localhost:4000](http://localhost:4000)
- LiveReload: Port 35729 (automatic browser refresh on file changes)

## Project Structure

```
_data/          Site data files (YouTube video metadata)
_includes/      Reusable HTML partials (header, footer, boxes, buttons)
_layouts/       Page layouts (default.html)
_plugins/       Custom Jekyll plugins for the Bootstrap gem integration
_sass/          Per-page Sass partials
assets/         CSS entry points, images, and vendored Bootstrap JS
pages/          Site pages (home, about, contact, videos)
scripts/        Helper scripts (YouTube video fetcher)
.github/        GitHub Actions workflows and Dependabot configuration
```

## Architecture

The site uses Jekyll 4.4 with Bootstrap 5.3 loaded via a **Ruby gem** (not a CDN). Custom plugins in `_plugins/` handle the integration:
- `bootstrap_gem_path.rb` adds Bootstrap's Sass to Jekyll's load paths
- `bootstrap_js_copier.rb` copies Bootstrap JS from the gem to `assets/js/vendor/` at build time

### Adding New Pages

Create a new file in `pages/` with front matter:

```markdown
---
layout: default
title: Page Title
permalink: /page-url/
description: Page description for SEO
---

Page content here.
```

## Deployment

This website automatically deploys to GitHub Pages using GitHub Actions. The deployment workflow is triggered when:

1. Changes are pushed or merged to the `main` branch
2. Manual workflow dispatch from the Actions tab

**Deployment Process:**
1. **Build Job**: Sets up Ruby 3.4, installs dependencies via Bundler, and builds the Jekyll site
2. **Deploy Job**: Deploys the built site to GitHub Pages

The site is built using the production Jekyll environment and is available at [https://saturdaymp.github.io](https://saturdaymp.github.io).

**Note**: When adding new configuration files, documentation files, or development-related files to the repository, remember to update the `exclude` list in `_config.yml` to prevent them from being processed and published to the live site.

## YouTube Videos Integration

The site displays videos from The SaturdayMP Show YouTube channel. A GitHub Actions workflow automatically fetches the latest videos weekly.

### Setup

1. **Create a YouTube Data API Key**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a project and enable YouTube Data API v3
   - Create an API key

2. **Add GitHub Secret**:
   - Go to repository Settings > Secrets and variables > Actions
   - Add secret: `YOUTUBE_API_KEY` with your API key

3. **Enable Auto-merge**:
   - Go to repository Settings > General > Pull Requests
   - Enable "Allow auto-merge"

4. **Run the Workflow**:
   - Go to Actions > "Fetch YouTube Videos"
   - Click "Run workflow" to fetch videos

The workflow runs automatically every Sunday at midnight UTC, creating a PR that auto-merges when checks pass. When the PR is merged, the Jekyll deployment workflow is triggered to rebuild and deploy the site with the new videos.

### How It Works

The fetch script (`scripts/fetch-youtube-videos.sh`) does the following:

1. **Fetches video metadata** from the YouTube PlaylistItems API (paginated)
2. **Fetches view counts** from the YouTube Videos API (batched by 50)
3. **Downloads thumbnails** to `assets/images/youtube-thumbnails/` as `<video-id>.jpg`. Existing thumbnails are only re-downloaded if the remote file is newer (using `curl -z`).
4. **Saves video data** to `_data/youtube_videos.json` with local thumbnail paths

### Videos Page

The videos page (`pages/videos.html`) displays:

- **Latest Episode**: Featured video with embedded player
- **Recent Episodes**: The next 3 most recent videos
- **Most Popular**: Top 3 videos by view count
- **Discover Something New**: 3 randomly selected videos with a Shuffle button to pick new ones (client-side randomization with fade animation)

### Manual Testing

You can test the fetch script locally:

```bash
YOUTUBE_API_KEY=your_key ./scripts/fetch-youtube-videos.sh
```
## Dependency Updates

Dependabot is configured in `.github/dependabot.yml` to check for updates every Monday morning (Edmonton time) for:

- **Bundler**: gems in `Gemfile` / `Gemfile.lock`
- **GitHub Actions**: actions used by the workflows
- **Docker**: the Ruby image used by `docker-compose.yml`

Minor and patch updates are grouped into a single PR; security updates get their own.

## Security

Found a security problem? Please don't open a public issue.  See [SECURITY.md](SECURITY.md) for how to report it privately, either through the repository's [Security tab](https://github.com/saturdaymp/saturdaymp.github.io/security) or by email.

## Contributing

Issues and pull requests are welcome.  See [CONTRIBUTING.md](CONTRIBUTING.md) for how to get set up, what to check before opening a pull request, and the conventions this site follows.

## License

Released under the [MIT License](LICENSE).
