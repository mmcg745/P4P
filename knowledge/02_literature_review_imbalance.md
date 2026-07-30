# Literature Review — Rotor Imbalance Theory & Measurement

Part of [[00_project_overview]]. References in [[09_references]]. See also
[[01_literature_review_microvibrations]], [[03_literature_review_torque]].

## Imbalance Definitions and Theory (ISO 1940-1)

Two fundamental imbalance types:

- **Static imbalance** `Us` [g·mm]: parallel offset between rotation axis and principal inertia
  axis — centre of mass doesn't coincide with the geometric centre.
  `Us = m · ε` (m = rotor mass, ε = eccentricity of CoM from spin axis).
  Generates a **net radial force** at spin frequency, identifiable from a **single measurement plane**.

- **Dynamic imbalance** `Ud` [g·mm²]: angular misalignment between rotation axis and principal
  inertia axis — CoM coincides with geometric centre, but mass distribution along spin axis is
  asymmetric. `Ud = Iz · χ` (Iz = moment of inertia about spin axis, χ = tilt angle, mrad)
  (De Munter et al., 2020).
  Generates a **couple** (equal/opposite forces, axially separated) — requires measurement at
  **minimum two axially separated planes** to resolve.

**Design implication (fundamental):** a device with transducers at only one axial height *cannot*
distinguish dynamic imbalance from static imbalance. De Munter et al. (2020) formalise correction
mass equations for two correction planes A, B at heights hA, hB from the CoM plane.

- **Balance quality grades** (ISO 1940-1): for gyroscopic devices (most analogous to RWAs),
  G = 0.4 mm/s → max tolerated eccentricity of 0.5 µm at 10,000 rpm. De Munter et al. (2020) note
  this is extremely challenging with standard affordable balancing equipment — explains why
  practical CubeSat RWA balancing falls short of this target.

## Imbalance Measurement Methods and Results

- **Kinematic approach**: accelerometers mounted on the rotor.
- **Dynamic approach**: force dynamometer beneath the assembly — unbalance vector magnitude from
  force signal amplitude at spin frequency; angular phase from optical encoder referenced to a
  fixed rotor mark.

### De Munter et al. (2020) — KU Leuven CubeSat RWA balancing prototype

- Method: RWA mounted on Kistler dynamometer + optical encoder for phase.
- Results: **83% reduction in static imbalance**, only **23% reduction in dynamic imbalance**.
- Poor dynamic result attributed to: insufficient wheel speed stability (speed controller couldn't
  hold constant speed → inconsistent phase measurements), inadequate phase resolution at higher
  speeds.
- Identified improvements (= direct design targets for this project's device): finer wheel speed
  control, multiple measurements at different speeds for statistical accuracy, higher phase
  resolution processing, integrating correction setup with measurement setup to reduce
  disconnection steps.
- This is the **most directly relevant precedent** — an explicit attempt to combine microvibration
  measurement and imbalance correction in one device, but severely limited on dynamic imbalance
  accuracy, and has **no torque measurement**.

### Rocket Lab production balancing (Wade et al., 2023)

- Fully automated: measures imbalance → calculates required material removal → performs removal →
  iterates until spec met.
- Confirms importance of the measurement-correction iteration loop, but is a proprietary
  production-line solution, not a general-purpose research instrument.

## Summary / Gap

Existing devices show measurable limitations in dynamic imbalance accuracy and lack torque
measurement capability — this motivates the two-measurement-plane, tachometer-integrated approach
in this project (see [[04_concept_design]] and [[05_mathematical_model]]).

Note: the current (mid-year) single-plane platform design has **not yet resolved dynamic imbalance**
— see the "Dynamic Imbalance — Limitation" section in [[05_mathematical_model]].
