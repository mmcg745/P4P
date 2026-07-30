import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

mpl.rcParams.update({
    "figure.dpi": 140,
    "savefig.dpi": 140,
    "font.size": 10.5,
    "axes.titlesize": 12,
    "axes.titleweight": "bold",
    "axes.grid": True,
    "grid.alpha": 0.3,
})

OUT = "/mnt/user-data/outputs"

# -------------------------------------------------------------------------
# 1. FEA modal data (from the .xls exports in the repo)
# -------------------------------------------------------------------------
fea = {
    # label: (frequencies mode1..10)
    "50x50, d=1.6": [279.70, 325.89, 592.80, 742.66, 801.25, 842.54, 1828.3, 1957.8, 1975.5, 2661.5],
    "50x50, d=1.8": [306.03, 354.58, 650.84, 817.44, 869.83, 919.67, 1837.5, 1962.7, 1982.1, 2722.1],
    "50x50, d=2.0": [330.38, 380.70, 704.95, 887.71, 930.93, 989.97, 1847.2, 1965.1, 1988.0, 2747.3],
    "50x50, d=2.2": [352.93, 404.41, 755.31, 953.60, 985.51, 1054.2, 1857.3, 1968.6, 1994.1, 2771.6],
    "52.5x52.5, d=2.0": [323.52, 373.89, 692.71, 869.40, 911.04, 969.86, 1843.1, 1964.2, 1985.2, 2733.3],
    "55x55, d=2.0": [316.95, 367.45, 681.25, 852.22, 892.17, 950.92, 1839.3, 1962.9, 1982.8, 2677.9],
    "75x75, d=2.0": [276.54, 326.04, 605.88, 743.81, 774.76, 831.66, 1504.9, 1506.1, 1507.3, 1508.5],
    "A80xR50, d=2.0": [295.55, 336.51, 591.87, 761.69, 861.03, 876.84, 1331.3, 1332.4, 1334.3, 1335.4],
    "A100xR50, d=2.0": [277.42, 314.48, 540.77, 701.72, 810.36, 818.35, 860.98, 861.95, 862.88, 867.15],
}

# metadata: (L_axial, L_radial, d_axial, d_radial) mm  — "50x50" etc means both stinger lengths equal
meta = {
    "50x50, d=1.6": dict(L_ax=50, L_rad=50, d=1.6, study="diameter"),
    "50x50, d=1.8": dict(L_ax=50, L_rad=50, d=1.8, study="diameter"),
    "50x50, d=2.0": dict(L_ax=50, L_rad=50, d=2.0, study="diameter"),
    "50x50, d=2.2": dict(L_ax=50, L_rad=50, d=2.2, study="diameter"),
    "52.5x52.5, d=2.0": dict(L_ax=52.5, L_rad=52.5, d=2.0, study="length_both"),
    "55x55, d=2.0": dict(L_ax=55, L_rad=55, d=2.0, study="length_both"),
    "75x75, d=2.0": dict(L_ax=75, L_rad=75, d=2.0, study="length_both"),
    "A80xR50, d=2.0": dict(L_ax=80, L_rad=50, d=2.0, study="length_axial"),
    "A100xR50, d=2.0": dict(L_ax=100, L_rad=50, d=2.0, study="length_axial"),
}

fn_target = 500.0
mode_colors = ["#d81a1a", "#e6730a", "#2673cc", "#1a9e4d", "#8c2ec9", "#00a0a0"]

# -------------------------------------------------------------------------
# PLOT 1 — All-design comparison: Modes 1 & 2 vs target, sorted
#   (replaces having to read 3 separate line-plots to compare configs)
# -------------------------------------------------------------------------
labels = list(fea.keys())
m1 = np.array([fea[k][0] for k in labels])
m2 = np.array([fea[k][1] for k in labels])
order = np.argsort(m1)[::-1]
labels_s = [labels[i] for i in order]
m1_s, m2_s = m1[order], m2[order]

