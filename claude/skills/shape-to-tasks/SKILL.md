---
name: shape-to-tasks
description: Turn a shaped bet, pitch, or feature description into a YouTrack epic with small, sliced, developer-ready child tasks. Use this skill whenever the user wants to shape work, break a feature down, plan an epic, slice tasks, or says things like "shape this", "break this down into tasks", "create an epic for X", "turn this pitch into tickets", "plan this feature", or pastes a shaping/pitch document to be converted into issues. Also trigger during sprint planning when a feature needs decomposing, and when the user asks to review, clean up, or clarify EXISTING tickets or an epic's child tasks ("clean these up", "make this clear for devs") — the description format defined here applies to existing issues too. For single ad-hoc issue operations (comment, update, quick create), use the youtrack skill instead.
---

# shape-to-tasks — pitch → epic + sliced child tasks

Convert a shaped bet into a YouTrack epic plus small vertical-slice child tasks at
**https://yester.youtrack.cloud** (via the `youtrack` MCP server). The point: every task
that reaches the board is small enough to finish and test in **one merge**, and detailed
enough that the developer self-tests before review. Vague tickets are what cause review
round-trips — this skill exists to make them impossible.

## 1. Ingest the shaping

Two input modes — accept either:

- **Pasted pitch/shaping doc** — read it fully; extract the problem, appetite, solution
  sketch, rabbit holes, no-gos.
- **Interactive** — the user talks it through. Ask only what's needed to shape: what's the
  problem, what does done look like, what's explicitly out.

**Persist source material before shaping on it.** Raw inputs pasted into chat — stakeholder
transcripts, meeting notes, feedback summaries — die with the session. Write them to
`/Users/martinbullman/Development/youtrack-spec/` (e.g. `DEV-XXXX-sources.md`) first. In
tickets, link only sources everyone can open (SharePoint video URLs) — never local
`youtrack-spec` paths; that folder is Martin's, devs can't reach it. When a dev disputes a
requirement weeks later, the evidence must exist somewhere durable.

## 2. Analyse the codebase — to shape, not to prescribe

Use the Explore agent to understand what the work touches. This analysis is **for slicing and
risk**, not a to-do list for the developer. Shaping gives direction; the developer owns the
how. Do **not** put file paths, method names, or step-by-step implementation into the tasks —
that removes the dev's ownership and makes you the person who has to know every file.

The analysis exists to let you:

- **Slice correctly** — knowing roughly what's involved is how you judge whether a slice
  fits one merge.
- **Flag risk** — anything touching a schema change or destructive migration needs
  expand/contract treatment and can block other work (shared DEV database). Surface these.
- **Spot reuse** — if a capability already exists (an exporter, an auth pattern, a
  utility), note it as a *don't-rebuild-this* flag so the dev doesn't duplicate it. Name the
  thing, not how to wire it. (The codebase forbids duplicated utils; reuse-blindness is the
  one gap pure outcome-tickets leave.)

Three lessons from work against the **old solution** (migrations/rewrites):

- **Establish provenance before reviewing any artifact.** Before critiquing a BPMN, schema,
  or config attached to a ticket, ask: *is this a proposal, or was it running in
  production?* A production-proven artifact gets reviewed for how to integrate it; a draft
  gets reviewed for correctness. Reviewing one as the other wastes the whole cycle.
- **Artifacts may live outside the repo.** Email templates are in **S3**; task-form configs
  and process deployments live in runtime storage. A code search that finds nothing does NOT
  mean "doesn't exist — must be created". State where you looked, and ask Martin before
  claiming an old-solution artifact is missing. In specs, write claims with their
  verification provenance — "not found in the backend repo (S3 not checked)" is honest;
  "does not exist" overclaims and propagates into tickets as fact.
- **A working legacy process is usually the spec.** If a production-proven artifact (e.g. a
  BPMN process) exists, the default is to build the new solution *around it*, and its
  behaviours are requirements — not "gaps to fix". Where its behaviour differs from what
  stakeholders asked for, surface each difference as an explicit keep-or-change decision for
  Martin; don't silently spec a redesign.

Stack context: Frontend Vue 2 / Vuetify 2 (own repo) · Backend Java (own repo) · shared DEV
database · workflow processes (BPMN/Flowable) deploy as **per-tenant copies** that may
diverge — never assume a single shared process definition · email templates live in **S3**.

## 3. Slice into tasks

Draft one **epic** plus child **tasks**. Slicing rules:

- **Vertical slices** — each task delivers something observable and testable end-to-end,
  not "all the backend" then "all the frontend".
- **One merge each** — if a task can't be finished and tested in a single merge, split it.
- **Independent where possible** — note ordering dependencies explicitly when not.

Every child task must meet **Definition of Ready** before it can be created:

- Testable acceptance criteria (the tester can verify without asking anyone)
- Explicit out-of-scope line (what this task deliberately does NOT do)
- Reuse flags where they apply — existing building blocks the dev should not rebuild
  (named, not wired)

