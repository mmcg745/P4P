# Build P4P presentation deck

**Asked:** Build the actual 12-slide `.pptx` for the upcoming conference-day presentation, using
`Presentation Planning/Presentation Planning.docx` as the slide-by-slide script (Content: bullets
on slides, Talking points: as speaker notes) and `Presentation Planning/Conference Day
Presentation.pptx` as the template/base. Pull real figures/tables from `knowledge/` where the plan
calls for them. Render and visually QA before finishing. Save as `P4P_Presentation.pptx` in the
repo root and push to GitHub.

**Did:**
- Found the template already in the repo as a 23-slide skeleton (slides 1-12 titled/laid out
  close to the plan, slides 13-22 unused extra layout examples, slide 23 a "Thank you" end slide);
  trimmed it to the 12 slides the plan calls for.
- Filled all 12 slides with real content: bullets, tables (stinger design check results and FEA
  mode frequency table from `knowledge/06_stinger_design_analysis.md` and
  `knowledge/07_finite_element_analysis.md`; Rocket Lab imbalance specs from
  `knowledge/01_literature_review_microvibrations.md`), a 2x2 check-equation grid, and a 5-step
  next-steps timeline built from shapes.
- Put all Talking points: text into speaker notes per slide.
- Left every photo/CAD/sketch/screenshot the plan calls for (satellite/RWA photo, Kistler photo,
  CAD renders, ring plate/ball bearing sketches, six-component and decoupling diagrams, stinger
  d/L diagram, FEA Mode 1 ANSYS screenshot, sensor photos) as clearly labelled gray placeholder
  boxes — none of these exist anywhere in the repo, and the user chose not to have them
  auto-generated.
- Rendered all 12 slides via PowerPoint COM automation (no LibreOffice available on this machine)
  and fixed real layout bugs found in QA: duplicated leftover bullet paragraphs on slides 1, 2, 6,
  7, 8; a title/body overlap on slide 3; and title-text wrapping into the content below on slides
  6, 8, 10, 12 (fixed by shortening titles / setting explicit font sizes).
- Validated the final file with the pptx skill's `validate.py` against the original template
  (all checks passed) and confirmed no leftover lorem/placeholder boilerplate via `markitdown`.
- Saved as `P4P_Presentation.pptx` in the repo root.

**Notes:**
- Real images are still needed for the ~10 placeholder slots listed above before the deck is
  presentation-ready — user said they'll supply these separately.
- Slide 12 (Next Steps) timeline has no specific calendar dates — knowledge notes only give
  "Semester 2 (Aug-Oct 2026)" and an October 2026 proof-of-concept target, so exact
  procurement/fabrication/testing dates were left generic; fill in real dates if available.
- Installed `markitdown[docx,pptx]`, `defusedxml`, `lxml`, `Pillow`, `python-pptx` into the
  system Python via pip to support the pptx skill's scripts on this machine.
