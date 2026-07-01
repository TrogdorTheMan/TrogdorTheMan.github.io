---
title: "SP-MembershipManager"
date: 2026-06-14
weight: 1
draft: false
tags: ["PowerShell", "SharePoint", "Entra ID", "GitHub Actions", ".NET"]
description: "PowerShell 7+ / C# .NET 8 tool for managing SharePoint site membership with cert-based Entra auth."
---

A PowerShell 7+ and C# .NET 8 tool for managing SharePoint Online site membership at scale.

## What it does

- Connects to SharePoint Online using certificate-based Entra ID authentication via MSAL
- Manages site membership across multiple sites in parallel using PowerShell runspaces
- Protects secrets with DPAPI
- Ships with a GitHub Actions CI/CD pipeline for automated testing and release

## Stack

- PowerShell 7+, C# .NET 8
- Microsoft.Identity.Client (MSAL) for cert-based auth
- DPAPI for credential protection
- Parallel runspaces for throughput
- GitHub Actions for CI/CD

[View on GitHub](https://github.com/TrogdorTheMan/SP-MembershipManager)
