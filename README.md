# TrogdorTheMan.github.io

Personal portfolio, resume, and dev/IT blog at [TrogdorTheMan.github.io](https://TrogdorTheMan.github.io).

## Stack

- **SSG:** [Hugo](https://gohugo.io/) 0.146+ (new template system)
- **Theme:** [PaperMod](https://github.com/adityatelange/hugo-PaperMod) (git submodule) with custom portfolio layouts
- **Hosting:** GitHub Pages
- **Deploy:** GitHub Actions. Push to `main` triggers a Hugo build and deploys via the Pages artifact API.

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
  _partials/project-card.html
assets/css/extended/
  portfolio.css           # Portfolio styles; accent color, cards, stats, buttons
```

Hero copy, skill chips, and the stats row are configured in `hugo.toml` under `params.heroSkills` and `params.heroStats`.

## Local development

```bash
git submodule update --init   # first clone only
hugo server
```

## Deploy

Push to `main`. The workflow at `.github/workflows/deploy.yml` checks out the repo with submodules, builds with `hugo --minify`, and deploys the Pages artifact. Add `[skip ci]` to a commit message to skip the deploy.
