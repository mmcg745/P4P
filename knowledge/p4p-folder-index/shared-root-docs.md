# P4P Shared: loose root documents

Index of the loose files directly inside `P4P Shared/` (not its subfolders: `DAQ/`, `Figures/`, `MATLAB/`, `P4P Concept CAD/`, `PCB FT/`, `Readings/`, `Example set up/`, `P4P Display-day poster/`). Snapshot as of 2026-10-13. `desktop.ini` skipped.

Overview: the two reports are the formal record (Final Report for Objectives 1 and 2 scope and literature review; Mid-Year Technical Report for the stinger concept, maths and FEA). The concept design report (July) predates the stinger decision and the mid-year report. Presentations and the conference script are from the 1 Aug 2026 conference day. Planning files are the Gantt charts, DAQ shopping list and the open-questions note.

Discrepancy to be aware of: the mid-year report sizes steel stingers at d = 2 mm, L = 50 mm, but `STINGERS.docx` lists 100 mm piano-wire stingers (1 mm radial, 1.5 mm axial), and the STP file is named "V3R1mmA2mmx100mm". Check which set is current before quoting dimensions.

## Reports

- `P4P Shared/FinalReport-Matthew.pdf` — Final Report, "Project Scope, Objectives and Literature Review" (dated 02/04/2026, 9 pages). Scope, six research objectives, research relevance, then the literature review.
  - Section 1: problem statement (RWA microvibration, imbalance, torque not measured together); six objectives (SOTA survey, concept design, detailed design, maths model, proof-of-concept hardware, validation).
  - Section 2 literature review: microvibration (Bosgra & Prins 1982, Masterson 2002 force scales with speed squared, De Munter 2020 2100 rpm / 30 Hz mode gives 3 arcsec RMS), imbalance theory and methods, torque (direct vs indirect, friction), existing platforms review, summary. References in section 3.
  - keywords: scope, objectives, literature review, microvibration, RWA, imbalance, static/dynamic, indirect torque, De Munter, Masterson, Smet, Rocket Lab targets, state of the art

- `P4P Shared/P4P_Mid_Year_Technical_Report_MM2.pdf` — Mid-Year Technical Report (dated 26 July 2026, 10 pages; author Matthew McGill, partner Brodie Cruse, supervisor Dr Guglielmo Aglietti). Stinger concept design and its analysis.
  - Section 1: concept evolution (floating ring plate rejected for unequal radial preload; ball-bearing plate; preferred six-stinger suspended platform, three axial and three radial stingers).
  - Section 2: maths model (coordinate system, force/moment derivation, static imbalance, torque, dynamic imbalance limitation).
  - Section 3: stinger design analysis. Four checks: fn > 500 Hz, kax/klat > 3000, buckling SF > 5, yield SF > 3. Selected d = 2 mm, L = 50 mm steel (E = 200 GPa, yield 350 MPa, m_total 1.2 kg). Results: fn 892 Hz axial, 515 Hz radial; kax/klat 101 axial, 242 radial; buckling SF 6.4 (axial).
  - Section 4: FEA point-mass model, modes 334 Hz (lateral X), 397 Hz (lateral Y), 696 Hz (torsion), 893 Hz (axial bounce), 966 Hz and 999 Hz (rocking). Modes 1 and 2 are below 500 Hz; fix is thicker radial stinger supports.
  - Section 5: next steps (sensor procurement, static FEA, detailed design, fabrication, validation).
  - keywords: stinger, six-stinger platform, kax/klat, buckling, yield, natural frequency, FEA, modal, point mass, piano wire, steel, ring plate, ball bearing, decoupling, Semester 2 plan

- `P4P Shared/RWA_Concept_Design_Report.docx` — Concept Design Report (July 2026, pre-stinger). Four concepts compared against the requirements.
  - Section 1: requirements and constraints (simultaneous X/Y/Z microvibration force; static imbalance < 26 g·mm and dynamic < 800 g·mm² from Rocket Lab flight spec via Wade et al. 2023; 0-500 Hz band; structural first mode > 500 Hz; vertical spin axis; 100-150 mm rotor; optical tachometer; T = I·alpha).
  - Section 2: Concept A Base Column with Two Sensor Rings; B Elevated Platform; C Suspended Table; D Stacked Plates. Each has a description and sketch.
  - Section 3: comparison table with star ratings. Recommended A and D (genuine two-plane imbalance). Concept D needs 10+ DAQ channels.
  - Section 4: six key decisions for the supervisor (column count, sensor choice, DAQ channels, etc.). Section 6: next steps.
  - keywords: concept A, B, C, D, two-plane, sensor rings, column, stacked plates, suspended table, comparison, star ratings, DAQ channels, Wade et al. 2023, Rocket Lab, requirements, decision matrix

## Presentations

