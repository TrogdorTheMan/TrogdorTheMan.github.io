# TrogdorTheMan.github.io

Personal dev/IT blog and portfolio at [TrogdorTheMan.github.io](https://TrogdorTheMan.github.io).

## Stack

- **SSG:** [Hugo](https://gohugo.io/)
- **Theme:** [PaperMod](https://github.com/adityatelange/hugo-PaperMod) (git submodule)
- **Hosting:** GitHub Pages
- **Deploy:** GitHub Actions — push to `main` triggers a Hugo build and deploys via the Pages artifact API

## Content structure

```
content/
  about/          # About page
  posts/          # Blog posts (PowerShell, Azure, SharePoint/M365, GitHub Actions, etc.)
  projects/       # Portfolio project writeups
```

## Deploy

Push to `main`. The GitHub Actions workflow at `.github/workflows/deploy.yml` handles everything:

1. Checks out the repo with submodules
2. Builds with `hugo --minify`
3. Uploads the `public/` directory as a Pages artifact
4. Deploys to GitHub Pages

## First-time GitHub setup

1. Create a **public** GitHub repo named `TrogdorTheMan.github.io` (no auto-generated files)
2. Push this repo to it
3. In repo settings → Pages → Source → set to **GitHub Actions**

After that, every push to `main` auto-deploys.
