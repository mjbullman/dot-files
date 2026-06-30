---
name: recall
description: Use when the user wants to find, look up, or reference existing notes in their Obsidian second-brain vault — "what do I know about X", "find my notes on Y", "recall Z", "search my vault/second brain". Returns a ranked list of matching notes with wiki-links and snippets.
---

# recall — search the second-brain vault

Find and list notes in the user's local PARA Obsidian vault. This skill lists — it never
writes and never synthesizes long answers. The user scans the hits and opens what they need.

Search the vault files directly with `grep`, not the Obsidian MCP (which OR-matches, returns
unbounded output that overflows context, and aborts on a `secret is being returned`
redaction filter). If the vault isn't on disk, say "I can't find your Obsidian vault on this
machine — make sure it's synced locally, then try again" and stop. Never answer from memory.

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

Read `"$VAULT/CLAUDE.md"` for the current folder layout and tag namespaces — don't hardcode
them. Folder names drift: a note that sounds like an Area may live under `10 - Projects/`.

## 3. Search

Exclude `Chat History` and `Chat Summaries` — raw chat logs whose durable content is already
promoted into `30 - Resources/`. Other Archive folders stay in scope. Match names first, then
pull snippets; never grep full contents across the vault or output overflows.

```bash
# Content matches — filenames only, capped.
grep -ril --include='*.md' \
  --exclude-dir='Chat History' --exclude-dir='Chat Summaries' \
  -e 'QUERY' "$VAULT" 2>/dev/null | head -40

# Location matches — uses -ipath so a note is found by its containing folder
# (e.g. an "Arthur" project folder), not just its own filename.
find "$VAULT" -type f -iname '*.md' -ipath '*QUERY*' \
  -not -path '*/Chat History/*' -not -path '*/Chat Summaries/*' 2>/dev/null
```

Query choice: use the single most distinctive term (a proper noun, a rare word), not common
words like "settings" or "update". For multi-word queries, AND-intersect passes — don't OR:

```bash
grep -rilZ --include='*.md' \
  --exclude-dir='Chat History' --exclude-dir='Chat Summaries' \
  -e 'term1' "$VAULT" 2>/dev/null \
  | xargs -0 -r grep -ilZ -e 'term2' 2>/dev/null \
  | xargs -0 -r grep -il -e 'term3' 2>/dev/null | head -40
```

Search by tag by grepping the literal string, e.g. `-e 'tech/neovim'` (tags are inline as
`tags: [type/..., project/..., tech/...]`). Then one snippet per surviving hit:

```bash
grep -in -m1 -e 'QUERY' "FILE"
```

## 4. Return a ranked list

Per hit: the title as a `[[wiki-link]]`, its PARA folder, matching tags, and a one-line
snippet. Rank location/distinctive-term matches first — a note inside a folder whose name
matches is the strongest signal. Keep it scannable; read a note in full only if asked.

## 5. Include the archive

When the user opts in ("include archive", "search chat history", "search everything"), drop
the `--exclude-dir` and `-not -path` filters.

## 6. No results

Say so, and suggest a broader term or "include archive".