- `P4P Shared/P4P_116_Presentation.pptx` — Conference presentation, 13 slides, 1 Aug 2026 (presenters Brodie Cruse and Matthew McGill; supervisor Dr Guglielmo Aglietti). Slides: problem statement; objective and Kistler cost comparison (about $100k vs cheaper equivalent); microvibration measurement (six-component FFT, target 10 to 50 mN resolution); torque measurement; imbalance (static vs dynamic); decoupling problem; stinger decoupling system (6 stingers + 6 transducers); stinger design analysis; FEA modal analysis; sensors (S-beam strain gauge for axial, PCB 208C01 ICP for radial); next steps (target working proof of concept by late September); thanks.
  - keywords: conference, display, Kistler, cost, six components, Fx Fy Fz Mx My Mz, decoupling, stinger, FEA, PCB 208C01, S-beam, next steps, proof of concept
- `P4P Shared/P4P_116_Presentation.pdf` — PDF export of the same 1 Aug 2026 presentation (13 slides, image-heavy). Same content as the pptx.
  - keywords: PDF export, 116 presentation, slides
- `P4P Shared/P4P_Presentation.pdf` — PDF of the same 1 Aug 2026 presentation, filed separately (also dated 1 Aug 2026). Same content as the other two. Use the pptx as the editable source.
  - keywords: presentation, duplicate, PDF

## Planning and Gantt

- `P4P Shared/P4P Gantt Chart.xlsx` — single-sheet Gantt ("Gantt Chart"). Tasks with start/end, member, group, individual, and status. Deliverables: 1 Scope and Lit Review report, 2 Mid-Year Technical Report and conference presentation, 4 Risk Assessment final, 5 Final Research Report, 6 Research Compendium, 7 P4P Display Day. Also concept design, maths model, detailed design, prototyping, testing.
  - keywords: gantt, schedule, deliverables, milestones, display day, compendium, risk assessment, prototyping
- `P4P Shared/RWA_Project_Gantt_Chart.xlsx` — project Gantt, 3 Mar to 22 Oct 2026, two semesters with mid-year break (S1 3 Mar to 29 Jun, S2 20 Jul to 22 Oct). Tasks: lit review, concept design/evaluation, detailed CAD, structural and dynamic analysis, mathematical modelling, procurement, fabrication, DAQ integration, risk assessment, testing, data analysis, final report, poster, compendium. Key deadlines: scope and lit review 02/04; mid-year report 24/07; conference 01/08; risk assessment.
  - keywords: gantt, timeline, semester 1, semester 2, mid-year break, key deadlines, procurement, DAQ integration
- `P4P Shared/Final_GanttChart_image.pdf` — PDF image of the final Gantt chart (dated 2 Apr 2026). Image-only, no extractable text.
  - keywords: gantt, final, image, schedule
- `P4P Shared/Final_GanttChart_image.png` — PNG version of the same final Gantt chart.
  - keywords: gantt, final, image
- `P4P Shared/Timeline - Gantt Chart.xlsx` — generic Microsoft-style Gantt template (sheets About, Light, Dark, Color). Milestones include concept design (hand drawn), CAD, COMSOL simulations, prototype #1 manufacture/assembly/testing, compare to simulations. Early template, lightly used.
  - keywords: template, gantt, COMSOL, prototype, milestones, risk levels
- `P4P Shared/DAQ Planning.docx` — DAQ equipment specification and availability checklist (about 5.7k chars). Component table: 6 piezo force sensors, 6 charge amplifiers, simultaneous-sampling DAQ (at least 6 channels, 2 kHz+ per channel, 16-bit, ±10 V), tachometer (1 pulse/rev minimum), low-noise coax, host PC (MATLAB/LabVIEW), calibration weights. Then a department checklist: Kistler 9001A/9601 sensors, Kistler 5073A charge amp, NI USB-6210 or cDAQ, USB-1608G, Teensy 4.1 + ADS131M06 DIY option, LabVIEW/MATLAB licences.
  - keywords: DAQ, charge amplifier, Kistler 5073A, 9001A, 9601, NI, cDAQ, USB-1608G, Teensy, ADS131M06, sampling rate, channels, tachometer, cabling, calibration, LabVIEW, MATLAB, equipment checklist

## Notes

- `P4P Shared/Concept notes.docx` — open-questions note for the supervisor meeting (13 July). Sections: column count and geometry (3 vs 4 columns, pitch circle, cross-section, material); structural stiffness (column k = 3EI/L^3, first mode > 500 Hz); upper and lower plate design; sensor collar design; sensor selection (force range from F = C·Omega^2 with safety factor 3); tachometer integration (reflective stripe, stand-off, pulses per rev); signal conditioning and anti-aliasing; software and synchronisation; calibration; RWA mounting and adapter plates. Ends with a "bring to next meeting" list (Brodie concept, two-plane imbalance, soft suspension, wire rope isolators, leaf springs, four-bar linkage, quasi-zero stiffness isolator).
  - keywords: open questions, column count, collar, tachometer, calibration, signal conditioning, anti-aliasing, F = C Omega^2, stiffness, plates, adapter plates, isolators, quasi-zero stiffness, supervisor meeting