Deliberately **not** in a task: file paths, method names, or how-to steps. Direction, not
prescription — the developer decides the implementation.

And carries a **Self-Test Checklist** that makes the developer self-test: the acceptance
criteria re-stated as steps the dev runs before moving the card to Code Review. (Named
deliberately — not "Definition of Done", which in Scrum is the team-wide global checklist,
and not "Acceptance Criteria", which is the Requirements table itself.)

## Ask, don't assume — questions are part of the shaping

When shaping or iterating on task specs, put questions to Martin instead of writing around
uncertainty — a sharp question forces the rethink that produces the right spec, and he wants
that pressure. Ask when any of these hold:

- **Two sources disagree** — ticket vs code, code vs stakeholder video, old solution vs new
  requirement. Never silently pick a side; present the conflict as a keep-or-change decision.
- **A requirement can be read two ways** and the readings produce different builds.
- **The decision is a policy call** (what the product should do), not an engineering call —
  policy belongs to Martin even when an obvious-looking answer exists.
- **You're about to write "probably" / "presumably" into a spec** — that word is a question
  that hasn't been asked yet.

Form: concrete either/or options with a recommendation and the consequence of each — not
open-ended "what do you think?". Don't ask about things with one conventional answer or that
the codebase already settles; decisiveness on those is expected.

## 4. Two gates — slice list first, then the full plan

Human review at every boundary is what prevents drift; a wrong slice caught early costs
seconds, on the board it costs a dev's day.

**Gate 1 — slice list.** Before drafting any full descriptions, show the proposed epic +
slice list as one line per task (name, what it delivers, dependencies). Wait for the user
to confirm or reshuffle the slices. Only then invest in full descriptions.

**Gate 2 — full plan.** Show the complete epic + task breakdown (full descriptions,
dependencies, open questions) **before creating anything**. Do not create issues until the
user explicitly confirms (yes / looks good / proceed). Real issues on a real board are
expensive to unwind; a draft in chat is free to revise.

The same gate applies to **updates of existing issues**: print the complete final
description in chat and wait for the go before any `update_issue`. Always the **full final
text, never a diff or changed-rows-only summary** — a diff reads as if the unlisted rows are
gone (Martin has flagged "missing" requirements that were simply not in the diff), and he
verifies the whole ticket before it lands. Iterate on the draft in chat as many rounds as
needed; write once.

## 5. Create in YouTrack

Once confirmed:

1. `get_issue_fields_schema` for the target project (default **DEV**) — custom required
   fields vary per project.
2. `create_issue` the epic (type Epic), then each child task (type Task or Bug). Every
   summary — epic and children — starts with the module or integration name, then a brief
   description with each word capitalised: `<Module/Integration Name> - <Brief Description>`,
   e.g. `Assets Module - Feature Improvements`, `Assets Module - Cancel Pending Assignment`,
   `Merit Palk Integration - Sync Failure Fix`. Titles say **what the work delivers**, not
   where it came from — `Assets Module - Assignment Withdrawal & UI Improvements`, never
   `Assets Module - Stakeholder Feedback Improvements`.
3. `link_issues` each child as **subtask of** the epic, and `depends on` between tasks
   where real ordering exists (never dependency prose in descriptions).
4. Report every ID as a link: `[DEV-123](https://yester.youtrack.cloud/issue/DEV-123)`.

## Epic description format

Epics are deliberately **thin** — the substance (requirements, notes, self-test) lives on
the child tasks. Industry-verified (Atlassian, SAFe, Shape Up, GitLab, Scrum.org consensus,
2026-07): no framework puts requirements tables or hand-maintained child lists on epics.

```
#### <span style="color:red;">**Problem**</span>
[Why the status quo doesn't work — one short paragraph or two; source links (feedback
videos, docs) underneath]

#### <span style="color:darkorange;">**Objective**</span>
[ONE checkable outcome statement. This IS the epic's definition of done: reading it at the
end must answer yes/no, and every in-scope feedback item must be covered by a clause so
nothing silently falls out of "done".]

#### <span style="color:green;">**Scope**</span>

### Decisions Made During Shaping
[Dropped/deferred feedback items with the why — omit the section if none]

### Out of Scope
[The hard no-gos]
```

Explicitly **not** on an epic:

- **No Requirements/acceptance table** — the child tasks' tables are the epic's acceptance
  criteria.
- **No child-task table** — YouTrack's native subtask panel is the child list; a
  hand-maintained copy drifts.
- **No separate Definition of Done section** — the Objective serves that role.
- **No slicing rationale or dependency prose** — express task ordering with `depends on`
  links between the tasks themselves.

Process rule: an epic may close before all its children are done — descoped children get a
row under Decisions Made During Shaping.

## Task/Bug description format — every child issue, no exceptions

