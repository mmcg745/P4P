# Project Overview

**Title:** Development of a Unified Microvibration and Torque Measurement Device for Reaction Wheel Assemblies (RWAs)

- **Author:** Matthew McGill (102344439)
- **Project Partner:** Brodie Cruse
- **Supervisor:** Dr Guglielmo Aglietti
- **Course:** MECHENG 700A/B: Research Project
- **Department:** Mechanical Engineering, University of Auckland
- **Timeline:** Two semesters, March–October 2026

## Problem Statement

Reaction Wheel Assemblies are the primary attitude control actuators on modern satellites and the
dominant source of microvibration disturbances on board spacecraft. These disturbances — arising
from rotor mass imbalance, bearing irregularities, and motor torque ripple — transmit through the
satellite structure to precision payloads, degrading pointing stability. Accurate characterisation of
RWA disturbances requires *simultaneous* measurement of microvibration forces, static/dynamic rotor
imbalance, and actuation torque, but no existing device integrates all three. This project designs,
analyses, and physically realises a unified measurement device that does.

## Project Scope

- Single measurement device for **small-scale RWAs**.
- Measures: microvibration disturbance forces, static & dynamic rotor imbalance, actuation torque
  (spin-up/operation).
- Specific RWA unit confirmed during concept design phase.
- Full engineering cycle: literature review → state-of-the-art survey → concept design → detailed
  design/analysis → mathematical modelling → proof-of-concept hardware.
- Uses force transducers + indirect torque measurement (tachometer-based, T = Iα).
- DAQ and essential equipment provided by the university.
- **Out of scope:** in-orbit validation, integration with a complete satellite system. Ground-based
  lab testing only, against a representative small-scale RWA.

## Research Objectives

1. **State of the Art Survey** — review RWA microvibration measurement, rotor imbalance theory/balancing
   practice, torque measurement techniques; identify limitations and benchmarks.
2. **Concept Design** — develop/compare multiple concepts (transducer configuration, measurement
   plane geometry, structural arrangement, signal processing); select preferred concept.
3. **Detailed Design and Analysis** — mechanical + instrumentation design: optimal axial placement
   of force transducers (static + dynamic imbalance resolution), sensor spec selection, tachometer
   integration for indirect torque.
4. **Mathematical Modelling** — model relating measured force signals, imbalance parameters, and
   derived torque; predicts performance pre-fabrication.
5. **Proof-of-Concept Hardware** — fabricate/assemble using university facilities; test with a
   small-scale RWA.
6. **Experimental Validation and Reporting** — validate against Objective 1 targets, analyse
   measurement uncertainty, compare to literature benchmarks, document in final report.

## Why This Matters (Research Relevance)

- Earth observation satellites, space telescopes, optical comms systems all need pointing stability
  that RWA microvibrations compromise.
- Surrey Satellite Technology Ltd found uncharacterised disturbances between 50–250 Hz caused visible
  image degradation on a 1m resolution EO spacecraft (Smet et al., 2013).
- Current practice needs *separate* instruments/procedures for microvibration testing, imbalance
  measurement, and torque verification — increasing cost/complexity/time per RWA qualified.
- Commercial RWA production is scaling fast (Rocket Lab targeting thousands of units/year — Wade et
  al., 2023), amplifying the need for efficient, accurate, accessible measurement solutions.

See also: [[01_literature_review_microvibrations]], [[02_literature_review_imbalance]],
[[03_literature_review_torque]], [[04_concept_design]], [[05_mathematical_model]],
[[06_stinger_design_analysis]], [[07_finite_element_analysis]], [[08_next_steps]],
[[09_references]].