fig, ax = plt.subplots(figsize=(9.5, 5.5))
y = np.arange(len(labels_s))
h = 0.35
ax.barh(y + h/2, m1_s, height=h, color="#d81a1a", label="Mode 1 (lateral X)")
ax.barh(y - h/2, m2_s, height=h, color="#e6730a", label="Mode 2 (lateral Y)")
ax.axvline(fn_target, color="k", ls="--", lw=1.6, label="Target: 500 Hz")
ax.set_yticks(y)
ax.set_yticklabels(labels_s)
ax.set_xlabel("Natural frequency [Hz]")
ax.set_title("All FEA Configurations Ranked by Mode 1 Frequency")
ax.legend(loc="lower right", framealpha=0.9)
for yi, v1, v2 in zip(y, m1_s, m2_s):
    ax.text(v1 + 8, yi + h/2, f"{v1:.0f}", va="center", fontsize=8)
    ax.text(v2 + 8, yi - h/2, f"{v2:.0f}", va="center", fontsize=8)
ax.set_xlim(0, max(m1.max(), m2.max()) * 1.15)
fig.tight_layout()
fig.savefig(f"{OUT}/1_all_configs_ranked.png")
plt.close(fig)

# -------------------------------------------------------------------------
# PLOT 2 — Gap-to-target chart: how far every design is from passing
# -------------------------------------------------------------------------
gap1 = m1_s - fn_target
gap2 = m2_s - fn_target
fig, ax = plt.subplots(figsize=(9, 5.5))
ax.barh(y + h/2, gap1, height=h, color=["#2e9e4d" if v >= 0 else "#d81a1a" for v in gap1])
ax.barh(y - h/2, gap2, height=h, color=["#2e9e4d" if v >= 0 else "#e6730a" for v in gap2],
        alpha=0.6, hatch="//")
ax.axvline(0, color="k", lw=1.2)
ax.set_yticks(y); ax.set_yticklabels(labels_s)
ax.set_xlabel("Margin to 500 Hz target [Hz]  (negative = fails)")
ax.set_title("Design Margin Against the 500 Hz Target — Modes 1 & 2")
from matplotlib.patches import Patch
ax.legend(handles=[Patch(facecolor="#2e9e4d", label="Pass"),
                    Patch(facecolor="#d81a1a", label="Fail (Mode 1)"),
                    Patch(facecolor="#e6730a", alpha=0.6, hatch="//", label="Fail (Mode 2, hatched)")],
          loc="lower right", framealpha=0.9)
fig.tight_layout()
fig.savefig(f"{OUT}/2_margin_to_target.png")
plt.close(fig)

# -------------------------------------------------------------------------
# PLOT 3 — Sensitivity / tornado chart: effect of each geometric change
#   relative to the 50x50x2mm baseline, for Mode 1
# -------------------------------------------------------------------------
base = fea["50x50, d=2.0"][0]
deltas = {
    "d: 2.0 -> 1.6 mm (-20%)": fea["50x50, d=1.6"][0] - base,
    "d: 2.0 -> 1.8 mm (-10%)": fea["50x50, d=1.8"][0] - base,
    "d: 2.0 -> 2.2 mm (+10%)": fea["50x50, d=2.2"][0] - base,
    "L(both): 50 -> 52.5 mm (+5%)": fea["52.5x52.5, d=2.0"][0] - base,
    "L(both): 50 -> 55 mm (+10%)": fea["55x55, d=2.0"][0] - base,
    "L(both): 50 -> 75 mm (+50%)": fea["75x75, d=2.0"][0] - base,
    "L_axial only: 50 -> 80 mm": fea["A80xR50, d=2.0"][0] - base,
    "L_axial only: 50 -> 100 mm": fea["A100xR50, d=2.0"][0] - base,
}
items = sorted(deltas.items(), key=lambda kv: kv[1])
labs = [k for k, v in items]
vals = [v for k, v in items]
fig, ax = plt.subplots(figsize=(9, 5))
colors = ["#2e9e4d" if v >= 0 else "#d81a1a" for v in vals]
ax.barh(labs, vals, color=colors)
ax.axvline(0, color="k", lw=1)
ax.set_xlabel(f"Change in Mode 1 frequency vs 50x50 mm, d=2.0 mm baseline ({base:.0f} Hz)  [Hz]")
ax.set_title("Sensitivity of Mode 1 to Individual Geometry Changes")
fig.tight_layout()
fig.savefig(f"{OUT}/3_sensitivity_tornado.png")
plt.close(fig)