```
#### <span style="color:red;">**Problem**</span>
[Context — what is broken or missing, why it matters, relevant background]

#### <span style="color:darkorange;">**Objective**</span>
[The outcome — clear, specific, developer-ready]

#### <span style="color:green;">**Scope**</span>

### Requirements
| # | Requirement | Status |
| --- | --- | --- |
| R0 | [testable acceptance criterion] | Open |
| R1 | ... | Open |

### Notes
[Only what the dev can't be expected to know: reuse flags ("X already exists — don't
rebuild it"), constraints, migration/shared-DB risk. No file paths, no how-to. Omit this
section entirely if there's nothing the dev wouldn't already know.]

### Out of Scope
[What this task deliberately does not do]

### Self-Test Checklist
[Self-test steps the developer runs before moving to Code Review — stated as outcomes to
verify, not implementation steps]
```

Rules: `####` + inline `<span style="color:...">` for the three top headings only; `###`
for everything inside Scope; the Requirements table always sits first under Scope so
acceptance criteria are visible in the ticket itself. Keep tasks about *what* and *why*, not
*how* — the developer owns implementation.

### Bug tickets: now/should table, B-numbers

A plain Requirements table hides the defect — "The dropdown is translated" doesn't tell the
dev what is currently broken. For Bug-type issues the table is `### Bugs to fix` and each row
states both sides:

```
| # | What happens now (bug) | What should happen (fixed) | Status |
| --- | --- | --- | --- |
| B1 | [current broken behaviour] | [correct behaviour] | Open |
```

Number rows B1, B2… (not R0…) so nobody reads them as feature requirements. The same
two-column shape also works on Task-type rows that fix wrong behaviour — use a `—` in the
"now" column for rows that are pure requirements. Key screenshots to the row numbers
(`B3: ![](image.png)`).

### Wording recipe — every description

- **Problem** is one short paragraph, or flat bullets each led by a bold headline — never
  numbered "1./2." groups with sub-paragraphs.
- Use the module's **exact domain terms** (e.g. "daily allowance", "cost coverage",
  "prepayment") — not loose paraphrases like "trip money".
- State calculations as a **concrete worked example**, not algebra: "host covers 30% →
  employee is paid 70% of the daily allowance" beats "pays out (100 − X)%".
- Long URLs get short markdown link text: `[Feedback video](url)`.
- **Out of Scope** items live under Scope, not woven into the Problem text.
- **Leave an empty line of space before each `###` subsection under Scope** (every one
  after the first). Markdown collapses plain blank lines, so render the gap with a line
  containing only `&nbsp;`, surrounded by blank lines — never a `---` rule. Without the
  spacer, Scope renders as one cluttered wall of headings.

## Cleaning up existing tickets

When the user asks to review, clean up, or clarify tickets that already exist on the board,
the job is a **restructure to the full matching template above in one update per issue** —
the thin epic template for Epics; Problem, Objective, Scope with Requirements/Bugs table,
Notes, Out of Scope, Self-Test Checklist for Tasks/Bugs — and all sibling issues in one
batch. Cleaning an epic means *removing* any requirements table or child-task table it has
accumulated, not adding them. Read every issue first, then rewrite each whole
description in a single `update_issue` call. The Self-Test Checklist is the part devs value
most on a cleanup: it tells them exactly how to retest. One pass through the full template
replaces a dozen review round-trips through partial fixes.

**Requirements are atomic: one outcome per row.** Never bundle several changes into one row
with commas or "and" — Martin rejects dense rows as "very hard to follow, not easy to work
with". Prefer seven small rows over three dense ones. Write each row in plain, simple
English a developer can act on without re-reading.

**No narrative, no old issue IDs.** Descriptions are clean Problem/Objective/Scope — no
history ("feedback was scattered across…", "consolidated from…"). Never write issue IDs of
old/closed/superseded issues in description text: every ID YouTrack sees becomes a
"mentioned here" link that clutters the issue. Refer to sibling sub-tasks by title, not ID;
link source material (videos, docs) by URL.

**Spec doc and tickets are one artifact in two places.** When a requirement changes on a
ticket that references a `youtrack-spec` doc, update that doc in the same session — and vice
versa. Divergence is how a corrected decision quietly survives in the other copy and
resurfaces later as fact.

**Requirements changed on an In Progress ticket → assignee heads-up.** Immediately after
the update lands, draft a one-line comment for the assignee summarising what changed and
why, and offer it to Martin for approval (post only on his go). The prompt fires every time;
whether it posts is his call. A dev building against reversed requirements is the most
expensive failure a ticket edit can cause.

Everything durable goes in the **description**, never in comments (the MCP server can't even
delete a misplaced comment):

- Source material (feedback video/recording, pitch doc) → linked under the epic's Problem
  statement.
- Shaping decisions and dropped feedback items → a `### Decisions made during shaping`
  subsection under the epic's Scope, with the why, so descoped items stay traceable.
