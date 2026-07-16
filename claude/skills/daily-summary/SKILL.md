---
name: daily-summary
description: Use when the user wants to summarise or close out their day — "summarise my day", "daily summary", "end of day review", "wrap up the day", "what did I get done today".
---

# daily-summary — write a Daily Summary into today's daily note

Collect what happened today from four sources, write a `## Daily Summary` section into today's daily note, and echo it in chat. Sources that are empty or unreachable are skipped with a one-line note — never block the rest.

## 1. The vault root

```bash
VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/The Nexus"
[ -d "$VAULT/10 - Projects" ] || echo "MISSING"  # stop if MISSING — vault not synced
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

The section is four bold labels — `**Done:**`, `**YouTrack:**`, `**Notes:**`, `**Still open:**` — each on its own line with a Markdown bullet list beneath it. One `-` bullet per item. Never inline prose or semicolon-joined runs. Rules per section:
- **Done** — one bullet per Things completion. Lead with the project/area name (keep its emoji), then `— <what was done>`.
- **YouTrack** — `DEV-XXXX <State> (<full assignee name>) — <summary>`. Use the full name, not a first name. Append `, Bug` / `, Epic` after the state when the Type is notable. Order resolved/Done first, then Code Review, In Progress, Open.
- **Notes** — cluster by folder. A cluster of N gets one bullet with a `— N notes (…)` count; a lone note gets a plain wiki-link bullet. Use `[[note|display]]` when the display label differs from the filename. Never a raw file list.
- **Still open** — reproduce as `- [ ]` checkboxes: unchecked Follow-ups plus remaining Today tasks. Lead each with its area, then `— <task>`.

Echo the same summary in chat and report the note path written.
