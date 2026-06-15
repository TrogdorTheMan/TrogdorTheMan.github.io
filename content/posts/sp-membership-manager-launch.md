---
title: "I Built a Tool to Keep a Client Out of the SharePoint Admin Center"
date: 2026-06-10
draft: false
tags: ["PowerShell", "SharePoint", "GitHub Actions", "AI", ".NET"]
description: "A client needed to manage SharePoint site access a few times a year. Teaching them the admin center wasn't the answer."
---

A client of mine needed help managing SharePoint site access. Nothing complicated — add a user here, remove one there, maybe a few times a year. The problem was they're self-admittedly low-tech and had no business being handed admin center rights just to flip a few permissions.

Teaching them the SharePoint admin center wasn't a real solution. It's overkill for what they needed, and frankly not worth the support calls. So I built something simpler.

[SP-MembershipManager](/projects/sp-membership-manager/) is mostly PowerShell with a bit of C# to package it into an executable they can actually run. Under the hood it uses certificate-based Entra ID auth, parallel runspaces for performance, and DPAPI for keeping secrets encrypted at rest. There's also a GitHub Actions pipeline handling automated testing and releases.

The other thing worth mentioning: this was my first real hands-on project with AI-assisted development. Not just using it to answer questions, but leaning on it as a genuine part of the build process. It was fun, it was fast, and it was educational in ways I didn't expect — some good, some less so (more on that in a follow-up post).

The tool is MIT licensed. If you work in SharePoint environments and have clients or users who need a simpler way to manage site access, give it a look.

[View the repo on GitHub](https://github.com/TrogdorTheMan/SP-MembershipManager)
