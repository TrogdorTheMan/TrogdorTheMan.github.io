---
title: "ai-job-tracker"
date: 2026-07-01
weight: 1
draft: false
tags: ["TypeScript", "React", "Azure", "AI", "Azure Functions"]
description: "AI-powered job search tracker in production on Azure Static Web Apps. Semantic resume/JD fit scoring, gap analysis, and AI cover letters with a bring-your-own-key model."
---

An AI-powered job search tool, live in production on Azure Static Web Apps. I built it to run my own job search, then open sourced it under AGPLv3.

## What it does

- Embeds resumes and job descriptions with text-embedding-3-small and scores fit via cosine similarity, surfacing fit scores and skill gap chips on a kanban board in real time
- Caches embeddings in Azure Table Storage so a resume is only sent to the model once
- Drafts cover letters and tailors resumes server-side with gpt-4o-mini via Azure Functions, keeping AI credentials out of the browser
- Bring-your-own-key Azure AI Foundry integration, so costs are capped to the user's own key
- Pulls listings through Adzuna and USAJobs API connectors

## Stack

- TypeScript, React, Vite SPA
- Azure Static Web Apps with an Azure Functions backend
- EasyAuth SSO
- Azure Table Storage for embedding cache
- GitHub Actions CI/CD

[View on GitHub](https://github.com/TrogdorTheMan/ai-job-tracker)
