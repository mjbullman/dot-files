---
name: daily-summary
description: Use when the user wants to summarise or close out their day — "summarise my day", "daily summary", "end of day review", "wrap up the day", "what did I get done today".
---

# daily-summary — write a Day Summary into today's daily note

Collect what happened today from four sources, write a `## Day Summary` section into today's daily note, and echo it in chat. Sources that are empty or unreachable are skipped with a one-line note — never block the rest.

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

**YouTrack team movement** — the harness shell doesn't load `~/.zshrc`, so source the secrets file first. Non-200 or unset vars → skip the section and say why:

```bash
source ~/.zsh_secrets  # YOUTRACK_URL + YOUTRACK_TOKEN
curl -sf -H "Authorization: Bearer $YOUTRACK_TOKEN" -H "Accept: application/json" \
  "$YOUTRACK_URL/api/issues?query=updated:%20Today&fields=idReadable,summary,customFields(name,value(name))&\$top=30"
```

Per issue pull `State` and `Assignee` from `customFields` (each `value` may be null — guard). Weekends legitimately return 0 issues.

## 3. Write the section

Append to today's daily note (Edit tool). If a `## Day Summary` section already exists, replace it — the one exception to append-only, scoped to this skill's own section. One line per bullet, no hard wraps.

```markdown
## Day Summary

**Done:** Things completions grouped by project/area, one bullet each.
**YouTrack:** `DEV-XXXX moved to <State> (<assignee>) — <summary>`; resolved issues first.
**Notes:** touched-folder clusters, e.g. `[[Project Brief]] +2 others in 🧾 Yester - Expenses & Business Trips`.
**Still open:** unchecked Follow-ups and remaining Today tasks — the honest carry-over list.
```

Echo the same summary in chat and report the note path written.

## Common mistakes

| Mistake | Fix |
|---|---|
| Raw file list under **Notes** | Cluster by folder — iCloud touches mtimes of files nobody edited |
| Empty YouTrack treated as failure | 200 + `[]` is a real answer (weekends); only skip on non-200/unset vars |
| Appending a second Day Summary | Replace the existing section on rerun |
| Forgetting `source ~/.zsh_secrets` | Env vars are not in the harness shell by default |
| Summarising from conversation memory | Collect from the four sources — the note must reflect the systems, not the chat |