# -------------------------------------------------------------------------
# PLOT 4 — Mode spectrum "fingerprint" per design (modes 1-10), small multiples
#   highlights how frame modes (7-10) collapse together for larger plate sizes
#   -> reveals coupling that single-mode line plots hide
# -------------------------------------------------------------------------
fig, axes = plt.subplots(3, 3, figsize=(12, 9), sharex=True)
for ax, k in zip(axes.flat, labels):
    freqs = fea[k]
    modes = np.arange(1, 11)
    colors_here = ["#d81a1a" if f < fn_target else "#2e9e4d" for f in freqs[:2]] + ["#888"] * 8
    ax.bar(modes, freqs, color=(["#d81a1a" if f < fn_target else "#2e9e4d" for f in freqs[:2]] + ["#5b8dd6"] * 4 + ["#b0b0b0"] * 4))
    ax.axhline(fn_target, color="k", ls="--", lw=1)
    ax.set_title(k, fontsize=9.5)
    ax.set_yscale("log")
    ax.set_ylim(200, 4000)
for ax in axes[-1, :]:
    ax.set_xlabel("Mode #")
for ax in axes[:, 0]:
    ax.set_ylabel("Freq [Hz] (log)")
fig.suptitle("Modal Spectrum Fingerprint per Configuration (modes 1–10)", fontweight="bold")
fig.tight_layout(rect=[0, 0, 1, 0.96])
fig.savefig(f"{OUT}/4_modal_fingerprints.png")
plt.close(fig)

# -------------------------------------------------------------------------
# Analytical model (ported from stinger_design_V3.m) for continuous sweeps
# -------------------------------------------------------------------------
E = 200e9
m_total = 1.2  # kg, m_RWA + m_plate default from script

def fn_axial_analytic(d, L):
    A = np.pi * d**2 / 4
    k_total = 3 * E * A / L
    return (1 / (2 * np.pi)) * np.sqrt(k_total / m_total)

def buckling_SF(d, L, F_applied):
    I = np.pi * d**4 / 64
    F_crit = np.pi**2 * E * I / L**2
    return F_crit / F_applied

# rough applied load estimate consistent with the .m script defaults
Us_max = 26e-6
Omega_max = 3000 * 2 * np.pi / 60
F_radial_max = Us_max * Omega_max**2
h_eff = 0.075
R_triangle = 0.05
F_static_each = (m_total * 9.81) / 3
F_axial_dyn = (F_radial_max * h_eff) / (R_triangle * np.sqrt(3))
F_axial_max = F_static_each + F_axial_dyn

# -------------------------------------------------------------------------
# PLOT 5 — Design-space contour: Mode-1 fn(d, L) with feasible region shaded
#   Much richer than the original single-variable subplot (fixes L, sweeps d only)
# -------------------------------------------------------------------------
d_range = np.linspace(1.0, 4.0, 200) * 1e-3
L_range = np.linspace(0.03, 0.15, 200)
D, L = np.meshgrid(d_range, L_range)
FN = fn_axial_analytic(D, L)
SF = buckling_SF(D, L, F_axial_max)

fig, ax = plt.subplots(figsize=(8.5, 6.5))
cs = ax.contourf(D * 1000, L * 1000, FN, levels=30, cmap="viridis")
cbar = fig.colorbar(cs, ax=ax)
cbar.set_label("Mode 1 (axial) natural frequency [Hz]")
target_line = ax.contour(D * 1000, L * 1000, FN, levels=[fn_target], colors="red", linewidths=2)
ax.clabel(target_line, fmt={fn_target: "500 Hz target"})
sf_line = ax.contour(D * 1000, L * 1000, SF, levels=[5], colors="white", linewidths=2, linestyles="--")
ax.clabel(sf_line, fmt={5: "Buckling SF=5"})
# overlay actual FEA points tested (d=50mm length family)
fea_d = [1.6, 1.8, 2.0, 2.2]
fea_L = [50, 50, 50, 50]
ax.scatter(fea_d, fea_L, color="orange", edgecolor="k", s=70, zorder=5, label="FEA points tested")
ax.set_xlabel("Stinger diameter d [mm]")
ax.set_ylabel("Stinger length L [mm]")
ax.set_title("Axial Stinger Design Space: Frequency & Buckling Feasibility")
ax.legend(loc="upper right")
fig.tight_layout()
fig.savefig(f"{OUT}/5_design_space_contour.png")
plt.close(fig)

