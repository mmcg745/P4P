# Readings Index

This file is a quick-reference dictionary for the 20 source PDFs in `knowledge/readings/`. Its
purpose is to let a reader (human or a future Claude session) understand what each paper covers
— title, authors, topic, method, key findings, and relevance to the P4P project — **without
opening the PDF**. Only open the underlying PDF if this index doesn't have enough detail, an
exact citation/figure/equation is needed, or a consequential design decision needs grounding in
the original source (see `CLAUDE.md`).

Entries are ordered alphabetically by filename. Where a paper is already cited in
`knowledge/09_references.md` and distilled into one of the numbered `knowledge/0X_*.md` notes,
that cross-reference is given so this file also serves as a map between raw PDFs and the
distilled notes.

## Quick topic map

- **Imbalance (static/dynamic):** BalancingMethod&ExperimentofRWA_DeMunter.pdf, Effect of
  Reaction Wheel Imbalances on Attitude and Stabilization Accuracy.pdf, Modeling and validation
  of reaction wheel micro-vibrations considering imbalances and bearing disturbances.pdf, The
  effect of assembly and static unbalance on reaction wheel assembly bearing harmonics.pdf,
  Microvibration_Model_Development_and_Validation_of.pdf
- **Bearing harmonics / bearing disturbances:** The effect of assembly and static unbalance on
  reaction wheel assembly bearing harmonics.pdf, Modeling and validation of reaction wheel
  micro-vibrations considering imbalances and bearing disturbances.pdf, 1982_testing_and_
  investigation_of_RWAs.pdf
- **Torque measurement:** Liu_2019_IOP_Conf._Ser.__Mater._Sci._Eng._542_012013.pdf,
  Zappalá_2018_Meas._Sci._Technol._29_065207.pdf
- **Stinger/transducer design (test methodology, directly relevant to device build):** TRANSDUCER
  INERTIA AND STINGER STIFFNESS.pdf
- **Disturbance modeling (empirical/analytical RWA disturbance models):**
  validationofRWdisturbancemodel.pdf, Modeling and validation of reaction wheel micro-vibrations
  considering imbalances and bearing disturbances.pdf, Microvibration_Model_Development_and_
  Validation_of.pdf, Coupled microvibration analysis of a reaction wheel assembly.pdf
- **Cantilevered wheel dynamics:** aas0104001-MicrovibrationAnalysisofaCantileverConfigured
  ReactionWheelAssembly-Published.pdf, microvibrations-induced-by-a-cantilevered-wheel-assembly-
  with-a-soft-suspension-system.pdf, Coupled microvibration analysis of a reaction wheel
  assembly.pdf, Experimental and numerical investigation of coupled.pdf
- **Gyroscopic effects / dynamic mass:** addari-et-al-2016-dynamic-mass-of-a-reaction-wheel-
  including-gyroscopic-effects-an-experimental-approach.pdf, Coupled microvibration analysis of a
  reaction wheel assembly.pdf
- **Experimental test rigs / RWA characterisation:** 1982_testing_and_investigation_of_RWAs.pdf,
  RWAMicroVibration_Smet.pdf, Simulating&AnalysingRWAMicrovibration_Hahn.pdf, The effect of
  assembly and static unbalance on reaction wheel assembly bearing harmonics.pdf
- **Reaction wheel actuator development / hardware:** ReactionWheelActuatorDevelopment_wade.pdf
- **FEA/modal & suppression methods:** Micro-vibration suppression methods and key technologies
  for high-precision space optical instruments.pdf
- **Theses:** Hughes-2025-thesis .pdf, BalancingMethod&ExperimentofRWA_DeMunter.pdf (De Munter's
  work draws on MSc research)

---

### 1982_testing_and_investigation_of_RWAs.pdf
- **Title:** Testing and investigations of reaction wheels
- **Authors/Year:** Bosgra, J.A. and Prins, J.J.M., 1982. *IFAC Automatic Control in Space*,
  Noordwijkerhout, pp. 449-458.
