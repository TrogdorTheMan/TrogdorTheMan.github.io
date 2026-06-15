---
title: "AI Let Me Chase a Fake Bug for a Day"
date: 2026-06-12
draft: false
tags: ["PowerShell", "SharePoint", "AI", "Debugging"]
description: "Claude was convinced it was SharePoint replication lag. It wasn't. It was a threading problem, and I should have caught it sooner."
---

AI-assisted development is genuinely useful. It's also very good at helping you waste a day on a wrong answer.

While working on [SP-MembershipManager](/projects/sp-membership-manager/), I kept running into inconsistent results when querying a user's SharePoint site access. One run would return 19 sites. The next would return 8. Then 20. Then 12. No pattern, no obvious error — just noise.

I asked Claude what was going on. It was confident: SharePoint replication lag. Data takes time to propagate across the service, results can be inconsistent during that window, etc. It sounded plausible. The whole point of this tool is to give non-technical users a reliable view of their permissions, so I really didn't want it to be true, but it *sounded* true.

So I spent a day chasing it. Retries, delays, caching strategies — none of it helped, and the results stayed random.

Eventually I stepped back and did what I should have done earlier: made sure the tool could actually surface its own errors. Once I did that, the problem was obvious. It was a threading issue. The tool was running too fast, tripping over itself, and cannibalizing its own error log in the process. The inconsistent results weren't from SharePoint at all — they were from the tool eating its own output under load.

One line fix.

The lesson I walked away with: AI will chase a good-sounding theory indefinitely. It won't get bored, it won't second-guess itself, and it'll keep generating plausible-looking explanations until you stop asking. That's useful when the theory is right. When it's wrong, you're just burning time with a very confident co-pilot.

We're still smarter than these models. They need us more than we need them — specifically, they need us to know when to stop listening and go look at the actual error.

Also: switched the license to GPLv3. If I'm using AI on a personal project, I'd rather make sure it stays open source permanently.

[View the repo on GitHub](https://github.com/TrogdorTheMan/SP-MembershipManager)
