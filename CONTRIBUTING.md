# Contributing

Thanks for your interest in improving the Saturday Morning Productions website.  This site is public so we can all learn from it.

## Ways to Help

**Found a security problem?**  Please don't open a public issue.  See [SECURITY.md](SECURITY.md) for how to report it privately.

For non-security issues:

- **Report a problem**: open an [issue](https://github.com/saturdaymp/saturdaymp.github.io/issues) describing what you saw, what you expected, and the page it happened on.
- **Suggest an improvement**: open an issue first if it's a larger change, so we can talk it through before you spend time on it.
- **Send a pull request**: small fixes such as typos, broken links, or styling glitches are welcome without an issue first.

## Getting Set Up

Fork and clone the repository, then run the site locally.

With Docker (recommended):

```bash
docker compose up app
```

Or with a local Ruby 3.4 or newer:

```bash
bundle install
bundle exec jekyll serve --livereload
```

Either way the site is served at [http://localhost:4000](http://localhost:4000) and reloads as you edit.

See the [README](README.md) for the project layout and how the Bootstrap gem integration works.

## Making Changes

- **Branch off `main`** and keep each pull request focused on one thing.
- **Check your change in the browser** before opening a pull request.  Confirm it looks right at both mobile and desktop widths.
- **Match the surrounding code**: Bootstrap 5.3 utility classes where they do the job, and a per-page Sass partial in `_sass/` when custom styles are needed.
- **Bootstrap comes from the Ruby gem**, not a CDN.  Please don't add CDN `<link>` or `<script>` tags for it.
- **New root-level files** (config, docs, scripts) need to be added to the `exclude` list in `_config.yml` so they aren't published to the live site.
- **Images** belong in `assets/images/`, grouped by the page that uses them.

## Pull Requests

1. Push your branch to your fork and open a pull request against `main`.
2. Describe what changed and why.  Screenshots help a lot for visual changes.
3. Automated checks run on the pull request, and a review may leave some comments.  Push follow-up commits to the same branch to address them.
4. Once it's approved and the checks pass, we'll merge it.  Merging to `main` deploys the site automatically.

## Questions

Not sure about something?  Open an issue or email [support@saturdaymp.com](mailto:support@saturdaymp.com) and we'll help.