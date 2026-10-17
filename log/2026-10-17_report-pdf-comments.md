# 2026-10-17 — Final report: PDF comment pass

- **Asked:** go through Matthew's 62 comments in `mainDocument.pdf`, report back first, and pick up
  anything from other chats that should have reached the report. After the report-back, Matthew
  decided: drop the 1900 rpm results (they would confuse readers who see testing only to 1500 rpm,
  and "the controller cut out" is a weak excuse; with hindsight a brushless DC motor would have been
  chosen); cut §5.5 and the mid-year rod material, keeping only the key points; for cost, say
  everything came from in-house stock except the brackets, which were bought to save manufacturing
  time and complexity; quote stiffness ratios for the aluminium plate with steel brackets and the
  rigid case only; replace the campaign B run summary with campaign C; cut the unclear "central
  column or four columns".
- **Carried over from other chats:** the predicted fₙ after stiffening (poster chat's report prompt,
  never run) is now in Future Work. The stinger-script results (load cell in series → 231 Hz bounce,
  300 Hz acceptable target, 0.85 radial buckling SF, piano-wire σy assumption) are now in §3.4 and
  the new Appendix Table A2.
- **Did (by section):**
  - Front matter: "Part IV Project 116 – 2026", dated 18 October 2026, acknowledgements reworded.
  - Intro: broader aim and RQ1; stingers introduced as the approach the literature points to;
    scope rewritten as constraints only.
  - Lit review: "should", "pointing accuracy", neutral closing sentence.
  - Design: supported mass 1–2 kg; 300 Hz acceptable target; mid-year sizing condensed to one
    sentence (old optimisation count removed); mid-year column removed from Table 3; load-cell
    paragraph added.
  - Method: Table 4 (FEA vs prototype) removed; in-house stock and CNC plate wording; "motorised,
    flight-spec RWA"; campaign dates removed; Ry1 and encoder reasons added; static accuracy vs noise
    distinguished; 15 s hold; campaign B whine sentence and buckling clause cut; stepper drive given as
    the reason for the 1500 rpm limit; CAD-referenced geometry; flowchart box "fast ramp" replaced.
  - Results: 1900 rpm prediction removed; §5.5 folded into §5.6 (residual shift explained there);
    phase section retitled "Without a Tachometer" and linked to campaign C; clockwise sentence cut;
    stiffness ratios now aluminium plate and rigid case (8–25×, 5–23×); y-stiffer and plate-swap
    logic rewritten (the PLA plate did add ~40% compliance, but most lies elsewhere); 26 g·mm noise
    claim qualified (stationary; the practical limit in spin tests is 10–20 g·mm from the wheel);
    Table 5 and the campaign C table fitted to the page width.
  - Discussion: same 26 g·mm qualification; "on that day" removed; 18 g·mm shift explained;
    "estimated" angle; 1900 rpm evidence replaced with the campaign C fₙ match; corrected readings
    "constant within about 4% up to 1500 rpm (f/fₙ ≈ 0.63)"; 515 Hz → 164–232 Hz wording; "slotted
    holes" removed; "ideal solution"; hypothesis "held only in part"; cost sentence; limitations now
    a limited speed range with brushless DC hindsight, CAD-referenced geometry, table-top line cut.
  - Conclusions, abstract: 1500 rpm, 5–25×, tachometer, 70% at 1500 rpm, noise qualification.
  - Future work: predicted fₙ (60–65 Hz with a stiff base, 100–125 Hz with a rigid housing; wires cap
    160–220 Hz; load cells cap bounce near 280 Hz); FEA-check and dynamic-imbalance items removed;
    pre-tensioned wires removed (matches poster); brushless DC drive added; inertia sentence reworded.
  - Appendix A: new final-design parametric figure (`Figures/stinger_parametric_final.png`, from
    `stinger_design_V3.m` final case) and full check Table A2 replacing the mid-year ones; mode 6
    `\checkme` removed (confirmed axial bounce). Appendix C: campaign C run summary (≤1500 rpm runs;
    the two baseline 1600 rpm sweeps omitted). Appendix D: 0.85.
- **Build:** clean; check_tex clean. Body ends on page 30 with ~1/5 page spare.
- **Not changed / for Matthew:**
  - The 993 g comment ("estimate for rigid housing"): `knowledge/10` gives 993 g as the weighed
    3D-printed RWA (807 g) plus PLA plate (193 g); the rigid case was 1.078 kg. Left as is.
  - Remaining `\checkme`: contribution split (Intro) and the compendium list (Appendix E).
  - DOIs not yet added; Declaration being sorted by Matthew.
  - Nomenclature (Glossary) kept: it is part of the department template and doesn't count toward
    the 30 pages.
