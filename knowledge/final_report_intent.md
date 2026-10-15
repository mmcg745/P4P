# Final report: author intent, narrative and decisions

What Matthew wants the final research report to say and how it should read. It is gathered from the report-drafting chat (13–15 Oct 2026), the poster and DAQ chats, and the session logs. A new chat working on the report should read this first, then `knowledge/10_experimental_results.md` for the numbers.

Sections are marked by source:
- **[said]**: Matthew said or chose it directly.
- **[agreed]**: Claude proposed it and Matthew accepted it.
- **[draft]**: a framing that is in the current draft but hasn't been explicitly discussed; treat it as provisional.

Last updated 15 Oct 2026.

---

## 1. The deliverable

| Item | Value |
|---|---|
| Title [draft, from the poster] | *Development of a Low-Cost Microvibration and Torque Test Platform for Reaction Wheel Assemblies* |
| Due | Report: Sun 18 Oct 2026, 11:59 pm. Research compendium: Tue 20 Oct 2026. |
| Length (handbook) | ≤ 30 pages from Introduction to the end of Future Work; 8,000–13,000 words; Times 12 pt |
| Abstract | ≤ 350 words, ordered context → question → method → results → implications (`writing an abstract.pdf`). Currently 281 words. |
| Referencing [said] | **APA 7th** (biblatex-apa + Biber). Don't switch styles. |
| Language | NZ/British English. Follow the number rules in `final_report/Rules.pdf`: words below 10, numerals from 10 up, no space before %, a leading zero on decimals. |
| Master copy [agreed] | `...\Part IV\P4P\final_report\Overleaf_FinalReport\`, compiled locally with MiKTeX via `build.ps1`. Overleaf is optional and read-only (re-upload the zip). Never edit in both places. |
| Rubric | `final_report/2026 P4P Final Report Rubric Students.pdf` (criteria A–F) |
| Integrity | The report must be written independently of Brodie's, and Turnitin compares it against the class. Figures Brodie made alone need a citation to his report. |

## 2. The story the report tells

**One-line answer [draft]:** A low-cost platform of stingers and single-axis sensors *can* resolve flight-relevant imbalance and measure the six-axis wrench and the spin-axis torque in one test. Its accuracy is governed by the **structure's dynamics, not its sensors**, and that limit was diagnosed, corrected for and traced to a specific part of the rig.

**Narrative arc:**
1. **Problem.** Reaction wheels are the dominant microvibration source on satellites, so every wheel must be characterised on the ground. Current practice uses piezo dynamometers costing NZ$100k or more, often with separate rigs for microvibration, imbalance and torque.
2. **Gap and aim.** Could one low-cost platform measure all three in a single test? The literature review is rewritten around this aim, not the old three-pillar split [said: "rewriting the lit review to line up with final research aim"].
3. **Hypothesis and its proviso.** Each stinger carries load only along its own axis, so the six readings give the full wrench. Accuracy is then set by the sensors, *provided* the first mode sits well above the measurement band. **The results refute the proviso, and that refutation is the turning point of the report** [draft].
4. **Design evolution.** This is shown as an improvement story [said: keep "all the previous iteration information… good to use to make word count, and for showing how we improved"]:
   - the July concepts A–D, then the ring and ball-bearing plates (rejected over sensor preload), then the six-stinger platform
   - the mid-year dynamic-imbalance method (dropped: too sensitive to the rotor's centre-of-mass height)
   - the rod sizing and the optimisation sweep
   - the final piano wire, a deliberate decoupling-versus-stiffness trade-off [said: chosen for **lower lateral stiffness** and on **supervisor advice**]
5. **Testing across three campaigns** that also tell the improvement story [agreed]:
   - **A (11 Oct):** PLA brackets, 9.56 g bolt
   - **B (12–13 Oct):** steel brackets, 1.48 g washer
   - **C (15 Oct):** aluminium plate, more runs, vector residual subtraction, 0° and 90° angle checks, static calibration, torque step

   Matthew ran campaign C specifically to "improve data and get a more clear idea of the capabilities of the device" [said].
6. **Findings, ordered by the research questions:**
   - **RQ1, imbalance:** 621 g·mm recovered within 5%. 192 g·mm recovered within 8% after subtracting the wheel's own residual, and its angle within 5° with no speed sensor. The noise floor is under 0.2 g·mm, two orders of magnitude below the 26 g·mm flight specification.
   - **RQ2, wrench and torque:** a six-axis spectrum and Campbell plots. The spin-up torque was measured directly: 34.9 ± 0.6 mN·m against 32.4 mN·m expected (+8%). The torque story moved from "only fluctuating" to "dynamic torque measured directly".
   - **RQ3, the accuracy limit:**
     - The ~39 Hz lateral mode amplifies the imbalance force, which is why the measured imbalance rises with speed. A transmissibility model, confirmed by tap tests, corrects it to within 3% up to 1900 rpm.
     - The diagnosis: the aluminium plate isn't the limit; the wheel's frame limits y; x is whole-body sway below the stingers (likely the acrylic base).
     - The rig is up to 87 times softer laterally than the wires alone, and the FEA (which uses bonded joints and a fixed base) is still two to four times too stiff.
7. **Implication and future work.** Stiffen the support structure (base first, then the frame, higher-modulus or notched stingers and a lighter plate), add an encoder, and test a flight-representative wheel.

**Tone [draft]:** honest engineering. The limitation is a *finding*, not a failure: the report shows what limits a low-cost platform and how to fix it. The cost claims stay cited and calibrated (see §4).

## 3. Settled content decisions

- **FEA [said]:** re-run on the final geometry (14 Oct). The set-up:
  - aluminium plate
  - a 0.94 kg point mass with inertia
  - about 1 kg on the plate plus a ~500 g plate
  - bonded joints imported from Inventor
  - a fixed steel base
  - a frame of struts and a post (confirmed)

  The ANSYS X and Y axes are swapped relative to the report.
- **Stinger dimensions [said]:** the measured wire values (0.8 and 1.2 mm × 95 mm free length) are the design values throughout. The ends are welded into bolts, not grub-screw clamped.
- **Mounting [said]:** the rig is bolted to the lab's vibration-isolation table. Its make and specification are unknown, so the report says so and lists "unknown support conditions" as a limitation.
- **Old material [said]:** the stinger geometry and FEA sections were based on the old model, and "most of the old stuff needs updating with the recent changes". The history is kept as the design-evolution story; superseded numbers aren't.
- **Batching [said]:** Matthew preferred to wait for the 15 Oct aluminium-plate data and do one update pass. That pass is done.
- **Commercial cost:**
  - [said] The NZ$100k figure for an aerospace-grade system probably underestimates the true cost, so keep the references.
  - [said, for the poster] Use "130–300k+" because it makes this rig look much cheaper.
  - [agreed] In the report, use the cited range (Totis 2025, Kistler 9236A, ESA tender, De Munter 2018). The rig's own cost is framed as hard to state cleanly, with the saving being in the sensing chain.
  - Keep any comparison to what the sources support (see the claims guidance in the skill).
- **Presentation preferences (from the poster chats) [said]:**
  - Label figures by setup (e.g. "Al plate") or not at all. **Never by test date.**
  - The photo of the real RWA housing is preferred over the 3D-printed wheel because it looks cleaner. A rig photo with the aluminium plate can replace older photos.
  - "What we did" is framed as overall achievement, not a split of contributions. That was for the poster; in the report the contribution statement is required (see §5).

## 4. Writing guidance to apply (stem-research-writing skill)

The skill is installed at `.claude/skills/stem-research-writing/` (imported from Shuhei's Codex wiki). The points that matter most for this report:

- **Claims:** watch for "accurate", "validated", "robust" and "proves", and state the conditions behind each (e.g. "within 5% for a 621 g·mm imbalance up to 1900 rpm"). Keep model predictions (FEA, transmissibility) distinct from measurements.
- **Findings emphasis:** lead each Results subsection with the finding. The structural-dynamics limit is the central finding, so it gets the main evidence in the body; supporting plots can go in the appendix. Don't hide unfavourable evidence there (e.g. the +13% on the small mass in campaign B, the FEA mismatch).
- **Limitations:** write them through their consequences: what the limitation affects and what can still be concluded.
- **Cutting to 30 pages:** remove repetition and peripheral explanation. Keep the evidence, limitations and reproducibility details needed to judge the central claims.
- **Consistency:** when a number changes, check it everywhere: abstract, results, discussion, conclusions, captions and tables.
- **Missing facts:** keep the visible `\checkme{}` markers. Never invent values or sources.

**Where Shuhei's guidance differs from Matthew's brief** (Matthew's brief wins):
- Shuhei's "Rough Guidance" says **25 pages, Introduction to Conclusions**, and uses the **ESB** LaTeX template. That is the Engineering Science department's rule. Matthew's handbook says **30 pages, Introduction to Future Work**, and the report is already built on the 2025 department template. Copies are in `final_report/Shuhei_wiki_guidance/` for reference only.
- The skill defaults to NZ English and doesn't impose a citation style. Both fit.

## 5. Open items (as of 15 Oct, evening)

1. **Page count:** the body runs to page 35, about 5 pages over. Claude proposed cutting about 2,000 words: design ~800, literature review ~350, discussion ~300, conclusions and future work ~300, method and introduction ~100 each.
   - **Waiting on Matthew:** make the cuts now, or after his review notes? Is any section off-limits?
2. **Contribution split with Brodie:** `\checkme` in the Introduction. Confirm with Brodie and the supervisor. Also check whether Brodie's report reuses any of these figures, which affects caption citations.
3. **Mode 6 shape** (324.7 Hz, assumed to be vertical bounce): `\checkme` in the design chapter.
4. **Title page:** report number format and specialisation.
5. **Appendix:** the list of research compendium contents.
6. **Declaration:** replace `Declaration.pdf` with the signed 2026 version.
7. **Final passes:**
   - a rubric pass (criteria A–F)
   - a language pass with the skill (claims, numbers, tense)
   - a Turnitin pre-check
   - an editable, searchable PDF

## 6. Working routine [agreed, 15 Oct]

- Start a fresh chat per task, with a targeted instruction, e.g. "read `knowledge/final_report_intent.md`, then shorten §3.4 to two paragraphs".
- After each edit: rebuild with `build.ps1`, check references and page count, and log in `log/`.
- Only render pages to images when the layout matters (it's expensive).
- Use a lighter model for wording and number edits; keep the bigger model for restructuring and analysis.
