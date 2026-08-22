-- ===================================================================
-- Sword Carving Days with Bill — database setup
--
-- Run this ONCE, whole, in the Supabase SQL Editor:
--   Supabase dashboard -> SQL Editor -> New query -> paste -> Run
--
-- Safe to re-run: every statement is idempotent.
-- ===================================================================

create extension if not exists pgcrypto;

-- -------------------------------------------------------------------
-- Tables
-- -------------------------------------------------------------------

-- One poll per row. This app uses a single fixed poll id.
create table if not exists polls (
  id          text primary key,
  title       text not null,
  dates       date[] not null default '{}',
  updated_at  timestamptz not null default now()
);

create table if not exists participants (
  id            uuid primary key default gen_random_uuid(),
  poll_id       text not null references polls(id) on delete cascade,
  name          text not null,
  votes         date[] not null default '{}',
  -- Random per-row token, generated client-side and kept in that
  -- browser's localStorage. Gates edits and deletes to the row's creator.
  editor_token  uuid not null,
  created_at    timestamptz not null default now()
);

create index if not exists participants_poll_idx on participants(poll_id);


-- -------------------------------------------------------------------
-- Seed the poll: every Saturday and Sunday from 2026-08-22 through the
-- end of the year (38 dates; the last weekend day of 2026 is Sun Dec 27).
--
-- NOTE: the ON CONFLICT below means this block does nothing if the poll row
-- already exists, so re-running the file will NOT change the date list. To
-- reset the dates on an existing poll, run the UPDATE at the bottom of this
-- file instead.
-- -------------------------------------------------------------------
insert into polls (id, title, dates) values (
  'sword-carving',
  'Sword Carving Days with Bill',
  array[
    '2026-08-22','2026-08-23','2026-08-29','2026-08-30',
    '2026-09-05','2026-09-06','2026-09-12','2026-09-13',
    '2026-09-19','2026-09-20','2026-09-26','2026-09-27',
    '2026-10-03','2026-10-04','2026-10-10','2026-10-11',
    '2026-10-17','2026-10-18','2026-10-24','2026-10-25',
    '2026-10-31','2026-11-01','2026-11-07','2026-11-08',
    '2026-11-14','2026-11-15','2026-11-21','2026-11-22',
    '2026-11-28','2026-11-29','2026-12-05','2026-12-06',
    '2026-12-12','2026-12-13','2026-12-19','2026-12-20',
    '2026-12-26','2026-12-27'
  ]::date[]
)
on conflict (id) do nothing;


-- -------------------------------------------------------------------
-- Column privileges
--
-- This section is NOT optional, and it is not in the original spec.
--
-- RLS controls which ROWS a caller sees; it cannot hide a COLUMN. With
-- only a "public read participants USING (true)" policy, anyone could
-- request ?select=editor_token and read everyone's edit token, then use
-- it to edit any row. That would make the whole ownership gate
-- decorative. Column-level GRANTs are what actually close it: PostgREST
-- honours them and returns 401/403 if a caller asks for editor_token.
--
-- Also narrows writes so nobody can rename a row, steal a row by
-- rewriting its token, or retitle the poll.
-- -------------------------------------------------------------------

-- participants: readable except for editor_token
revoke select on table participants from anon, authenticated;
grant  select (id, poll_id, name, votes, created_at)
       on table participants to anon, authenticated;

