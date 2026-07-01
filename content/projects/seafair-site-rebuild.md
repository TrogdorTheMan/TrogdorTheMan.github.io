---
title: "Seafair Pirates Site Rebuild & M365 Buildout"
date: 2026-06-14
weight: 3
draft: false
tags: ["Azure", "Static Web Apps", "Azure DevOps", "Entra ID", "Performance"]
description: "Full rebuild of a 19-page event site on Azure Static Web Apps, plus a complete M365 buildout for a 40+ member civic organization. Mobile PageSpeed 63 to 99, LCP reduced 90%."
---

A ground-up rebuild of the public website and Microsoft 365 environment for the Seafair Pirates, a 40+ member Seattle civic organization founded in 1949.

## Results

- Mobile PageSpeed score: 63 → 99
- LCP reduced by ~90%
- 19 pages, fully static, CDN-served
- Replaced WordPress hosting costs with Azure Static Web Apps

## The M365 side

The website was half the job. The organization also needed a members-only portal, so I built out a full M365 tenant: SharePoint for the portal, Entra ID B2B guest access for members, and MFA via Security Defaults.

## Stack

- Plain HTML/CSS on Azure Static Web Apps
- Azure Pipelines / Azure DevOps, PR-based deploys
- Azure Blob Storage
- Entra ID B2B, SharePoint Online, Security Defaults MFA

[Visit the live site](https://newsite.seafairpirates.org)
