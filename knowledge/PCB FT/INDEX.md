# PCB FT Index

This file is a quick-reference dictionary for the source PDFs in `knowledge/PCB FT/`. All are
PCB Piezotronics (Amphenol) manufacturer literature for their quartz ICP® force sensor product
line, relevant to selecting/specifying a force transducer for the P4P device's torque/force
measurement path. Same purpose as `knowledge/readings/INDEX.md`: let a reader understand what
each document covers without opening the PDF, per `CLAUDE.md`.

---

### 208c01.pdf / 208c01_k.pdf
- **Title:** ICP® Force Sensor — Model 208C01 datasheet (Revision K)
- **Source:** PCB Piezotronics, spec sheet #8625 (dated 3/29/2016; revision K).
- **Topic tags:** force sensor datasheet, ICP® piezoelectric, quartz force sensor, specifications
- **Summary:** Full datasheet for the 208C01, the lowest-range (10 lb / 0.045 kN compression and
  tension) member of the 208C general-purpose ICP® quartz force sensor series. Gives sensitivity
  (500 mV/lb), frequency range (0.01 Hz to 36 kHz), stiffness (6 lb/µin), discharge time constant
  (≥50 sec), excitation requirements (18-30 VDC, 2-20 mA constant current), noise spectral
  density, physical size/mounting (10-32 threads, side-mounted coaxial connector), and available
  options (negative output polarity, water-resistant cable). `208c01.pdf` and `208c01_k.pdf`
  appear to be the same datasheet (full-page scan vs. cropped/text-extracted version).
- **Relevance to P4P:** Candidate off-the-shelf force transducer for the stinger rig's
  force-measurement channel — smallest-range option in the series, useful if expected axial
  forces at the stinger tip are low (≤10 lb). Not yet distilled into a numbered `knowledge/0X_*.md`
  note; compare against [[06_stinger_design_analysis]] when selecting a transducer.

### 208c02.pdf / 208c02_k.pdf
- **Title:** ICP® Force Sensor — Model 208C02 datasheet (Revision K)
- **Source:** PCB Piezotronics, spec sheet #8467 (dated 5/11/2017; revision K).
- **Topic tags:** force sensor datasheet, ICP® piezoelectric, quartz force sensor, specifications
- **Summary:** Full datasheet for the 208C02, the next range step up in the 208C series (100 lb /
  0.445 kN compression and tension, 50 mV/lb sensitivity). Same construction, frequency range
  (0.001 Hz to 36 kHz), stiffness (6 lb/µin), and mounting format as the 208C01, but with a longer
  discharge time constant (≥500 sec) and higher excitation voltage requirement (20-30 VDC).
  `208c02.pdf` and `208c02_k.pdf` are the same datasheet (full scan vs. cropped/text-extracted
  version).
- **Relevance to P4P:** Alternative candidate transducer if expected stinger-tip forces exceed the
  208C01's 10 lb range but stay within 100 lb. Same follow-up as 208c01 above — fold comparison
  into [[06_stinger_design_analysis]] when finalising transducer selection.

### TM-FRC-208C_Lowres.pdf
- **Title:** Series 208C General Purpose ICP® Quartz Force Sensors (product brochure)
- **Source:** PCB Piezotronics marketing/technical brochure, TM-FRC-208C-0223.
- **Topic tags:** force sensor product family, ICP® piezoelectric, quartz force sensor,
  specifications comparison, typical applications
- **Summary:** Two-page brochure covering the full 208C series (208C01-208C05, spanning 10 lb to
  5000 lb compression / up to 500 lb tension), with a side-by-side specification table across all
  five models (sensitivity, ranges, noise, DTC, excitation, stiffness, physical dimensions) plus a
  dimensioned drawing. Describes construction (preloaded quartz sensing element sandwiched between
  base plates, stainless housing, internally threaded, side-mounted coaxial connector) and typical
  applications (repetitive process force validation, drop testing, force plates, automation,
  material sample testing).
- **Relevance to P4P:** Best single reference for comparing across the whole 208C range in one
  table to pick the right full-scale range for the stinger's expected force levels; supersedes
  needing to open all five individual model datasheets. Fold selection rationale into
  [[06_stinger_design_analysis]].

### TM-FRC-PosterBook_Lowres.pdf
- **Title:** Force & Strain Fundamentals (PCB Piezotronics educational poster book)
- **Source:** PCB Piezotronics, TM-FRC-PosterBook-1225.
- **Topic tags:** piezoelectric theory, ICP® vs charge mode, force sensor installation, frequency
  response, discharge time constant, strain sensors, force sensor vs load cell, sensor arrays
- **Summary:** A 15-page tutorial covering piezoelectric force sensor fundamentals end-to-end:
  sensor construction and theory of operation; ICP® vs. charge-mode signal conditioning
  (advantages/disadvantages, wiring diagrams, amplitude range calculations); installation
  best-practice (mating surface flatness/finish, fastener torque, preload alignment, and failure
  modes from misalignment); AC vs. DC coupling and long-duration/quasi-static measurement limits
  via discharge time constant (DTC); frequency response theory (DTC, low-frequency roll-off,
  resonant frequency) with worked example specs; dynamic strain sensors vs. traditional
  Wheatstone-bridge strain gages; a force-sensor-vs-load-cell comparison (stiffness, linear range,
  temperature range, size); the different sensor form factors (force link, force ring, 3-component
  triaxial versions, impact sensors, fatigue-rated load cells); and how to combine multiple sensors
  into a force-plate array with the summation equations for forces and moments about a center point.
- **Relevance to P4P:** Broadly relevant background/reference for both selecting a transducer and
  designing its mounting into the stinger rig — the preload/alignment installation guidance and
  DTC/frequency-response theory directly inform correct transducer use, and the multi-sensor
  summation equations are directly applicable if the P4P device ends up using multiple force
  sensors to derive torque/moments. Not yet distilled into knowledge/ notes — recommended
  follow-up: fold installation and DTC/frequency-response guidance into
  [[06_stinger_design_analysis]].
