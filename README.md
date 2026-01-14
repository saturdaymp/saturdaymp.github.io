# Saturday Morning Productions Website

[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=fe8e86)](https://github.com/sponsors/saturdaymp)

The official website for Saturday Morning Productions, built with Jekyll and hosted on GitHub Pages.

## About Saturday Morning Productions

Saturday Morning Productions is a software development and consulting company based in Edmonton, Alberta, Canada. Since 2009, we've been helping people ship high-quality software faster.  Feel free to contact us if you are interested in our services or have any questions!

**Contact Us:**
- Email: [info@saturdaymp.com](mailto:info@saturdaymp.com)
- Phone: 1-780-886-3406
- Website: [https://saturdaymp.github.io](https://saturdaymp.github.io)

## Running Locally

To run the website locally using Docker:

```bash
docker compose up app
```

The site will be available at:
- Website: [http://localhost:4000](http://localhost:4000)
- LiveReload: Port 35729 (automatic browser refresh on file changes)

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

The workflow runs automatically every Sunday at midnight UTC, creating a PR that auto-merges when checks pass.

### Manual Testing

You can test the fetch script locally:

```bash
YOUTUBE_API_KEY=your_key ./scripts/fetch-youtube-videos.sh
```

## Watch How This Site Was Built

- [SaturdayMP Show 68: Migrate From Rails to Jekyll (Part 1)](https://youtu.be/K2ddgnMDTFk)
- [SaturdayMP Show 69: Migrate From Rails to Jekyll (Part 2)](https://youtu.be/ShVTQ1wLTsI)
- [SaturdayMP Show 70: Migrate From Rails to Jekyll (Part 3)](https://youtu.be/0s_3jVIttnc)
- [SaturdayMP Show 71: Migrate From Rails to Jekyll (Part 4)](https://youtu.be/eJbMn75dQKo)
- [SaturdayMP Show 72: Migrate From Rails to Jekyll (Part 5)](https://youtu.be/eRCGlsGHNNM)
