---
title: "Repair-SharePointNames"
date: 2026-06-14
weight: 3
draft: false
tags: ["PowerShell", "SharePoint", "Migration"]
description: "PowerShell script for repairing file and folder names flagged by SPMT scan logs before SharePoint migration."
---

A PowerShell utility for cleaning up file and folder names before a SharePoint migration.

## What it does

SharePoint Migration Tool (SPMT) scan reports flag files and folders with invalid characters, reserved names, or length violations. This script parses those scan logs and renames the offending items in place, so migrations complete without manual remediation.

## Stack

- PowerShell 7+
- SPMT scan log parsing
- Bulk rename with conflict detection

[View on GitHub](https://github.com/TrogdorTheMan/Repair-SharePointNames)
