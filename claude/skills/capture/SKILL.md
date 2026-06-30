---
name: capture
description: Use when the user wants to save, capture, jot, log, or add a note to their Obsidian second-brain vault — "capture this", "save this note", "add to my vault/second brain", "log this", "write this up as a resource/runbook/spec". Routes the note to the right PARA folder following the vault's conventions.
---

# capture — add a note to the second-brain vault

Save new knowledge into the user's local PARA Obsidian vault without breaking its
conventions. Route the note, confirm the target before writing, and ask when unsure rather
than guess. **Only ever add** — never delete or overwrite an existing note.

Read and write the vault files directly, not via the Obsidian MCP; Obsidian reindexes
external writes automatically. Use Read for templates/notes, Write for new notes, Edit to
insert into a daily-note section. If the vault isn't on disk, say "I can't find your Obsidian
vault on this machine — make sure it's synced locally, then try again" and stop — don't skip
writing.

## 1. Resolve the vault root

Find it once, reuse as `VAULT` (the directory *containing* `10 - Projects`):

```bash
for d in ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/*/; do
  [ -d "$d/10 - Projects" ] && echo "$d" && break
done
# Fallback: find ~ -maxdepth 6 -type d -name "10 - Projects" 2>/dev/null | head -1
```

If nothing is found, stop per above.

## 2. Load conventions

Read `"$VAULT/CLAUDE.md"` for the folder layout, tag namespaces (`type/`, `project/`,
`tech/`), and the Things 3 ↔ Obsidian boundary — don't hardcode them. Templates live in
`"$VAULT/30 - Resources/Templates/"` (`Daily Note`, `Resource Note`, `Runbook`,
`Meeting Note`, `Person Note`, `1-1 Note`); when one fits the note type, follow it verbatim.

## 3. Tasks go to Things 3, not a note

If the input is a *task* (something to do, not knowledge to keep), don't create a note. Add
it as a `- [ ]` checkbox under `## Follow-ups` in today's daily note and tell the user it
belongs in Things 3. Mixed content → capture the knowledge below *and* flag the action.

## 4. Route the note — confirm the target before writing

- **Fleeting thought / log** → a bullet under `## Capture` in today's daily note
  `00 - Inbox/YYYY-MM-DD.md`.
- **Task spec / design doc / project note** → a new note in the matching
  `10 - Projects/<project>/`. No template; clear title and headings.
- **Reusable reference** → a new note in the right `30 - Resources/<subfolder>`, using the
  matching template only when one genuinely fits.

When placement is ambiguous, list candidates and ask — don't guess:
`ls -d "$VAULT/10 - Projects"/*/` (or `30 - Resources`, `20 - Areas`).

## 5. Apply conventions and write

Every note gets: front-matter `date` (today, `YYYY-MM-DD`); tags across namespaces
(`type/...` required, plus `project/...` / `tech/...` when relevant); `[[wiki-links]]` to
related notes; a descriptive title. Find notes to link by grepping:
`grep -ril --include='*.md' --exclude-dir='Chat History' --exclude-dir='Chat Summaries' -e 'TERM' "$VAULT" | head -20`.

Write mechanics:
- **New note** → Write the file at its full path under `VAULT`.
- **Into a daily-note section** → Read the note, then Edit to insert the bullet as the last
  line of that section (before the next `##`, or at end of file). Add only; never replace.
- **Daily note missing** → copy the `Daily Note` template to `00 - Inbox/YYYY-MM-DD.md`,
  fill its date/title, then insert.

## 6. Report

Tell the user the exact path written, and flag any action promoted to Things 3.
