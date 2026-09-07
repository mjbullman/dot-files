---
name: summarise-session
description: Use when the user wants archived chat sessions summarised or the summary backlog cleared — "summarise my sessions", "clear the summary queue", "run the session summaries", "what's pending a summary", "summarise the chat history". Also use after running the session importers, when newly imported sessions need summaries. Trigger even if the user doesn't say "summarise" — "work through the pending sessions" or "catch up the chat archive" is enough.
---

# summarise-session — turn archived chat sessions into durable knowledge

Sessions land in `40 - Archive/Chat History/` as raw transcripts. This skill reads
the ones the ledger still lists as pending and writes a short summary for each,
whose real job is to answer one question: **did anything happen here worth keeping?**

Almost always the answer is no, and saying so plainly is the successful outcome.

## Why the bar is high

Measured across 673 already-summarised sessions: **only 69 produced durable
knowledge.** Yield by session length was 1% at ≤5 messages, 12% at 6–30, and 26%
at 31+. The other 604 summaries are content-free notes that nothing links and
vault search deliberately excludes.

The failure mode is not missing a lesson — it is **inflating session narration
into a fake lesson**. Summaries written without this bar drifted from "here is a
non-obvious thing I learned" into "here is what this session did", which merely
duplicates what the code, the project notes, and the git history already record.

A summary that says `Durable Candidates: None` is doing its job. Reach for that
first and let the rare real lesson argue its way past you.

## The durable bar

Something is durable only if **all four** hold:

1. **Non-obvious** — a competent engineer would not predict it. Silent failures,
   undocumented API limits, and tools that lie about what went wrong qualify.
2. **Portable** — it will be true again on a different day, in a different repo.
   A specific bug in a specific PR is not portable; the class of bug is.
3. **Expensive to rediscover** — it cost real debugging time to find.
4. **Not already recorded** — check before writing. If it lives in the codebase,
   a project note, `CLAUDE.md`, or memory, the summary should point at that,
   not restate it.

Point 4 is where most false positives come from, so search first:

```bash
source ~/.zsh_secrets 2>/dev/null; V="$NEXUS_VAULT"
grep -ril --include='*.md' --exclude-dir='Chat History' --exclude-dir='Chat Summaries' \
  -e '<distinctive term>' "$V" | head
```

### Calibration

| Session content | Verdict |
|---|---|
| `Liquibase addColumn` leaves dependent views stale; migration runs clean, fails at query time | **Durable** — silent, portable, costly |
| Quartz cron with a future year throws `IllegalStateException` | **Durable** — undocumented footgun |
| Fixed DEV-3358 by adding a null check | None — one-off, lives in the diff |
| "This session set up the vault Areas layout" | None — narration; the layout is the record |
| "Decisions captured in CLAUDE.md and planning docs" | None — say nothing, it is already recorded |
| Code review found no blockers | None |

## Workflow

**1. Read the queue.** The ledger is the source of truth, not the folder listing:

```bash
cd "$NEXUS_VAULT" && python3 scripts/record_summary.py --next 10
```

Output is `<note stem>` · `<message count>` · `<project>`, oldest first.

**2. Work through them in order**, batching until context runs low rather than
stopping at a fixed count. Report progress as you go so an interrupted run is
resumable — the ledger already records exactly where you stopped.

**3. For each session:** read the transcript at
`40 - Archive/Chat History/<stem>.md`. Long transcripts do not need reading in
full — the opening request and the closing outcome carry most of the signal, and
the middle is tool noise. Then write
`40 - Archive/Chat Summaries/<stem> - summary.md`.

The summary filename is the note stem plus ` - summary.md`. That exact pairing is
how the ledger and backfill match the two, so it is not a place to improvise.

**4. Record it**, so the session leaves the queue:

```bash
python3 scripts/record_summary.py "<stem>" --summary "<stem> - summary.md"
```

## Summary format

Most of the 860 existing summaries use this shape. Match it — a consistent
archive is worth more than a marginally better template.

```markdown
---
tags: [type/chat-summary, tech/claude-code]
---
# Session Summary: 2026-06-04 — claude-code — aaf2cccd

**Topic:** yesterbe multi-module Maven build broken after mvn clean
**Messages:** 12
**Outcome:** Root-caused to `clean` wiping intermediate module JARs; fixed by building with `mvn install -P compile`.

## Durable Candidates

- **kind:** lesson
  **note:** In a multi-module Maven project, `mvn clean install` wipes the intermediate JARs that downstream modules depend on, so the reactor fails partway through. Use `mvn install -P compile` without `clean`; only `clean` for a deliberate full rebuild.
  **destination:** 30 - Resources/gotchas/
```

Fields:

- **Topic** — one line, what the session was about. This is the searchable line, so lead with the concrete subject (`yesterbe multi-module Maven build`), not a category.
- **Messages** — the `message_count` from the transcript frontmatter.
- **Outcome** — what actually resulted. If the session was abandoned or inconclusive, say that; a truthful "no fix confirmed" is more useful than a tidy fiction.
- **Durable Candidates** — `None` on its own line, or one block per item with `kind` (`lesson` / `decision` / `runbook`), `note` (self-contained — a reader must not need the transcript), and `destination` (the folder it would belong in).

Tag with `type/chat-summary` plus the `tech/` and `project/` tags from the source note's frontmatter.

## This skill flags; it does not promote

Writing the durable item into `30 - Resources/` is a separate, deliberate pass
with a human gate. Promoting automatically fills the reference library with
model-judged material, and the existing library is good precisely because each
entry was chosen. Note the destination and stop there.

## Common mistakes

| Mistake | Fix |
|---|---|
| Restating what the session did as a "lesson" | Narration is not knowledge. If it describes this session rather than a general truth, it is None. |
| Recording something already in the vault | Grep first. If it exists, reference it and record None. |
| A `note` that only makes sense with the transcript open | Write it standalone — the transcript will not be read again. |
| Hedged Outcome when the session failed | Say it failed. Truthful beats tidy. |
| Improvising the summary filename | Must be `<note stem> - summary.md` or the ledger cannot pair them. |
| Forgetting `record_summary.py` | The session stays queued and gets summarised twice. |
| Padding a thin session to look productive | `None` is the expected result ~90% of the time. |