# -------------------------------------------------------------------------
# PLOT 6 — Pareto trade-off: fn vs stiffness ratio vs buckling SF (from the
#   brute-force optimisation loop in stinger_design_V3.m), full factorial
# -------------------------------------------------------------------------
d_ax_range = np.arange(1.0, 4.01, 0.2) * 1e-3
L_ax_range = np.arange(30, 151, 5) * 1e-3

rows = []
for d in d_ax_range:
    for Lx in L_ax_range:
        A = np.pi * d**2 / 4
        I = np.pi * d**4 / 64
        k = 3 * E * A / Lx
        fn = (1 / (2 * np.pi)) * np.sqrt(k / m_total)
        k_lat = 3 * E * I / Lx**3
        ratio = (E * A / Lx) / k_lat
        F_crit = np.pi**2 * E * I / Lx**2
        SFb = F_crit / F_axial_max
        rows.append((d * 1000, Lx * 1000, fn, ratio, SFb))
rows = np.array(rows)
d_all, L_all, fn_all, ratio_all, SFb_all = rows.T
feasible = (fn_all >= fn_target) & (ratio_all >= 3000) & (SFb_all >= 5)

fig, ax = plt.subplots(figsize=(8.5, 6.5))
sc = ax.scatter(fn_all[~feasible], ratio_all[~feasible], c=SFb_all[~feasible],
                 cmap="Greys", s=14, alpha=0.35, label="Infeasible")
sc2 = ax.scatter(fn_all[feasible], ratio_all[feasible], c=d_all[feasible],
                  cmap="plasma", s=30, edgecolor="k", linewidth=0.3, label="Feasible")
cbar = fig.colorbar(sc2, ax=ax)
cbar.set_label("Stinger diameter [mm]")
ax.axvline(fn_target, color="red", ls="--", lw=1.2)
ax.set_yscale("log")
ax.set_xlabel("Mode 1 axial natural frequency [Hz]")
ax.set_ylabel("Axial/lateral stiffness ratio (log scale)")
ax.set_title("Full-Factorial Sweep: Feasible Region & Trade-offs")
ax.legend(loc="lower right")
fig.tight_layout()
fig.savefig(f"{OUT}/6_pareto_feasible_region.png")
plt.close(fig)

# -------------------------------------------------------------------------
# PLOT 7 — FEA vs analytical model validation
# -------------------------------------------------------------------------
d_fea = np.array([1.6, 1.8, 2.0, 2.2]) * 1e-3
fea_vals = np.array([fea[f"50x50, d={dd:.1f}"][0] for dd in [1.6, 1.8, 2.0, 2.2]])
analytic_vals = fn_axial_analytic(d_fea, 0.05)

fig, ax = plt.subplots(figsize=(7.5, 5.5))
d_cont = np.linspace(1.4, 2.4, 100) * 1e-3
ax.plot(d_cont * 1000, fn_axial_analytic(d_cont, 0.05), "b-", lw=2, label="Analytical (point-mass model)")
ax.plot(d_fea * 1000, fea_vals, "o", color="#d81a1a", ms=9, label="FEA (ANSYS modal)")
for dd, fv, av in zip(d_fea * 1000, fea_vals, analytic_vals):
    err = 100 * (fv - av) / fv
    ax.annotate(f"{err:+.0f}%", (dd, fv), textcoords="offset points", xytext=(8, -4), fontsize=8.5)
ax.axhline(fn_target, color="k", ls="--", lw=1.3, label="500 Hz target")
ax.set_xlabel("Stinger diameter [mm]")
ax.set_ylabel("Mode 1 frequency [Hz]")
ax.set_title("Analytical Model vs FEA — Validation & Residual Error")
ax.legend()
fig.tight_layout()
fig.savefig(f"{OUT}/7_model_validation.png")
plt.close(fig)

print("Done. Files written:")
import os
for f in sorted(os.listdir(OUT)):
    print(" ", f)
