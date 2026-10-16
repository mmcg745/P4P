# 2026-10-16 — p4p-report skill

- **Asked:** a way to keep the report and poster workflow going with fewer tokens.
- **Done:** created the project skill `.claude/skills/p4p-report/`.
  - `SKILL.md`: the orient, edit, build, check and log routine, plus poster pointers and deadlines.
  - `scripts/check_tex.py`: ref, cite and brace checks.
  - `scripts/contact_sheets.py`: PDF contact sheets, used only when layout matters.
  - No separate REPORT_STATUS.md, because `knowledge/final_report_intent.md` already holds the status and open items.
  - Updated the fresh-chat memory to point at the skill.