-- participants: insert may set the token (you're creating your own row)
revoke insert on table participants from anon, authenticated;
grant  insert (poll_id, name, votes, editor_token)
       on table participants to anon, authenticated;

-- participants: update may only touch votes — never name or editor_token
revoke update on table participants from anon, authenticated;
grant  update (votes) on table participants to anon, authenticated;

grant delete on table participants to anon, authenticated;

-- polls: readable; only the date list is writable
grant  select on table polls to anon, authenticated;
revoke update on table polls from anon, authenticated;
grant  update (dates, updated_at) on table polls to anon, authenticated;


-- -------------------------------------------------------------------
-- Row Level Security
-- -------------------------------------------------------------------
alter table polls        enable row level security;
alter table participants enable row level security;

drop policy if exists "public read polls"          on polls;
drop policy if exists "public update poll dates"   on polls;
drop policy if exists "public read participants"   on participants;
drop policy if exists "public insert participants" on participants;
drop policy if exists "own row update"             on participants;
drop policy if exists "own row delete"             on participants;

-- Everyone may read.
create policy "public read polls"        on polls        for select using (true);
create policy "public read participants" on participants for select using (true);

-- Anyone may add themselves.
create policy "public insert participants" on participants for insert with check (true);

-- Anyone may add or remove a date option (the group agreed this stays open).
create policy "public update poll dates" on polls for update using (true) with check (true);

-- Edits and deletes require the caller to present the row's editor_token.
-- PostgREST exposes request headers to policies; the client sends the token
-- as `x-editor-token`. The WITH CHECK half stops a caller rewriting the
-- token to seize the row (belt and braces — the column grant above already
-- blocks writing that column).
create policy "own row update" on participants for update
  using       (editor_token::text = current_setting('request.headers', true)::json->>'x-editor-token')
  with check  (editor_token::text = current_setting('request.headers', true)::json->>'x-editor-token');

create policy "own row delete" on participants for delete
  using       (editor_token::text = current_setting('request.headers', true)::json->>'x-editor-token');


-- -------------------------------------------------------------------
-- Fallback write path (used when CONFIG.USE_RPC = true in index.html)
--
-- The policies above depend on a custom `x-editor-token` request header
-- surviving the browser's CORS preflight. If it doesn't in practice, flip
-- USE_RPC to true and the app calls these functions instead, passing the
-- token as a normal argument. Same rule enforced, no custom header.
--
-- SECURITY DEFINER means the function body runs as its owner and so
-- bypasses RLS — the token check inside the function IS the gate, which
-- is why each one filters on editor_token explicitly. search_path is
-- pinned so the body can't be redirected at a shadowed table.
-- -------------------------------------------------------------------

create or replace function public.set_votes(p_id uuid, p_token uuid, p_votes date[])
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare changed int;
begin
  update participants
     set votes = p_votes
   where id = p_id
     and editor_token = p_token;
  get diagnostics changed = row_count;
  return changed > 0;
end;
$$;

create or replace function public.remove_participant(p_id uuid, p_token uuid)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare changed int;
begin
  delete from participants
   where id = p_id
     and editor_token = p_token;
  get diagnostics changed = row_count;
  return changed > 0;
end;
$$;

revoke execute on function public.set_votes(uuid, uuid, date[])   from public;
revoke execute on function public.remove_participant(uuid, uuid)  from public;
grant  execute on function public.set_votes(uuid, uuid, date[])   to anon, authenticated;
grant  execute on function public.remove_participant(uuid, uuid)  to anon, authenticated;


-- -------------------------------------------------------------------
-- Handy maintenance queries (not run automatically)
-- -------------------------------------------------------------------

-- Reset the poll — wipes every vote, keeps the dates:
--   delete from participants where poll_id = 'sword-carving';

-- Reset the DATE LIST on a poll that already exists (the seed above is
-- skipped once the row is there). Paste the same array as above:
--   update polls set dates = array[
--     '2026-08-22', ... '2026-12-27'
--   ]::date[] where id = 'sword-carving';

-- See the current tally:
--   select d as date, count(*) filter (where d = any(p.votes)) as votes
--   from polls, unnest(polls.dates) d
--   left join participants p on p.poll_id = polls.id
--   where polls.id = 'sword-carving'
--   group by d order by votes desc, d;

-- Confirm editor_token is NOT readable by the public role (should error):
--   set role anon; select editor_token from participants limit 1; reset role;