- `P4P Shared/P4P Conference Notes.docx` — speaking script and slide plan for the 1 Aug conference. Split of time (Brodie 4 min, Matthew 4 min), slide-by-slide notes and spoken script.
  - keywords: conference, script, speaking notes, timing, slides, Brodie, Matthew, Kistler, pointing error, Rocket Lab
- `P4P Shared/STINGERS.docx` — short stinger spec note. Radial: 100 x 1 mm piano wire, PCB end 10-32 x 3.5 mm, mounting plate end 10-32 x about 5 mm or M5 x 5 mm. Axial: 100 x 1.5 mm piano wire, strain gauge end M5 x 5 mm, mounting plate end M5 x 8 mm. Differs from the mid-year report's 50 mm steel stingers.
  - keywords: stinger, piano wire, 10-32, M5, thread, PCB end, strain gauge end, mounting plate, dimensions
- `P4P Shared/Useful info P4P.docx` — one-line link note: static vs dynamic rotor imbalance (video reference).
  - keywords: imbalance, static, dynamic, video, reference

## Datasheets and manuals

- `P4P Shared/2100-Series-Exciter-Stingers-Datasheet-DS-0015.pdf` — datasheet for the 2100 Series exciter stinger (for electrodynamic shakers). Explains why a stinger helps: stiff axial, flexible lateral, reduces side loads, isolates the armature, adapts to thread sizes, and that the stinger mass and resonance affect force measurement. Used as design precedent for the stinger concept.
  - keywords: stinger, exciter, shaker, lateral compliance, axial stiffness, side load, resonance, force transducer, precedent
- `P4P Shared/EI-30_datasheet.pdf` — Erbessd Instruments EI-30 horizontal soft-bearing balancing machine. Two-plane balancing, 0.05-30 kg rotors, max rotor diameter 508 mm, pedestal load 15 kg, soft bearing suspension, sealed accelerometers. A commercial reference for imbalance measurement.
  - keywords: balancing machine, soft bearing, two-plane, SBS, accelerometer, Erbessd, reference, EI-30
- `P4P Shared/kistler table manual.pdf` — Kistler Type 9257B quartz 3-component dynamometer instruction manual (approx. 2024 revision). Covers safety, handling, installation, charge measurement, calibration. The commercial benchmark the project aims to match.
  - keywords: Kistler, 9257B, dynamometer, quartz, three-component, piezoelectric, calibration, charge, manual
- `P4P Shared/RA-MME-FAF-Lab-v1-Matthew McGill.pdf` — Health, Safety and Wellbeing risk assessment for the Fabrication and Assembly Facility (rooms 405-443), completed by Matthew McGill, signed 27/03/2026. Hazards and controls: hand tools, PCB soldering (fumes, burns), 3D printer, compressed air, chemicals (ChemGold FFX), working at night, workstation.
  - keywords: risk assessment, HSW, FAF, fabrication lab, soldering, 3D printer, compressed air, chemicals, PPE, hazard, L x C rating

## Figures and CAD

- `P4P Shared/Stinger Concept V3R1mmA2mmx100mm.stp` — STEP CAD model of the stinger concept (V3, 20 Aug 2026). Name suggests a 100 mm long stinger with 1 mm and 2 mm dimensions. Check against the report's 50 mm stinger.
  - keywords: STEP, STP, CAD, stinger, V3, 100 mm, model
- `P4P Shared/concept_d_multiview_drawing.png` — multiview drawing of Concept D (stacked plates) from the July concept design report.
  - keywords: concept D, multiview, drawing, stacked plates, CAD
- `P4P Shared/flywheel_test.pdf` — dimensioned drawing of a 3D-printed PLA "Reaction Wheel Tech" test flywheel (about 106 g). Includes an M8x1.25 tapped hole. Third-angle projection, A4 sheet.
  - keywords: flywheel, test rig, PLA, 3D print, M8, drawing, mass 105.97 g
- `P4P Shared/StaticFigure97.png` — plot figure (dated 31 Jul 2026), probably a static imbalance result plot. Name only, not opened in detail.
  - keywords: static figure, plot, imbalance, results
- `P4P Shared/StaticFigure97_legend.png` — same static figure with legend, for report use.
  - keywords: static figure, legend, plot
- `P4P Shared/SETE2.png` — figure image (dated 26 Jul 2026). Name only; probably related to the mid-year report.
  - keywords: SETE2, figure, image