- **Topic tags:** RWA testing, imbalance, bearing disturbances, early disturbance characterisation
- **Summary:** An early (1982) paper reporting on test methods and investigations of reaction
  wheels used in spacecraft attitude control, covering how disturbance torques/forces are
  measured and characterised on the ground. It documents test-rig practice from the era before
  microvibration became a distinct discipline, including friction/bearing behaviour and
  wheel-induced disturbance measurement.
- **Relevance to P4P:** One of the earliest references establishing RWA disturbance testing
  practice; useful historical grounding for why RWA testing/characterisation matters and how
  early test rigs were built. Distilled in [[01_literature_review_microvibrations]].

### BalancingMethod&ExperimentofRWA_DeMunter.pdf
- **Title:** Balancing method and experiment of a small spacecraft reaction wheel
- **Authors/Year:** De Munter, W., Lanting, J., Delabie, T. and Vandepitte, D., 2020. *Proceedings
  of ISMA2020 and USD2020*, pp. 1481-1496.
- **Topic tags:** imbalance, balancing method, static/dynamic unbalance, experimental validation
- **Summary:** Presents a method for balancing a small spacecraft reaction wheel to reduce static
  and dynamic imbalance, and validates the approach experimentally by measuring the resulting
  reduction in imbalance-induced disturbance forces/moments. Covers practical balancing procedure
  (mass addition/removal) and measurement setup used to verify balance quality.
- **Relevance to P4P:** Directly relevant to the imbalance-measurement half of the combined
  device — provides a concrete balancing/measurement methodology and experimental validation
  approach to compare against. Distilled in [[02_literature_review_imbalance]].

### Coupled microvibration analysis of a reaction wheel assembly.pdf
- **Title:** Coupled microvibration analysis of a reaction wheel assembly including gyroscopic
  effects in its accelerance
- **Authors/Year:** Zhang, Z., Aglietti, G.S. and Ren, W., 2013. *Journal of Sound and Vibration*,
  332(22), pp. 5748-5765.
- **Topic tags:** microvibration, gyroscopic effects, coupled dynamics, cantilevered RWA,
  FEA/analytical model
- **Summary:** Develops a coupled analytical/dynamic model of a cantilever-configured reaction
  wheel assembly that accounts for gyroscopic coupling between axial and radial/rocking motion in
  the wheel's accelerance (frequency response), rather than treating axes independently. Shows
  that gyroscopic effects significantly shift and couple the structural modes (particularly
  whirl/precession-nutation splitting) as spin speed increases, and validates the model against
  measured accelerance data.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Directly relevant to interpreting
  microvibration data from a spinning wheel on the stinger rig — gyroscopic coupling affects how
  measured FRFs/disturbance spectra should be interpreted at different wheel speeds.

### Effect of Reaction Wheel Imbalances on Attitude and Stabilization Accuracy.pdf
- **Title:** Effect of Reaction Wheel Imbalances on Attitude and Stabilization Accuracy
- **Authors/Year:** Tkachev, S., Mashtakov, Y., Ivanov, D., Roldugin, D. and Ovchinnikov, M.,
  2021. *Aerospace*, 8(9), 252.
- **Topic tags:** imbalance, attitude control, disturbance model, microvibration, pointing
  accuracy
- **Summary:** Analyses how static and dynamic imbalance in reaction wheels propagates into
  attitude/pointing errors of a spacecraft, using a disturbance model of imbalance-induced forces
  and moments combined with an attitude-dynamics simulation. Quantifies the sensitivity of
  pointing/stabilisation accuracy to wheel imbalance magnitude, motivating tight imbalance
  tolerances for precision-pointing missions. Includes a substantial literature survey of RWA
  disturbance sources and models (useful reference list covering many other papers in this
  folder).
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Provides the "why it matters"
  link between the imbalance values the P4P device would measure and real mission-level pointing
  performance impact — useful for motivating the project's imbalance-measurement requirement.

### Experimental and numerical investigation of coupled.pdf
- **Title:** Experimental and numerical investigation of coupled microvibration dynamics for
  satellite reaction wheels
