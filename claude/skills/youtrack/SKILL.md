---
name: youtrack
description: YouTrack issue tracker assistant for your YouTrack instance — ad-hoc operations on issues. Use this skill whenever the user mentions issues, tickets, bugs, features, tasks, sprints, backlogs, or YouTrack. Also trigger when the user references an issue ID (e.g. DEV-123), asks "what's in my sprint", "create a ticket", "log a bug", "update issue status", "assign this to someone", "what are my tasks", "comment on this issue", or wants to search, create, update, comment on, or track any YouTrack issue. Trigger even if the user doesn't say "YouTrack" explicitly — context like "open tickets", "current sprint", "backlog items" is enough. For shaping a pitch or feature into an epic with sliced child tasks, hand off to the shape-to-tasks skill instead.
---

# YouTrack — ad-hoc operations

Operate YouTrack via the `youtrack` MCP server (`mcp__youtrack__*` tools). The instance
base URL is `$YOUTRACK_URL` in `~/.zsh_secrets` — resolve it (`source ~/.zsh_secrets`) only
when you need to build issue links; the MCP server already knows the instance and token.
This skill covers day-to-day operations: search, read, comment,
update, move, quick creates. **Shaping a bet into an epic + sliced child tasks is not this
skill's job** — that's the `shape-to-tasks` skill; hand off when the user wants a feature
broken down. **Also hand off when the user asks to review/clean up existing tickets or an
epic's child tasks** ("clean these up", "make this clear for devs") — shape-to-tasks defines
the full description template (incl. Out of Scope and Self-Test Checklist) and the cleanup
recipe: restructure each issue to the complete template in one update, all siblings in one
batch — not section-by-section fixes across many turns.

## Conventions

- Default project **DEV** (Development). Others: INTEGRATIONS, MODULES, OVERALL, ESTIKO, FUT, SG, SGM.
- Task types: Bug, Task, Epic, Test · Priorities: Low, Medium, High, Critical
- Issue titles: module or integration name first, then a brief description, each word
  capitalised — `<Module/Integration Name> - <Brief Description>`, e.g.
  `Assets Module - Feature Improvements`, `Merit Palk Integration - Sync Failure Fix`.
  Applies to every issue type (Epic, Task, Bug). The description part says **what the work
  delivers**, not where it came from — `Assets Module - Assignment Withdrawal & UI
  Improvements`, never `Assets Module - Stakeholder Feedback Improvements`.
- Board columns: Open → In Progress → Code Review → DEV Testing → UAT Testing → Ready for Live → Done
- Branch naming (when linking code to issues): `DEV-XXXX-short-kebab-case-description`

## Tool names — exact

The MCP surface uses these names; near-misses fail at call time:

- Comment → `add_issue_comment` (not `add_comment`)
- Projects → `find_projects` (not `get_projects`)
- Assignee → `change_issue_assignee` (dedicated tool; don't route through `update_issue`)
- Everything else: `search_issues`, `get_issue`, `create_issue`, `update_issue`,
  `link_issues`, `log_work`, `manage_issue_tags`, `get_issue_fields_schema`

## Search

Build YouTrack query-language strings from natural language:

- `for: me` — assigned to current user · `project: DEV` — by project
- `#Unresolved` — open only · `Sprint: {Current sprint}` — current sprint
- `Priority: Critical` — by priority · `type: Bug` — by type

Examples: "my open issues" → `for: me #Unresolved` · "bugs in current sprint" →
`type: Bug Sprint: {Current sprint}` · "what's blocking release" →
`Priority: Critical #Unresolved`

## Create an issue (quick, ad-hoc)

For a straightforward task or bug the user describes directly:

1. Call `get_issue_fields_schema` for the target project first — projects have custom
   required fields; skipping this wastes a failed attempt.
2. Write the description in the house format (below).
3. `create_issue`, then return the ID and link.

If the request is really a feature needing breakdown (multiple areas of work, needs codebase
analysis, "build X"), stop and use `shape-to-tasks` instead — quick-creating an unshaped
feature produces exactly the vague tickets the format exists to prevent.

### House description format (Tasks and Bugs)

This structure is for **Task and Bug** descriptions — the colored headings are how the team
scans tickets on the board. **Epics use a different, deliberately thin template** (Problem /
checkable Objective / Decisions Made During Shaping / Out of Scope — no Requirements table,
no child-task table): see the shape-to-tasks skill for it before writing or rewriting any
Epic description.

```
#### <span style="color:red;">**Problem**</span>
[Context — what is broken or missing, why it matters, relevant background]

#### <span style="color:darkorange;">**Objective**</span>
[The outcome — clear, specific, developer-ready]

#### <span style="color:green;">**Scope**</span>

### Requirements
| # | Requirement | Status |
| --- | --- | --- |
| R0 | ... | Open |

### [Section name]
[Work detail — one ### subheading per area, bullets within]
```

`####` + inline `<span style="color:...">` for the three top headings only; `###` for
subsections inside Scope; the Requirements table sits first under Scope so requirements are
visible in the ticket itself. Leave an empty line of space before each `###` subsection
under Scope (every one after the first): markdown collapses plain blank lines, so render the
gap with a line containing only `&nbsp;`, surrounded by blank lines — never a `---` rule.

**Requirements are atomic: one outcome per row**, in plain simple English — never bundle
several changes into one row with commas or "and"; prefer seven small rows over three dense
ones. **No narrative or history in descriptions** ("consolidated from…", "feedback scattered
across…"), and **never write old/closed issue IDs in description text** — every ID becomes a
"mentioned here" link that clutters the issue. Refer to related sub-tasks by title, not ID.

Durable context belongs in the **description**, not in comments: source material (feedback
videos, recordings, docs) is linked under the Problem statement, and scoping/drop decisions
live in the description body. Comments are for conversation, not for record-keeping — and
note the MCP server cannot delete comments, so a misplaced one needs manual cleanup.

## Print-first — every description write

Before any `create_issue` or any `update_issue` that touches a description: **print the
complete final description in chat and wait for an explicit go** (yes / go / update it).
Always the **full final text, never a diff or changed-rows-only summary** — a diff reads as
if the unlisted content is gone, and Martin verifies the whole ticket before it lands.
Field-only updates (status, priority, assignee) don't need the gate.

## Update, comment, link, log

- **Update** — `update_issue` for status, priority, type, fix version, custom fields. Map
  natural phrasing ("mark it done", "bump to critical") to the right field. Assignee changes
  go through `change_issue_assignee`.
- **Comment** — `add_issue_comment`. Concise and useful; for code-change comments include
  what changed and why.
- **Link** — `link_issues` for relates-to, duplicates, blocked-by, subtask-of.
- **Log work** — `log_work`, ISO 8601 duration (`PT1H30M` = 1.5h). Ask for duration if not
  given.
- **Failed update (missing required field)** — call `get_issue_fields_schema`, ask the user
  for the missing value, retry.
- **Requirements changed on an In Progress issue** — right after the update, draft a
  one-line heads-up comment for the assignee (what changed + why) and offer it to Martin for
  approval; post only on his go.

## Presenting results

- Issue IDs as links: `[DEV-123]($YOUTRACK_URL/issue/DEV-123)` — resolve `$YOUTRACK_URL` from `~/.zsh_secrets`
- Lists → table or compact bullets, never raw JSON
- Single issue → ID, summary, status, assignee, priority, description (truncate if long)
- Sprint overview → search `Sprint: {Current sprint}`, group by state with counts
- After any write, confirm with ID + direct link

## Tips

- When a ticket edit hinges on an ambiguous requirement or conflicting sources, ask Martin a
  concrete either/or question (with a recommendation) before writing — he wants questions
  that force a rethink, not specs written around uncertainty
- Vague request ("what's going on") → default to the user's open assigned issues in the
  current sprint
- Project unspecified and ambiguous → ask, don't guess (DEV is only a default, not a rule)
- Unsure which project exists → `find_projects`
