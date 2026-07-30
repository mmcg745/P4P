# Session Log

This folder is a running record of what's been asked for and what's been done in this repo over
time — a quick way to see recent activity without digging through git history or re-reading chat
threads.

## Format

One file per work session/task:

```
log/YYYY-MM-DD_short-slug.md
```

Each entry should be short and cover:

- **Asked:** what the user requested (brief, in their terms)
- **Did:** what was actually changed/added/decided, and which files were touched
- **Notes:** anything worth flagging for next time (open questions, follow-ups, things skipped)

Keep entries to a few lines each — this is a log, not documentation. If a task produced lasting
project knowledge (a design decision, a result worth remembering), that belongs in `knowledge/`
too; the log entry can just point to it.

## Rule

**Log every session.** Whenever work is done in this repo (code, data, docs, plots, decisions —
not just knowledge-file edits), add a new dated entry here before finishing up. See
`CLAUDE.md` for the mandatory instruction.
