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
- **Update 15 Oct (3):** the user gave the rig parts list and said the TAS510s were technician-calibrated, which resolves the handoff's slope flag. The rig cost is not cleanly definable because most of it is lab equipment. Replaced the handoff-based equipment list in `knowledge/11_commercial_system_cost.md` with the user's parts table: 2 × PCB 208C01, 1 × 208C02, 3 × TAS510-10kg, cDAQ-9174, NI 9232/9237, isolation table, 3 × Bunnings B68 L-brackets modified in-house, CNC aluminium plate, 3 × 0.8 mm and 3 × 1.2 mm × 100 mm piano-wire stingers, fasteners. Flagged that "NI 9237" was listed twice (assumed 9232 + 9237), and that the 100 mm stinger length differs from the ~95 mm recorded in `knowledge/10`. Not committed.
- **Update 15 Oct (4):** the user confirmed the modules are NI 9232 + NI 9237, and that the stingers are 100 mm piano wire with 2.5 mm at each end inside the bolts they are welded into, giving a 95 mm free length. This matches `knowledge/10`; updated the parts table and footnotes.
