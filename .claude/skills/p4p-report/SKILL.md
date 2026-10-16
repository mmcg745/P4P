---
name: p4p-report
description: Workflow for editing, building and checking the P4P final research report (LaTeX, APA 7th, MiKTeX local build), plus pointers for the display-day poster. Use for any edit to the final report or poster, or for rebuilding, checking the page count or refreshing the Overleaf zip.
---

# P4P final report workflow

Keep token use low: read only what the task needs, and don't re-read whole sections "for context".

## 1. Orient (cheap)
1. Read `knowledge/final_report_intent.md`. It holds the story, the settled decisions, the open items and the CHECK list. Don't reopen decisions it marks [said] or [agreed].
2. For numbers, read `knowledge/10_experimental_results.md`. Don't open the raw data unless a value is missing.
3. Open only the section file(s) named in the request. Use Grep to locate text before reading.

## 2. Files
Report root: `C:\Users\matth\OneDrive - The University of Auckland\Part IV\P4P\final_report\Overleaf_FinalReport\` (the master copy; never edit in Overleaf too).
- `mainDocument.tex`: front matter and inputs. The body is in `sections/01_introduction` … `08_future_work`. Appendices are in `09a_supplementary` (A–B) and `09_appendices` (C–E).
- `RefDatabase.bib`: biblatex-apa entries. Cite with `\textcite` or `\parencite`. Never invent a DOI or a source.
- `Figures/`: the figures. Superseded plots are in `Figures/superseded_campaign_AB/`. The 15 Oct data is in `P4P Shared/DAQ/P4P NI DAQ/15_10_26_tests/analysis_output/`.
- Flag unknown facts with `\checkme{...}` (shows as red text). Never guess.

## 3. Editing rules
- Use the Edit tool for LaTeX. If a script is needed, write it with Write as a Python file using raw strings. Don't use bash heredocs, because they mangle backslashes.
- Writing style:
  - NZ/British English.
  - Number rules: words below 10, numerals from 10 up, no space before %, a leading zero on decimals.
  - Use siunitx (`\SI`, `\si`, `\ang`).
- When a number changes, grep for it and update every copy: abstract, results, discussion, conclusions, captions and tables.
- Label figures by setup (e.g. "aluminium plate"). Never label them by test date.
- **The body must stay within 30 pages** (Introduction to Future Work), with 8,000–13,000 words. Body text currently ends exactly on page 30, so any addition needs an equal cut.
- For prose quality, also apply the `stem-research-writing` skill.

## 4. Build and check
Run these from the report root:
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
python "C:\Users\matth\OneDrive\Documents\P4P\.claude\skills\p4p-report\scripts\check_tex.py" .
```
- `build.ps1` runs pdfLaTeX → Biber → makeindex → pdfLaTeX ×2 and writes `mainDocument.pdf`. On failure, look at `build\mainDocument.log` (grep `^!` or `Error`).
- `check_tex.py` reports unbalanced braces, environments and `$` signs, undefined `\ref`s, missing or uncited bib keys, and non-ASCII characters. `BRACE mainDocument.tex 227 226` is a known false positive from the template (it compiles). Only section-file flags matter.
- Page check: grep `build\mainDocument.log` for warnings. To find the body's last page, find the page where Future Work ends (e.g. with `pypdfium2` text extraction). Don't render page images to do this.
- Render images only when the layout matters (it is expensive). Use `python scripts\contact_sheets.py mainDocument.pdf <scratchpad>\sheets`, then view a single sheet.

## 5. After every edit
1. Rebuild and run the check (step 4).
2. Refresh the Overleaf zip only if the user asks for it. It is `final_report\Overleaf_FinalReport.zip` and excludes `build/`, `mainDocument.pdf` and `build.ps1`.
3. If a decision or open item changed, update `knowledge/final_report_intent.md` §3 and §5.
4. Add to or create `log/YYYY-MM-DD_<topic>.md` (see `log/README.md`). Commit and push only when asked.
5. Reply in a few lines: what changed, the page count and any new CHECK items.

## 6. Poster (separate session)
Display-day poster: `...\P4P Shared\P4P Display-day poster\final_poster\`. The editable canvas is https://claude.ai/artifact/J6RDx5nry4oxH4g8hwDx4R. Read its latest version before editing, then re-export the PDF after publishing. It uses only the aluminium-plate data and the user's terms ("baseline wheel", "known 1.48 g imbalance"). Keep it consistent with the report's numbers.

## 7. Deadlines
- Report: Sun 18 Oct 2026, 11:59 pm.
- Research compendium ReadMe: Tue 20 Oct 2026.