- **Authors/Year:** Addari, D., Aglietti, G.S. and Remedia, M., 2017. *Journal of Sound and
  Vibration*, 386, pp. 225-241.
- **Topic tags:** microvibration, coupled dynamics, experimental validation, cantilevered RWA,
  gyroscopic effects
- **Summary:** Combines experimental measurement and numerical (finite element / analytical)
  modelling to investigate coupled microvibration dynamics of a satellite reaction wheel,
  extending the coupled-accelerance approach (companion/related work to Zhang et al.'s papers) with
  further experimental validation across operating speeds.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Provides an experimental
  validation methodology for coupled microvibration behaviour that could be compared against
  data from the P4P stinger rig.

### Hughes-2025-thesis .pdf
- **Title:** (2025 thesis; exact title not confirmed — file exceeds the 20MB size limit for this
  session's PDF reader, so it could not be opened)
- **Authors/Year:** Hughes, 2025. *Thesis* (institution/degree not confirmed).
- **Topic tags:** thesis, RWA/microvibration (assumed based on inclusion in this reading list)
- **Summary:** Not read in this pass — the file is too large (>20MB) for the available PDF
  extraction tool. Given its place in this reading list alongside the other RWA
  microvibration/imbalance/torque papers, it is presumably a recent (2025) postgraduate thesis on
  a closely related topic, but this should be verified by opening the file directly (e.g. via a
  PDF viewer or a tool without the size limit) before relying on this entry.
- **Relevance to P4P:** Unclear/unverified — flag for manual review. Given the recency (2025) it
  may be one of the most directly relevant and up-to-date sources in the folder; worth prioritising
  for a manual read.

### Liu_2019_IOP_Conf._Ser.__Mater._Sci._Eng._542_012013.pdf
- **Title:** The state-of-art and prospect of contactless torque measurement methods
- **Authors/Year:** Liu, J., Yang, L. and Ma, J., 2019. *IOP Conference Series: Materials Science
  and Engineering*, 542, 012013.
- **Topic tags:** torque measurement, contactless sensing, review, non-intrusive measurement
- **Summary:** A review paper surveying contactless (non-contact) torque measurement methods for
  rotating shafts — e.g. magnetoelastic, optical, and other non-intrusive sensing principles —
  summarising their operating principles, accuracy, and suitability for different applications.
- **Relevance to P4P:** Directly relevant to the torque-measurement side of the combined device;
  provides a landscape of alternative (non-stinger) torque-sensing approaches for comparison.
  Distilled in [[03_literature_review_torque]].

### Micro-vibration suppression methods and key technologies for high-precision space optical instruments.pdf
- **Title:** Micro-vibration suppression methods and key technologies for high-precision space
  optical instruments
- **Authors/Year:** Li, L., Wang, L., Yuan, L., Zheng, R., Wu, Y., Sui, J. and Zhong, J., 2021.
  *Acta Astronautica*, 180, pp. 417-428.
- **Topic tags:** microvibration suppression, review, isolation, space optical instruments,
  key technologies
- **Summary:** A review of microvibration suppression techniques and enabling technologies (e.g.
  vibration isolation, active/passive damping, disturbance-source control) for high-precision
  space optical payloads, surveying the state of the art in mitigating microvibration impact on
  imaging/pointing performance.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Background/context on why RWA
  microvibration matters at the mission level (its downstream effect on optical payload
  performance) and what mitigation options exist once a wheel's disturbance signature is known.

### Microvibration_Model_Development_and_Validation_of.pdf
- **Title:** Microvibration model development and validation of a cantilevered reaction wheel
  assembly
- **Authors/Year:** Zhang, Z., Aglietti, G.S. and Ren, W., 2012. *Applied Mechanics and
  Materials*, 226-228, pp. 133-137.
- **Topic tags:** microvibration, disturbance model, cantilevered RWA, FEA/modal, experimental
  validation
- **Summary:** Develops an analytical/numerical microvibration model for a cantilever-configured
  reaction wheel assembly (precursor/companion to the 2013 JSV coupled-analysis paper) and
  validates it against measured data, covering how disturbance forces and moments arise from
  imbalance and structural dynamics in this configuration.
- **Relevance to P4P:** Early version of the Zhang/Aglietti cantilevered-RWA modelling approach;
  useful comparison point for validating any equivalent model developed for the P4P device.
  Distilled in [[01_literature_review_microvibrations]].

### Modeling and validation of reaction wheel micro-vibrations considering imbalances and bearing disturbances.pdf
- **Title:** Modeling and validation of reaction wheel micro-vibrations considering imbalances
  and bearing disturbances
- **Authors/Year:** Alkomy, H. and Shan, J., 2021. *Journal of Sound and Vibration*, 492, 115766.
- **Topic tags:** disturbance model, imbalance, bearing harmonics, microvibration, experimental
  validation
- **Summary:** Builds a combined analytical disturbance model of a reaction wheel that includes
  both imbalance-induced (once-per-revolution) forces/moments and bearing-defect harmonics, then
  validates the combined model against measured microvibration data across a speed range.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. A close analogue to what the P4P
  device aims to measure/validate — a combined imbalance + bearing-harmonic disturbance model —
  useful as a reference model structure and validation methodology.

### RWAMicroVibration_Smet.pdf
- **Title:** Managing reaction wheel microvibration on a high resolution EO small spacecraft
- **Authors/Year:** Smet, G., Richardson, G., McLaren, S. and Haslehurst, A., 2013. *15th European
  Space Mechanisms and Tribology Symposium (ESMATS 2013)*, Noordwijk.
- **Topic tags:** microvibration, EO spacecraft, disturbance management, mission-level case study
- **Summary:** A mission-focused case study on managing reaction wheel microvibration for a
  high-resolution Earth-observation (EO) small spacecraft, covering how RWA disturbances were
  characterised, budgeted, and mitigated to meet the pointing/imaging stability requirements of
  the mission.
- **Relevance to P4P:** Provides a real mission-level example of why RWA microvibration
  characterisation matters and how disturbance data feeds into spacecraft design decisions.
  Distilled in [[01_literature_review_microvibrations]].

### ReactionWheelActuatorDevelopment_wade.pdf
- **Title:** Reaction wheel actuator development: jumping from hundreds to thousands
- **Authors/Year:** Wade, A., Jackson, R., Keeble, J. and Orr, J., 2023. *ESMATS 2023*.
- **Topic tags:** reaction wheel actuator, hardware development, manufacturing scale-up,
  design/production
- **Summary:** Describes the development and design evolution of a reaction wheel actuator
  product line as production volumes scale from hundreds to thousands of units, covering design,
  manufacturing, and testing considerations for high-volume RWA production.
- **Relevance to P4P:** Gives industry context on modern RWA design/manufacturing practice and
  testing needs at scale, which motivates the need for efficient combined
  microvibration/torque test equipment like the P4P device. Distilled in
  [[01_literature_review_microvibrations]].

### Simulating&AnalysingRWAMicrovibration_Hahn.pdf
- **Title:** Simulating and analysing the microvibration signature of reaction wheels for future
  non-intrusive health monitoring methods
- **Authors/Year:** Hahn, R. and Seiler, R., 2011. *14th European Space Mechanisms and Tribology
  Symposium (ESMATS 2011)*, Constance, Germany.
- **Topic tags:** microvibration, simulation, health monitoring, disturbance signature
- **Summary:** Simulates and analyses the microvibration signature produced by reaction wheels
  with a view toward non-intrusive health monitoring — i.e. using the vibration signature itself
  as a diagnostic for wheel condition (bearing wear, imbalance drift, etc.) rather than requiring
  dedicated instrumentation.
- **Relevance to P4P:** Motivates the broader value of accurately measuring a wheel's disturbance
  signature (as the P4P device does) beyond one-off qualification — i.e. as a basis for future
  condition monitoring. Distilled in [[01_literature_review_microvibrations]].

### TRANSDUCER INERTIA AND STINGER STIFFNESS.pdf
- **Title:** Transducer inertia and stinger stiffness effects on FRF measurements
- **Authors/Year:** McConnell, K.G. and Cappa, P., 2000. *Mechanical Systems and Signal
  Processing*, 14(4), pp. 625-636.
- **Topic tags:** stinger/transducer design, modal testing, FRF measurement, force transducer,
  measurement error correction
- **Summary:** A classic modal-testing paper studying how force-transducer mass/inertia and
  stinger stiffness distort measured frequency response functions (FRFs), using a free-free beam
  test article and comparing impulse, chirp, and random excitation. Shows that stinger
  resonances (in this case ~675 Hz, well above the frequencies of interest) can still
  significantly shift and corrupt measured natural frequencies, and demonstrates a correction
  method that accounts for transducer mass/inertia and stinger stiffness to recover the true
  driving-point FRFs. Concludes chirp excitation gives the best overall coherence, and that a
  direct angular-acceleration measurement is preferable to computing angular FRFs by subtracting
  two closely-spaced linear FRFs (which amplifies noise).
- **Relevance to P4P:** Highly relevant — this is foundational stinger-based measurement theory
  directly applicable to the P4P stinger's own design: it quantifies how the stinger's own
  stiffness/mass and any attached transducer inertia can contaminate the force/moment
  measurements the device is meant to make, and gives a correction approach worth adopting or
  adapting. Not yet distilled into knowledge/ notes — recommended follow-up: fold correction
  approach into [[06_stinger_design_analysis]].

### The effect of assembly and static unbalance on reaction wheel assembly bearing harmonics.pdf
- **Title:** The effect of assembly and static unbalance on reaction wheel assembly bearing
  harmonics
- **Authors/Year:** Hodge, C., Stabile, A., Aglietti, G. and Richardson, G., 2021. *CEAS Space
  Journal*, 13, pp. 269-289.
- **Topic tags:** bearing harmonics, imbalance, experimental test rig, disturbance measurement,
  static unbalance
- **Summary:** Designs and validates a dedicated test rig (the "Kistler Bearing Test", KBT) that
  isolates bearing-harmonic disturbances from structural-mode and motor interference by using a
  very light disk-shaft assembly (raising resonances out of the frequency range of interest) and
  a decoupled motor. Using this rig, the authors study how RWA reassembly and static unbalance
  affect bearing-harmonic (ball-pass/cage-frequency) disturbance amplitudes. Key finding:
  reassembly alone causes large, largely unexplained variation in bearing-harmonic amplitudes
  between nominally identical builds, while deliberately varying static unbalance (within a
  normal range) has little effect on bearing-harmonic amplitudes — i.e. bearing disturbances and
  imbalance disturbances are largely decoupled in amplitude.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Directly relevant test-rig design
  precedent (isolating disturbance sources via a stiff/light dummy rotor and decoupled drive) and
  an important finding for interpreting P4P measurements: imbalance and bearing-harmonic
  disturbances should be treated as largely independent contributors, and reassembly-induced
  variability is a real confound to control for during testing.

### Zappalá_2018_Meas._Sci._Technol._29_065207.pdf
- **Title:** Non-intrusive torque measurement for rotating shafts using optical sensing of
  zebra-tapes
- **Authors/Year:** Zappalá, D., Bezziccheri, M., Crabtree, C.J. and Paone, N., 2018. *Measurement
  Science and Technology*, 29(6), 065207.
- **Topic tags:** torque measurement, non-intrusive measurement, optical sensing, zebra-tape,
  experimental method
- **Summary:** Presents a non-intrusive torque measurement method for rotating shafts based on
  optical sensing of reflective "zebra-tape" patterns attached to the shaft, using the phase/time
  shift between tape stripes under load-induced torsional deflection to infer torque without
  contact or slip-ring instrumentation.
- **Relevance to P4P:** An alternative, non-contact torque-measurement approach worth comparing
  against the project's stinger-based method — could be a candidate cross-check technique or an
  approach considered and rejected in the concept design. Distilled in
  [[03_literature_review_torque]].

### aas0104001-MicrovibrationAnalysisofaCantileverConfiguredReactionWheelAssembly-Published.pdf
- **Title:** Microvibration analysis of a cantilever configured reaction wheel assembly
- **Authors/Year:** Zhang, Z., Aglietti, G.S., Ren, W. and Addari, D., 2014. *Advances in
  Aircraft and Spacecraft Science*, 1(4), pp. 379-398.
- **Topic tags:** microvibration, cantilevered RWA, FEA/modal, disturbance model
- **Summary:** Extends the Zhang/Aglietti group's cantilevered reaction wheel microvibration
  modelling work, analysing how the cantilever (overhung, asymmetric) mounting configuration
  affects the wheel's disturbance forces/moments and structural dynamics compared to a symmetric
  mounting, with supporting FEA/modal analysis.
- **Relevance to P4P:** Relevant if the target RWA(s) for the P4P device use a cantilevered
  configuration — provides expected mode shapes/disturbance characteristics to sanity-check
  measured data against. Distilled in [[01_literature_review_microvibrations]].

### addari-et-al-2016-dynamic-mass-of-a-reaction-wheel-including-gyroscopic-effects-an-experimental-approach.pdf
- **Title:** Dynamic mass of a reaction wheel including gyroscopic effects: an experimental
  approach
- **Authors/Year:** Addari, D., Aglietti, G.S. and Remedia, M., 2017 (filename references 2016).
  *AIAA Journal*, 55(1), pp. 274-285.
- **Topic tags:** gyroscopic effects, dynamic mass, experimental method, cantilevered RWA
- **Summary:** Presents an experimental method for characterising the "dynamic mass" (frequency-
  and speed-dependent effective inertial/stiffness behaviour) of a reaction wheel, explicitly
  accounting for gyroscopic coupling effects that arise once the wheel is spinning, and validates
  the approach against test data.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Relevant experimental methodology
  for how a spinning wheel's dynamic response (as would be seen through the stinger interface)
  changes with speed due to gyroscopic coupling — directly applicable to interpreting P4P test
  data taken across a range of wheel speeds.

### microvibrations-induced-by-a-cantilevered-wheel-assembly-with-a-soft-suspension-system.pdf
- **Title:** Microvibrations induced by a cantilevered wheel assembly with a soft-suspension
  system
- **Authors/Year:** Zhang, Z., Aglietti, G.S. and Zhou, W., 2011. *AIAA Journal*, 49(5), pp.
  1067-1079.
- **Topic tags:** microvibration, cantilevered RWA, soft suspension, disturbance model
- **Summary:** An earlier paper in the Zhang/Aglietti cantilevered-RWA series, investigating
  microvibrations induced by a cantilever-configured wheel assembly mounted on a soft suspension
  system, characterising how the suspension compliance modifies the transmitted disturbance
  forces/moments relative to a rigidly-mounted wheel.
- **Relevance to P4P:** Not yet distilled into knowledge/ notes. Relevant if the P4P test setup or
  target application involves a compliant/isolated wheel mount — informs expectations for how
  suspension compliance changes measured disturbance transmission compared to a rigid mount.

### validationofRWdisturbancemodel.pdf
- **Title:** Development and validation of reaction wheel disturbance models: empirical model
- **Authors/Year:** Masterson, R.A., Miller, D.W. and Grogan, R.L., 2002. *Journal of Sound and
  Vibration*, 249(3), pp. 575-598.
- **Topic tags:** disturbance model, empirical model, experimental validation, microvibration
- **Summary:** Develops and validates the widely-cited Masterson empirical reaction wheel
  disturbance model, which represents wheel disturbance forces/moments as a set of harmonic
  components (tied to wheel speed) with amplitudes fit from measured data, rather than a purely
  first-principles physical model. Validates the empirical model's predictive accuracy against
  measured disturbance data across operating speeds.
- **Relevance to P4P:** Foundational disturbance-model reference for the whole field; the
  empirical harmonic-amplitude approach is a natural benchmark/structure against which P4P's own
  measured disturbance data and any derived model could be compared. Distilled (as "the Masterson
  empirical model") in [[01_literature_review_microvibrations]].
