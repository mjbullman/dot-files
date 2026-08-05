---
name: daily-summary
description: Use when the user wants to summarise or close out their day — "summarise my day", "daily summary", "end of day review", "wrap up the day", "what did I get done today".
---

# daily-summary — write a Daily Summary into today's daily note

Collect what happened today from four sources, write a `## Daily Summary` section into today's daily note, and echo it in chat. Sources that are empty or unreachable are skipped with a one-line note — never block the rest.

## 1. The vault root

```bash
source ~/.zsh_secrets 2>/dev/null; VAULT="$NEXUS_VAULT"
[ -d "$VAULT/10 - Projects" ] || echo "MISSING"
```

## 2. Collect

**Daily note** — Read `"$VAULT/00 - Inbox/$(date +%Y-%m-%d).md"`: `## Capture` bullets and `## Follow-ups` checkbox states. Missing → create it from the `Daily Note` template first (as the capture skill does).

**Things 3** — completed today and still-open Today (always heredoc):

```applescript
tell application "Things3"
	set startOfDay to current date
	set time of startOfDay to 0
	set doneToday to to dos of list "Logbook" whose completion date ≥ startOfDay
	-- per item: name, plus project/area name via try blocks (both can be missing value)
	get name of to dos of list "Today" -- still open
end tell
```

**Vault notes touched today** — iCloud sync inflates mtimes, so cluster hits by folder and report clusters, never a raw file list:

```bash
find "$VAULT" -name '*.md' -newermt "$(date +%Y-%m-%d)" \
  -not -path '*/Chat History/*' -not -path '*/Chat Summaries/*' -not -name 'CLAUDE.md' 2>/dev/null
```

**YouTrack team movement** — the harness shell doesn't load `~/.zshrc`, so source the secrets file first. Strip any trailing slash from the URL with `${YOUTRACK_URL%/}` — a trailing slash makes `//api/issues`, which YouTrack answers with the SPA **HTML at HTTP 200** (so `curl -sf` won't catch it). Unset vars, non-200, or a non-JSON body → skip the section and say why:

```bash
source ~/.zsh_secrets  # YOUTRACK_URL + YOUTRACK_TOKEN
BASE="${YOUTRACK_URL%/}"  # tolerate a trailing slash in the config
resp=$(curl -sf -H "Authorization: Bearer $YOUTRACK_TOKEN" -H "Accept: application/json" \
  "$BASE/api/issues?query=updated:%20Today&fields=idReadable,summary,customFields(name,value(name))&\$top=30")
case "$resp" in
  \[*) echo "$resp" ;;                                   # JSON array — good
  *)   echo "SKIP: YouTrack returned non-JSON (check YOUTRACK_URL/token)" ;;
esac
```

Per issue pull `State` and `Assignee` from `customFields` (each `value` may be null — guard). Weekends legitimately return 0 issues (a `[]` body is a real answer, not a failure).

## 3. Write the section

Append to today's daily note (Edit tool). If a `## Daily Summary` section already exists, replace it — the one exception to append-only, scoped to this skill's own section.

The section is a scannable, grouped digest — not four flat lists. Use `###` sub-headings (the section title stays `## Daily Summary`). One `-` bullet per item; never inline prose or semicolon-joined runs. Order and content:

**Open with a native `> [!success] Overview` callout** (green) — the title on the `[!success]` line, then the body on `> `-prefixed lines: one or two sentences on the shape of the day (how many shipped, the dominant theme, the live threads). Use native callouts, NOT the Admonition plugin's ` ```ad-* ` fences — Admonition blocks render with an ugly gap between title and content; native callouts render as one cohesive box and pick up the `callout-solid-fix` snippet styling. No heading, no bold label.

**A native `> [!danger] Needs My Attention` callout** (red) — the title on the `[!danger]` line, then the bullets as `> `-prefixed `-` items. This is the analytical layer, and the point of the summary. 3–6 bullets synthesised across all sources: data-integrity or security bugs, responses owed (tickets/messages "sent to you"), the user's own In Progress work, items captured but never turned into tickets, and stale personal/admin items (weekly review, time-sensitive personal tasks). Lead each bullet with a **bold** subject, then the why/action. This is judgement, not a data dump — surface what matters, skip the rest.

**`### Done Today`** — two labelled blocks:
- `**Things (<context>):**` — one bullet per Things completion, each a short past-tense phrase.
- `**YouTrack shipped (<N> Done):**` — group the Done issues under *italic* sub-labels by module/theme, and where one person owns a cluster name them in the label, e.g. `*Business Trips & Expenses (Herbert-Ken Ymera):*`. Within a group, one bullet per issue as `DEV-XXXX — <summary>` (state is implied by the group; append `, Bug` / `, Epic` after the id when the Type is notable). Use full names, never first-name-only.

**`### In Flight`** — `**Code Review:**` then `**In Progress:**` blocks. Each bullet `DEV-XXXX (<full assignee name>) — <summary>`. Put the user's own issues first within each block.

**`### Open / Backlog`** — remaining Open issues grouped under **bold** module labels (Business Trips, Job Families & Occupational Groups, Bugs, …). Each bullet `DEV-XXXX, <Type if notable> (<full assignee name>) — <summary>`.

**`### Notes`** — cluster by folder. A cluster of N gets one bullet with a `— N notes (…)` count; a lone note gets a plain wiki-link bullet. Use `[[note|display]]` when the display label differs from the filename. Never a raw file list.

**`### Still Open (my tasks)`** — `- [ ]` checkboxes (unchecked Follow-ups plus remaining Today tasks), grouped under **bold** area labels (Sprint 66, Expenses & Business Trips, Work Schedules, Infrastructure, Personal, …). Keep each area's emoji where the Things project/area carries one.

Echo the same digest in chat (including the `⚠ Needs My Attention` points) and report the note path written.
