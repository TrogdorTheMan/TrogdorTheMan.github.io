---
title: "Seafair Site Rebuild"
date: 2026-06-14
weight: 2
draft: false
tags: ["Azure", "Static Web Apps", "Azure DevOps", "Entra ID", "Performance"]
description: "Full rebuild of a 19-page event site on Azure Static Web Apps. Mobile PageSpeed 63 to 99, LCP reduced 90%."
---

A ground-up rebuild of an event organization's public website on the Azure stack.

## Results

- Mobile PageSpeed score: 63 → 99
- LCP reduced by ~90%
- 19 pages, fully static, CDN-served

## Stack

- Azure Static Web Apps
- Azure Pipelines / Azure DevOps
- Entra ID for admin auth
- GitHub for source control and PR-based deploys
