# 2026-10-16 — Poster wording fixes and PDF re-export

- **Context:** a new session took over poster edits from the "P4P display-day poster" session, whose context had grown too large. The user had opened the static `P4P_Poster_final.html` in Chrome and thought the poster could no longer be edited. Both poster `INDEX.md` files now point to the Design canvas (https://claude.ai/artifact/J6RDx5nry4oxH4g8hwDx4R) for editing.
- **User's own canvas edits** (15–16 Oct):
  - rig legend: "RWA housing" and "CNC aluminium plate", with no masses; label 6 moved;
  - "sideways" changed to "laterally";
  - "Stiffen the system": target now f_n > 250 Hz, and pre-tensioned wires removed;
  - static calibration line: "(301.5 g mass)" removed, "axial forces";
  - What We Achieved: rig cost and "10× cheaper" removed, "no tachometer" removed.
- **Asked and did:**
  - What We Achieved now gives the 250 Hz target, matching Next Steps.
  - "?known?" replaced: the baseline wheel "has a small, measured residual imbalance". This was shortened after a test render showed the longer wording pushed How It Works past its panel.
  - Compliance bullet removed from What We Achieved.
  - "RWA casing" changed back to "RWA housing", matching the photo caption.
  - Re-exported `P4P_Poster_final.html`, `.pdf` (1 page, 84.1 × 59.4 cm) and `_preview.png`. The figures are unchanged (byte-identical to the previous `poster_assets`).
- **Export method:** the old session's `export.py` turns the canvas `Main.dc.html` into the standalone HTML, mapping the `/_blob/` ids to `poster_assets/`. Headless Chrome then prints the PDF (`--print-to-pdf --no-pdf-header-footer`) and screenshots the preview at 3178×2246. Both the script and the source figures (`figs5/`, `poster/img/`) are in session scratchpads, not in this repo.
- **Notes:** "Low-Cost" stays in the title and the commercial NZ$130–300k+ stays in the Intro, but the rig's own cost (≈NZ$15–20k) is no longer on the poster. That was the user's choice; have the figure ready to say aloud.
