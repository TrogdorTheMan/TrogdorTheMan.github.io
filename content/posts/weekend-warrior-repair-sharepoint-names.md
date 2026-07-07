---
title: "Weekend Warrior: Repair-SharePointNames v1.0 is live!"
date: 2026-07-05
draft: false
tags: ["PowerShell", "SharePoint", "AI", "SysAdmin", "OpenSource"]
description: "I just published Repair-SharePointNames to PowerShell Gallery — bulk-fixes those INVALID_SHAREPOINT_NAME warnings SPMT dumps on you after a scan, with safe renaming, lock/temp file quarantine, and a full transaction log."
---

Quick weekend project: published and shipped to PowerShell Gallery using Claude Code! 

If you've ever migrated file shares to SharePoint Online, with the SharePoint Migration Tool (SPMT), you know the pain and feeling of your stomach dropping when you see hundreds of INVALID_SHAREPOINT_NAME warnings for your files after your initial scans.

Repair-SharePointNames fixes them in bulk, driven by SPMT's provided scan logs. It renames flagged items safely (collision handling, deepest-path-first ordering), quarantines lock/temp files rather than deleting them, and writes a proper transaction log of all changes.

The Claude really excelled at finding and resolving 7 major bugs that would eventually bite someone, created a 60-test Pester suite, and established build tests for PowerShell 5.1 and 7.

Install it: Install-Script -Name Repair-SharePointNames
Source & Docs: https://lnkd.in/gNGndTwj

Looking for feedback and issue reports 😁  Let me know what you think!