# 2026-07-31 — Sync presentation script to updated slides

- **Asked:** Update the script in Matthew's section of `Presentation Planning.docx` to match
  the current slides in `P4P_116_Presentation.pptx`.
- **Did:** Compared each of slides 7–12 against the doc's Content/Talking points and fixed
  drift. Biggest changes: slide 8 no longer compares ball bearing vs stinger (retitled
  "Proposed Stinger Decoupling System", rewritten around the 6-stinger/transducer assembly);
  slide 12 is now a 4-step timeline (detailed design → DAQ system → fabrication →
  experimental validation) targeting late September, not the planned 5-step/October version.
  Smaller fixes: slide 7 reframed as Constraint/Issue/Solution, slide 9 "d" → "D", slide 11
  dropped sensor quantity figures not shown on the slide. Committed as 70ab3cd.
- **Notes:** No LibreOffice/pandoc available in this environment, so the edit was verified by
  parsing the edited `.docx` with python-docx rather than a rendered visual check.
