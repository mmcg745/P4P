# 2026-07-30 — Add Check 5 to the stinger optimisation loop

- **Asked:** Ran `stinger_design_V3.m` and reviewed console output (all 5 checks pass at
  d=2mm axial/L=100mm, radial L=50mm; optimisation sweep found 23,310/230,400 feasible
  combinations up to L=175mm). Then asked to include the new transducer-inertia/stinger
  resonance check (Check 5) in the optimisation loop, which previously only enforced the
  original four checks.
- **Did:**
  - Added `fn_comb_ax_i`/`fn_comb_rad_i` calculations and `pass_fn5_ax`/`pass_fn5_rad` targets
    inside the sweep loop in `stinger_design_V3.m`, folded into `all_pass_i`.
  - Extended the `results` matrix with two new columns (`fn_comb_ax`, `fn_comb_rad`) and updated
    the top-10 table header/rows and "best combination" printout to show them.
  - Re-ran the script to confirm no errors and that the feasible-combination count is unchanged
    (23,310/230,400) — Check 5 isn't a binding constraint at the placeholder 5 g transducer mass
    over the current diameter/length sweep range, but is now correctly enforced and reported.
- **Notes:** Not yet committed/pushed — awaiting explicit go-ahead per session convention. Same
  `m_transducer` placeholder caveat as the main Check 5 addition applies here (see
  [[06_stinger_design_analysis]]).
