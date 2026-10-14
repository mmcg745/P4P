# Cost of a commercial (aerospace-grade) RWA microvibration measurement system

Part of [[00_project_overview]] and [[01_literature_review_microvibrations]]. This note backs up
the poster and report claim that a commercial system costs "upwards of NZ$100k". Researched
14 Oct 2026; the references are at the bottom.

## Bottom line

**"Upwards of NZ$100k" is defensible but conservative.** It roughly covers the dynamometer and its
charge amplifiers alone. A complete working setup also needs vibration isolation, a DAQ, cabling,
software and calibration, which puts it at **≈NZ$130k–300k+**. Dedicated space-agency facilities
are tendered at **€200–500k (≈NZ$0.4–1.0M)**.

Kistler, the de facto standard supplier, does not publish prices: every dynamometer and charge
amplifier on its site is "price on request". The figures below are therefore assembled from
published papers, list prices of supporting equipment, and an ESA tender, not from a vendor quote.

## What a commercial system consists of

The setup published for RWA microvibration testing at KU Leuven [1] is typical:
- Kistler **9119AA1 MiniDyn** six-component piezoelectric dynamometer;
- Kistler **5070A** multichannel charge amplifier;
- LMS (Siemens) acquisition system;
- **Newport RS2000 air (optical) table** to isolate seismic noise below 10 Hz.

Kistler's dedicated microvibration dynamometer, the **9236A**, is marketed for reaction wheel,
microvibration and cryocooler testing [2]. Its datasheet [2] gives:
- a 260 × 260 mm or 400 × 400 mm ceramic top plate;
- a mass of 31.5 or 72 kg;
- **8 charge outputs**, with the noise figures quoted using the **Type 5080A** charge amplifier
  (1–8 channels).

Agency facilities add a seismic block and pneumatic or active isolation. CSEM uses a granite block
on pneumatic isolators [3]. ESA's Reaction Wheel Characterisation Facility (2009/10) and its newer
MMCF also use Kistler sensors [4].

## Cost build-up (approximate; NZD at ≈1.95 NZD/EUR and ≈1.70 NZD/USD; check current rates)

| Item | Evidence | Approx. cost |
|---|---|---|
| 6-axis piezo dynamometer + charge amplifiers + cables (MiniDyn class) | High-end piezo load cell + amp + cable ≈ **€2,500 per channel**. A Kistler MiniDyn's 12 channels ≈ **€30k** for the sensing chain alone, and "the complete commercial device … costs at least twice as much", so **€30–60k** [5] | NZ$60–120k |
| Microvibration-grade dynamometer (9236A) | Larger ceramic-plate design calibrated in 6 components [2]. No public price; likely at or above the MiniDyn figure (inference) | ≥ NZ$60–120k |
| Vibration isolation (optical table + isolators) | Thorlabs active isolator supports alone, set of 4: **US$15,990** (older catalogue) [6]. A Newport RS2000 custom table system bought by a US university in 2023 cost ≈US$77k (seen in a search snippet only; the source PDF is no longer online, so unverified) | NZ$30–130k |
| DAQ | NI cDAQ-9178 chassis **US$2,350**; NI 9234 4-channel IEPE/AC module **US$3,717** each, 2 needed for 6–8 channels [7] | ≈NZ$17k |
| Software, calibration, shipping, installation | Not quantified; Kistler calibration is "in 6 components" [2] and is periodic | + |
| **Total (university lab level)** | | **≈NZ$130k–300k+** |
| Agency facility (reference point) | ESA ITT AO8840 (2016): versatile 6-DoF micro-vibration measurement/excitation stage, price range **€200–500k** [8] | ≈NZ$0.4–1.0M |

## This rig's parts list (user, 15 Oct 2026)

The rig's cost can't be cleanly defined. It was built mostly from equipment already available in
the university lab, so there is no single purchase price to quote. Parts list:

| Function | Part | Qty |
|---|---|---|
| Radial force sensors (Rx1, Rx2) | PCB 208C01 ICP force sensor | 2 |
| Radial force sensor (Ry1) | PCB 208C02 ICP force sensor | 1 |
| Axial load cells (Az1–Az3) | TAS510 10 kg strain-gauge load cell (technician-calibrated) | 3 |
| DAQ chassis | NI cDAQ-9174 (4-slot USB, shared backplane clock) | 1 |
| Radial DAQ module | NI 9232 (3-ch IEPE, 24-bit, AC-coupled) | 1 |
| Axial DAQ module | NI 9237 (4-ch bridge, 10 V excitation), via NI 9949 RJ50 adapters | 1 |
| Vibration isolation | Isolation table (lab equipment) | 1 |
| Radial brackets | Off-the-shelf B68 L-brackets from Bunnings, cut down and drilled in-house | 3 |
| Mounting plate | CNC-machined aluminium plate | 1 |
| Radial stingers | 0.8 mm dia × 100 mm piano wire (95 mm free length)² | 3 |
| Axial stingers | 1.2 mm dia × 100 mm piano wire (95 mm free length)² | 3 |
| Fasteners | Various nuts and bolts | — |

