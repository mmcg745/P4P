# 2026-10-14 — Research: cost of a commercial RWA microvibration system

- **Asked:** check whether the "$100,000+" cost quoted for an aerospace-grade system is an underestimate, and keep references for the report and poster.
- **Did:** web research; Kistler publishes no prices, so the cost was built up from published sources:
  - Totis et al. 2025: Kistler MiniDyn class €30–60k;
  - KU Leuven setup (De Munter et al. 2018): 9119AA1 MiniDyn, 5070A amplifier, LMS DAQ, Newport RS2000 air table;
  - Kistler 9236A datasheet: 8 outputs, needs a 5080A amplifier;
  - Thorlabs active isolators US$15,990;
  - NI cDAQ and module list prices;
  - ESA ITT AO8840: €200–500k.

  Wrote `knowledge/11_commercial_system_cost.md` with the cost table, suggested wording and IEEE references. Added it to `knowledge/README.md` and the references to `09_references.md`.
- **Result:** "upwards of NZ$100k" is defensible but conservative. It roughly covers the dynamometer and amplifiers only; a full lab setup is ≈NZ$130k–300k+.
- **Notes:** no direct Kistler quote was found; worth requesting one. The ≈US$77k Newport table PO came from a search snippet only and is unverified. The poster text is unchanged; the user decides the wording. `09_references.md` already had duplicated Zappalá/Zhang entries at the end, left as is.
- **Update 15 Oct:** the user confirmed (via the report chat) that the rig is mounted on a vibration isolation table. Added a note to `knowledge/11_commercial_system_cost.md`: isolation and DAQ are common to both approaches, so the like-for-like saving is the sensing chain (dynamometer + charge amplifier against load cells, ICP sensors and stingers).
- **Update 15 Oct (2):** from a pasted equipment handoff, added the rig's own equipment list to `knowledge/11_commercial_system_cost.md`: cDAQ-9174, NI 9232 + PCB 208C01/01/02, NI 9237 + 3 × NI 9949 + 3 × TAS510, FlexLogger, and the mechanics. This is for the rig-cost comparison. Committed the knowledge and log changes.
