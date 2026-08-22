# Sword Carving Days with Bill — setup

A no-login group availability poll. Anyone with the link can add themselves,
tick the dates they can make, and see everyone else's picks. Live at:

**https://corymf.com/sword/**

## Where the pieces live

| File | Purpose |
|---|---|
| `static/sword/index.html` | The entire app — markup, styles, script. Hugo copies `static/` to the site verbatim, so this file is published untouched at `/sword/`. |
| `sword-poll/schema.sql` | Database setup. Paste into the Supabase SQL editor once. |
| `sword-poll/README.md` | This file. Not published — Hugo ignores unknown top-level folders. |

There is no build step and no dependencies. `index.html` is plain HTML, CSS,
and vanilla JS, and it talks to the database over `fetch`.

---

## What Supabase is, and why there is a database at all

GitHub Pages only serves files — it can't remember anything. For Bill to see
Cory's votes, they have to be stored somewhere both browsers can reach.

[Supabase](https://supabase.com) is a free hosted Postgres database that
automatically exposes your tables as a REST API you can call straight from
browser JavaScript. No server to run, no backend to write. Its free tier is far
more than this poll will ever need.

**About the "anon" key:** Supabase issues a public key that is *designed* to
ship in client-side JavaScript and be committed to a public repo. It is not a
secret. What protects the data is Row Level Security — the policies in
`schema.sql` — not hiding the key.

> **Never put the `service_role` key in this repo.** That one *is* secret and
> bypasses every policy. You want the key labelled **anon** / **public**.

---

## Setup — about ten minutes, once

### 1. Create the Supabase project

1. Sign up at [supabase.com](https://supabase.com) (free, GitHub login works).
2. **New project.** Name it whatever you like. Pick the **West US** region.
3. It sets a database password — save it in your password manager. You won't
   need it for this app, but you'll want it if you ever connect directly.
4. Wait ~2 minutes for provisioning.

### 2. Create the tables

1. Left sidebar → **SQL Editor** → **New query**.
2. Paste the entire contents of `sword-poll/schema.sql`.
3. **Run.** You should get "Success. No rows returned."

### 3. Copy your two values into the app

1. Left sidebar → **Project Settings** (gear) → **API**.
2. Copy **Project URL** — looks like `https://abcdefgh.supabase.co`.
3. Copy the **anon** / **public** key — a long string starting `eyJ...`.
4. Open `static/sword/index.html`, find the `CONFIG` block near the top of the
   `<script>`, and replace both placeholders:

```js
var CONFIG = {
  SUPABASE_URL:      'https://abcdefgh.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGciOi...',
  POLL_ID:           'sword-carving',
  ...
```

Until you do this the page loads but shows a banner saying it isn't connected —
that's expected, not a bug.

### 4. Deploy

```
git add static/sword/index.html sword-poll/
git commit -m "Add sword carving availability poll"
git push
```

Your existing GitHub Actions workflow builds and publishes the site. Give it a
minute, then open **https://corymf.com/sword/**.

### 5. Verify it actually works

Do this in a **private/incognito window**. That is the real test — it proves a
stranger with no session and no account can vote. Walk the checklist at the
bottom of this file.

---

## If writes fail with a CORS error

Editing and deleting send the edit token in a custom `x-editor-token` request
header, which the RLS policy reads. That requires the header to survive the
browser's CORS preflight.

If you see a console error naming `x-editor-token` — reading works but ticking a
box fails — flip one line in `CONFIG`:

```js
USE_RPC: true,
```

The app then calls the `set_votes` / `remove_participant` SQL functions instead,
passing the token as a normal argument. Same rule enforced, no custom header.
`schema.sql` already created both paths, so this is a one-word change and a push.

---

## How ownership works, honestly

There are no accounts, so there is no identity to verify. When you add yourself,
your browser generates a random token, stores it in `localStorage`, and saves a
copy on your row. Editing that row requires presenting the token.

What that gets you:

- Nobody can change your picks through the UI or the API.
- Your edit rights survive a page reload, and closing the browser.

What it does not get you:

- **Clear your browser data and you lose the ability to edit that row.** You can
  always add yourself again as a new row; ask Cory to delete the orphan.
- Anyone can still add or remove *dates* — that's deliberate, the group agreed.
- Anyone can add a row under any name. It's a friends-and-family poll.

The database never sends `editor_token` back to browsers (`schema.sql` revokes
read access on that one column), so tokens can't be harvested from the API.

---

## Running the poll

**Reset all votes, keep the dates** — SQL Editor:

```sql
delete from participants where poll_id = 'sword-carving';
```

**See the tally** — SQL Editor:

```sql
select d as date, count(*) filter (where d = any(p.votes)) as votes
from polls, unnest(polls.dates) d
left join participants p on p.poll_id = polls.id
where polls.id = 'sword-carving'
group by d order by votes desc, d;
```

**Delete somebody's orphaned row** — Table Editor → `participants` → delete the
row. (The dashboard uses the service role, so it isn't bound by the policies.)

**Change the date list wholesale** — easiest in the app itself, or:

```sql
update polls set dates = array['2027-01-09','2027-01-10']::date[]
where id = 'sword-carving';
```

**Prefill someone's name** — send them
`https://corymf.com/sword/?name=Bill`.

---

## Acceptance checklist

Run every one of these against the live URL, not a local file.

- [ ] A private/incognito window with no session can add a name and vote.
- [ ] Two different browsers see each other's votes within ~15 seconds.
- [ ] A vote survives a hard reload.
- [ ] Checkboxes on someone else's row are disabled.
- [ ] The remove `×` appears only on your own row, and removing works.
- [ ] Adding a date inserts chronologically and backfills every existing row.
- [ ] Removing a date drops it from the header, footer, and all rows.
- [ ] Date labels show the correct weekday — `Aug 22` must read **SAT**.
- [ ] Turn off wifi, tick a box: a visible error with an HTTP status appears
      and a **Retry** button works once you reconnect. Not a silent no-op.
- [ ] Legible in both light and dark mode (OS appearance setting).
- [ ] No sideways scrolling of the page body on a phone — only the grid
      scrolls horizontally, inside its own box.
