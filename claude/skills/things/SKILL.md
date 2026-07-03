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

## 3. Placement — the mirror rule

Things Areas/Projects mirror the vault's `20 - Areas/` and `10 - Projects/` 1:1. Things
names carry emoji prefixes (`🚀 Arthur - AI Assistant`), so match on the
`Yester - X` / `Personal - X` suffix, never exact string.

- List projects first: `osascript -e 'tell application "Things3" to get name of projects'`
- Task fits an existing project → add there. No match → Inbox, and say so.
- New project only if a matching folder exists in the vault's `10 - Projects/` — copy the
  name exactly, emoji included. No vault counterpart → flag the drift instead of creating.

## 4. AppleScript reference

Always heredoc (`osascript <<'EOF' … EOF`) — it survives quotes and emoji.

| Operation | Snippet (inside `tell application "Things3"`) |
|---|---|
| Read a list | `get name of to dos of list "Today"` (`Inbox`, `Today`, `Upcoming`, `Anytime`, `Someday`, `Logbook`) |
| Read a project | `get name of to dos of project "🚀 Arthur - AI Assistant"` |
| Add task | `tell project "X" to make new to do with properties {name:"…", notes:"obsidian://…"}` |
| Add project | `make new project with properties {name:"…", notes:"obsidian://…"}` |
| Find task | `first to do of project "X" whose name contains "…"` |
| Move | `move theTask to project "Y"` |
| Schedule | `schedule theTask for (current date) + 2 * days` |
| Deadline | `set due date of theTask to date "3 July 2026"` |
| Complete | `set status of theTask to completed` |
| Cancel | `set status of theTask to canceled` |
| Delete | `delete theTask` (moves to Trash) |

## 5. Confirmation rules

- Create, read, and complete-when-asked: just do it, report the result.
- Cancel, delete, rename, or anything touching more than one task: list what will change
  and confirm first.

## Common mistakes

| Mistake | Fix |
|---|---|
| Detail-stuffed task notes | Title + deep link only; detail → Obsidian |
| Exact-matching project names | Emoji prefixes vary — match the name suffix |
| `things:///` URL scheme for writes | AppleScript only |
| Creating engineering tasks in Things | YouTrack owns those — refuse and point there |
| `things:///` links inside vault notes | One-direction linking: task → note only |
| Creating Things projects with no vault twin | Mirror rule — flag drift, don't create |