Also used: NI FlexLogger (logging at 10 kHz, TDMS and CSV) and MATLAB analysis
(`analyze_rwa_campbell.m`). The test article is a Prusa NEMA17 stepper with a Tic T500 driver and
a 3D-printed test wheel with bolt masses. That is the "RWA" under test, not part of the
measurement device.

² Each wire is cut to 100 mm. Its 2.5 mm ends sit inside the bolts they are welded into, so
the free (effective) length is 95 mm, which is the value used in [[10_experimental_results]]
(confirmed by the user, 15 Oct).

The sensors (2 × 208C01, 1 × 208C02, 3 × TAS510) and the bracket and stinger hardware are the
parts specific to this design. The DAQ, isolation table and software would be needed by a
commercial dynamometer as well.

The rig is also mounted on a **vibration isolation table** (confirmed 15 Oct), just as the
KU Leuven setup uses an air table [1]. Isolation and DAQ are therefore common to both approaches.
The like-for-like saving is in the **sensing chain**: a calibrated 6-axis piezo dynamometer plus
its charge amplifier (€30–60k+, [5]) against single-axis load cells and ICP sensors on wire
stingers. State this when quoting the saving, so the comparison isn't accused of leaving out the
isolation table.

## Suggested wording

- **Poster:** "Commercial six-axis microvibration dynamometer systems cost well over NZ$100k once
  charge amplifiers, isolation and DAQ are included [5–7], and agency facilities are tendered at
  €200–500k [8]." Shorter: "Commercial systems cost NZ$100k–300k+ [5–8]."
- **Report:** use the table above, state that Kistler pricing is quote-only, and give the
  exchange-rate assumption.

## Caveats

- No direct Kistler quote was found. A real quote (Kistler NZ/AU sales, or via the department)
  would be the strongest source and is worth requesting for the report.
- Totis et al. [5] price a machining MiniDyn, not a microvibration 9236A. The 9236A is larger and
  more specialised, so treating €30–60k as a lower bound is reasonable but is an inference.
- A used Kistler 9272 (machining, four-component) was listed on eBay for US$2,700. Used machining
  dynamometers are not representative of a calibrated microvibration system, so this was not used.
- The ESA figure is a tender price band (2016) for a facility-scale stage, not a purchase price.

## References (IEEE style)

[1] W. De Munter, T. Delabie and D. Vandepitte, "Characterization of reaction wheel
micro-vibrations," in *Proc. ISMA2018 and USD2018*, Leuven, Belgium, 2018, pp. 3511–3526.
[Online]. Available: https://past.isma-isaac.be/downloads/isma2018/proceedings/Contribution_609_proceeding_3.pdf

[2] Kistler Group, "Microvibration Dynamometer Type 9236A1, 9236A2, –500 … 500 N, ceramic top
plate," datasheet 9236A_003-460e-07.25, Winterthur, Switzerland, 2025. [Online]. Available:
https://kistler.cdn.celum.cloud/SAPCommerce_Download_original/003-460e.pdf

[3] Kistler Group, "Kistler supports development of innovative space technology test equipment at
CSEM." [Online]. Available: https://www.kistler.com/INT/en/kistler-supports-development-of-innovative-space-technology-test-equipment-at-csem/C00000505
(accessed Oct. 14, 2026).

[4] Kistler Group, "Space mechanisms: ESA's new micro-vibration test facility leads the way thanks
to Kistler sensors." [Online]. Available: https://www.kistler.com/AT/en/space-mechanisms-esa-s-new-micro-vibration-test-facility-leads-the-way-thanks-to-kistler-sensors/C00000889
(accessed Oct. 14, 2026).

[5] G. Totis, A. Bordon, F. Scalzo and M. Sortino, "Bridging cost and performance in cutting force
measurement: A PVDF-based universal plate dynamometer," *Sensors*, vol. 25, no. 21, Art. no. 6645,
2025, doi: 10.3390/s25216645.

[6] Thorlabs Inc., "Active isolation supports (NTS502 series), set of 4," product catalogue page.
[Online]. Available: https://www.thorlabs.com/catalogpages/v20/66.pdf (accessed Oct. 14, 2026).

[7] National Instruments, "cDAQ-9178 CompactDAQ chassis" and "NI 9234 C Series sound and vibration
input module," online store. [Online]. Available: https://www.ni.com/en-us/support/model.cdaq-9178.html
and https://www.ni.com/en/shop/hardware/sound-and-vibration/model-ni-9234 (accessed Oct. 14, 2026).

[8] European Space Agency, "Micro-vibration measurement and excitation platform for big specimen,"
Open Invitation to Tender AO8840, ref. 16.126.01, ESTEC, issued Dec. 20, 2016, price range
200–500 kEUR. Listed by the Romanian Space Agency. [Online]. Available:
https://rosa.ro/micro-vibration-measurement-and-excitation-platform-for-big-specimen-2/
(accessed Oct. 14, 2026).
