---
name: things
description: Use when the user wants to add, list, complete, reschedule, move, cancel, or delete tasks or projects in Things 3, or asks "what's on today/upcoming", "add a task", "mark X done", "create a todo". Also use when a captured item turns out to be a task rather than a note.
---

# things — manage tasks in Things 3

Things 3 owns action, Obsidian owns context, YouTrack owns engineering. This skill keeps
those boundaries intact while doing full CRUD on Things via AppleScript (`osascript`).
Never use the `things:///` URL scheme — updates need an auth token and it pops the app UI.

## 1. Route first: YouTrack or Things?

Gate every create before any AppleScript runs:

- **Executed in a repo, IDE, or sprint** (bug fix, feature, code review, deploy,
  migration, ticket-shaped Yester engineering work) → **YouTrack owns it.** Do not create
  it in Things. Tell the user it belongs in YouTrack and stop — this skill has no YouTrack
  access, and double-entry is the failure mode.
- **Exception — Arthur:** Martin's personal project, no YouTrack board. Arthur dev tasks
  go to Things (`🚀 Arthur - AI Assistant`).
- **Personal or CTO-organizational work** (expenses, hiring admin, schedules, property,
  subscriptions) → Things, even when Yester-related.
- **Ambiguous** → ask one question: "YouTrack ticket or Things task?"

## 2. Lean task format

A task is: **title + at most one note line holding an `obsidian://` deep link** to the
source note. Step lists, acceptance criteria, and context never go in task notes — that
detail lives in Obsidian (use the capture skill, then link it). Never put `things:///`
links into vault notes; linking is one-direction, task → note.

Deep link (URL-encode spaces `%20` and emoji, drop the `.md`):
`obsidian://open?vault=The%20Nexus&file=10%20-%20Projects%2F<encoded folder>%2F<encoded note>`

### Title format

A title is: **`[Verb] [specific object] [done-condition]`** — on its own it
answers "what does done look like". `Email Hendrik to push for roadmap update`
qualifies; `Weekly Review`-style nouns only qualify as repeating rituals.

- **No project-name prefix.** Placement in the Things project already encodes the project,
  so a `[Project] -` prefix is redundant — don't add one.
- One task = one action. A fused title (`X / Y`, `X and Y`) becomes two tasks; a
  destructive action gets its own task naming the target environment.
- A bug is titled `Fix: <symptom>`.
- A goal with no startable action (`Develop plan to…`) is a Things **project** with a
  concrete first task, per the mirror rule below.
- Spell correctly — search is how tasks get found again.

Martin captures fast and messy by design: the open loop matters more than the format.
Apply this format when creating or renaming tasks yourself; clean up his captured titles
in review passes, proposing each rename one at a time with a before/after preview.

## 3. Placement — the mirror rule

Things Areas/Projects mirror the vault's `20 - Areas/` and `10 - Projects/` 1:1. Projects
carry a single emoji prefix (`🚀 Arthur - AI Assistant`); areas are plain (`Yester - People`).
Still match on the `Yester - X` / `Personal - X` core, never the exact string — emoji drift
happens.

- List first: `get name of projects` and `get name of areas`.
- Task fits an existing project or area → add there. No match → Inbox, and say so.
- New project only if a matching folder exists in the vault's `10 - Projects/` — copy the
  name exactly, emoji included. No vault counterpart → flag the drift instead of creating.

## 4. AppleScript reference

Always heredoc (`osascript <<'EOF' … EOF`) — it survives quotes and emoji.

| Operation | Snippet (inside `tell application "Things3"`) |
|---|---|
| Read a list | `get name of to dos of list "Today"` (`Inbox`, `Today`, `Upcoming`, `Anytime`, `Someday`, `Logbook`) |
| Read a project | `get name of to dos of project "🚀 Arthur - AI Assistant"` |
| Add task | `tell project "X" to make new to do with properties {name:"…", notes:"obsidian://…", tag names:"High"}` — `tag names` per §5, omit when none apply |
| Add project | `make new project with properties {name:"…", notes:"obsidian://…"}` |
| Find task | `first to do of project "X" whose name contains "…"` — errors (−1719) when nothing matches, so trap or pre-check |
| Rename | `set name of theTask to "…"` |
| Move | `move theTask to project "Y"` |
| Schedule | `schedule theTask for (current date) + 2 * days` |
| Deadline | `set due date of theTask to (current date) + 7 * days` |
| Tag | `set tag names of theTask to "High"` — comma-separated string, replaces all existing tags |
| Complete | `set status of theTask to completed` |
| Cancel | `set status of theTask to canceled` |
| Delete | `delete theTask` (moves to Trash) |

Date literals use `date "21 July 2026"` format.

## 5. Tags

Tags cut across projects — they filter along axes placement can't encode, so keep them few. Read the live list with `get name of tags` and reuse exactly; never invent one, and if the user names a tag outside the list, confirm before creating it. Current vocabulary, by axis:

- **Priority** — `High` / `Medium` / `Low`, nested under the `Priority` group.
- **Status** — `Pending`: delegated or blocked on someone else.
- **Context** — `Home` (plus any other context tag the live list shows).

Apply at creation time (in the `make new to do` properties), keyed to the request:

- User states priority or an ordering ("1 2 3", "in order of priority", "most important first") → `High` for the top item, `Low` for anything explicitly deprioritised, `Medium` for the rest.
- User delegates it, or it's blocked on someone else → `Pending`.
- Task is doable only in a given place or mode → the matching context tag (e.g. `Home`).
- No such signal → no tags. Placement already encodes the project and sphere — never tag by project or sphere (no `Yester`, `Personal`, `Arthur`).

## 6. Confirmation rules

- Create, read, and complete-when-asked: just do it, report the result.
- Cancel, delete, rename, or anything touching more than one task: list what will change
  and confirm first.

## Common mistakes

| Mistake | Fix |
|---|---|
| Detail-stuffed task notes | Title + deep link only; detail → Obsidian |
| Vague, fused, or symptom-only titles | Apply the Title format: `[Verb] [object] [done-condition]` (no project-name prefix), one action per task |
| Exact-matching project/area names | Emoji placement varies — match the `Yester - X` / `Personal - X` core |
| `things:///` URL scheme for writes | AppleScript only |
| Creating engineering tasks in Things | YouTrack owns those — refuse and point there |
| `things:///` links inside vault notes | One-direction linking: task → note only |
| Creating Things projects with no vault twin | Mirror rule — flag drift, don't create |
| Bare tasks when the request states priority/order or a context | Tag at creation per §5 — don't wait to be asked |
| Inventing new tags or tagging by project name | Reuse the existing vocabulary; placement already encodes project |
