# corymf.com

Personal portfolio, resume, and dev/IT blog at [corymf.com](https://corymf.com). The old [TrogdorTheMan.github.io](https://TrogdorTheMan.github.io) address redirects here.

## Stack

- **SSG:** [Hugo](https://gohugo.io/) 0.146+ (new template system)
- **Theme:** [PaperMod](https://github.com/adityatelange/hugo-PaperMod) (git submodule) with custom portfolio layouts
- **Hosting:** GitHub Pages with the corymf.com custom domain
- **Deploy:** GitHub Actions. Push to `main` triggers a Hugo build and deploys via the Pages artifact API.
- **CMS:** [Sveltia CMS](https://github.com/sveltia/sveltia-cms) at [/admin/](https://corymf.com/admin/) for in-browser editing
- **Syndication:** Zapier watches a dedicated RSS feed and shares flagged posts to LinkedIn

## Structure

```
content/
  about/                  # About page
  resume/                 # HTML resume
  posts/                  # Blog posts (PowerShell, Azure, SharePoint/M365, AI, etc.)
  projects/               # Portfolio project writeups (ordered by front matter weight)
layouts/
  home.html               # Custom portfolio homepage: hero, stats, project cards, recent posts
  projects/list.html      # Projects section as a card grid
  posts/section.linkedin.xml  # LinkedIn share feed template (see below)
  _partials/project-card.html
assets/css/extended/
  portfolio.css           # Portfolio styles; accent color, cards, stats, buttons
static/
  admin/                  # Sveltia CMS: index.html + config.yml
  images/                 # Hero headshot, doubles as the default og:image for link cards
```

Hero copy, skill chips, and the stats row are configured in `hugo.toml` under `params.heroSkills` and `params.heroStats`. The hero image and default share image are `static/images/cory-francis.jpg`, wired up via `params.heroImage` and `params.images`.

## Writing and publishing posts

Two ways to write:

1. **In the browser:** go to [/admin/](https://corymf.com/admin/) and sign in with a fine-grained GitHub PAT (repo-scoped, Contents read/write). Saving commits straight to `main`, which deploys automatically.
2. **In the repo:** add a markdown file under `content/posts/` and push.

Post front matter controls visibility and syndication:

- `draft: true` hides the post from the entire site. New CMS posts default to draft.
- `shareLinkedIn: true` opts the post into LinkedIn sharing. Defaults to off.
- `tags` become LinkedIn hashtags (see below). In the CMS, add them one per item with the add button; comma-separated strings also get split correctly for hashtags.
- `description` is the post summary and og:description shown on link cards.

## LinkedIn syndication

Publishing to LinkedIn is opt-in per post and fully automatic once flagged:

1. A post with `draft: false` and `shareLinkedIn: true` appears in a dedicated feed at `/posts/linkedin.xml` (custom `linkedin` output format in `hugo.toml`, template at `layouts/posts/section.linkedin.xml`, enabled in `content/posts/_index.md`).
2. The feed item description is the **full post body** converted to plain text (paragraphs preserved, list items become bullets, capped under LinkedIn's 3000-char limit), plus all tags rendered as hashtags on their own line (`#PowerShell #SharePoint`). Non-alphanumeric characters are stripped from tags, so "Azure Functions" becomes `#AzureFunctions`. Don't hand-write hashtags at the end of the body; a trailing hashtag line is stripped and replaced by the tags. XML minification is disabled in `hugo.toml` so the paragraph breaks survive.
3. A Zapier Zap (RSS trigger on that feed, LinkedIn "Share an Update" action) posts it within about 15 minutes of the deploy finishing. The share text maps the item description; the item link renders the card using the site's og tags.

Flipping `shareLinkedIn` on an older post shares it too; the feed only ever contains flagged posts, so nothing goes out by accident. The pipeline is one-way: deleting or editing a post after Zapier fires does not update or remove the LinkedIn post.

The regular feeds (`/index.xml`, `/posts/index.xml`) are untouched and list everything.

## Local development

```bash
git submodule update --init   # first clone only
hugo server
```

## Deploy

Push to `main`. The workflow at `.github/workflows/deploy.yml` checks out the repo with submodules, builds with `hugo --minify`, and deploys the Pages artifact. Add `[skip ci]` to a commit message to skip the deploy. CMS saves from `/admin/` deploy the same way.
