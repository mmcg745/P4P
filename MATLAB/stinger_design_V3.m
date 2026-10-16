% =========================================================================
% STINGER DESIGN CALCULATOR  v3
% RWA Microvibration & Imbalance Measurement Device
% =========================================================================
% Updates from v2:
%   - design_case switch: 'final' (as-built piano wire, default) or
%     'midyear' (2 mm x 50 mm steel rod) so both report tables reproduce
%   - Two frequency targets: best case 500 Hz (report design target,
%     one-third rule) and acceptable case 300 Hz (poster "stiffen the
%     system" target). Frequency checks report BEST / ACCEPTABLE / FAIL
%   - Natural frequency per direction: fn = sqrt(n*EA/L / m)/(2*pi) with
%     n = 3 (axial bounce), n = 2 (lateral x, Rx pair), n = 1 (lateral y, Ry1)
%   - Sensor stiffness in series with each stinger (PCB 208C: 1.05 kN/um)
%   - Buckling reported for pinned and fixed ends; pass/fail uses K_end
%   - Yield check now uses axial stress in each stinger (the radial
%     stingers carry the lateral load, so the axial stingers are not
%     cantilevers under the imbalance force). Old tip-load bending kept
%     as INFO
%   - Imbalance amplification at the top spin speed and an as-built
%     comparison against the measured tap-test modes
%   - Helper functions moved to the end of the file (MATLAB requires it)
% =========================================================================
% Sources: final report Section 3 (stinger design, Table "Design checks for
% the final piano-wire stingers"), knowledge/10_experimental_results.md,
% PCB 208C01/208C02 datasheets (knowledge/PCB FT/).
% =========================================================================

clc; clear; close all;

design_case = 'final';          % 'final' (as-built) or 'midyear'

%% =========================================================================
%  SECTION 1 — RWA PARAMETERS
% =========================================================================

Omega_max       = 3000*2*pi/60; % Top of planned speed range [rad/s] (50 Hz)
Omega_test      = 300*2*pi/60;  % Low test speed for imbalance [rad/s]
                                 % (campaign C low-speed vectors: 200-450 rpm)
Us_max          = 26e-6;        % Max static imbalance [kg·m]      (26 g·mm, flight spec)
Ud_max          = 800e-9;       % Max dynamic imbalance [kg·m²]    (800 g·mm²)

%% =========================================================================
%  SECTIONS 2-4 — GEOMETRY, MASS AND MATERIAL (per design case)
% =========================================================================
% Heights are measured from the axial sensor plane (base plate).

switch design_case
    case 'final'
        % As-built piano-wire stingers (report Section 3, final design)
        L_axial      = 0.095;   % Axial stinger free length [m] (bolt to bolt)
        L_radial     = 0.095;   % Radial stinger free length [m]
        d_axial      = 0.0012;  % Axial stinger diameter [m]
        d_radial     = 0.0008;  % Radial stinger diameter [m]

        m_RWA        = 0.80;    % RWA with wiring, driver board excluded [kg]
        m_plate      = 0.20;    % PLA mounting plate (192.6 g) [kg]
                                 % Design case = 1.0 kg supported (report).
                                 % Al plate: m_plate = 0.551 (1.35 kg total)

        h_CoM        = 0.2175;  % Flywheel mid-plane above base plate [m]
        z_r          = 0.140;   % Radial stinger plane above base plate [m]
        R_triangle   = 0.050;   % Axial stinger circumradius [m] (static test)
        s_separation = 0.105;   % Rx1-Rx2 spacing [m]
        r_rotor      = 0.065;   % Correction radius (bolt pitch radius) [m]

        % Steel piano wire (ASTM A228 music wire)
        E            = 200e9;   % Young's modulus [Pa]
        rho          = 7850;    % Density [kg/m³]
        sigma_y      = 1500e6;  % Yield strength [Pa] — ASSUMED, not measured
                                 % (~0.65 x min. tensile 2.2-2.3 GPa at 0.8-1.2 mm)
        mat_name     = 'Steel piano wire';

    case 'midyear'
        % Mid-year 2 mm x 50 mm steel rod (report Appendix, mid-year checks)
        L_axial      = 0.05;
        L_radial     = 0.05;
        d_axial      = 0.002;
        d_radial     = 0.002;

        m_RWA        = 1.0;
        m_plate      = 0.2;     % Conservative 1.2 kg total

        h_CoM        = 0.065 + 0.075;
        z_r          = 0.065;
        R_triangle   = 0.05;
        s_separation = 0.115;
        r_rotor      = 0.045;

        E            = 200e9;
        rho          = 7800;
        sigma_y      = 350e6;
        mat_name     = 'Steel rod';

    otherwise
        error('design_case must be ''final'' or ''midyear''');
end

h_eff = h_CoM - z_r;            % Effective moment arm above radial plane [m]

% Aluminium 6061 — uncomment to override the material
% E = 69e9; rho = 2700; sigma_y = 270e6; mat_name = 'Aluminium 6061';

%% =========================================================================
%  SECTION 5 — SENSOR AND DAQ PARAMETERS
% =========================================================================

% Radial: PCB 208C01 (Rx1, Rx2) and 208C02 (Ry1), ICP quartz
sensor_resolution = 0.00045;    % 208C01 broadband resolution [N rms]
S_sensor          = 0.1124;     % 208C01 sensitivity [V/N] (500 mV/lb)
                                 % (208C02: 0.01124 V/N)
F_range_sensor    = 44.5;       % 208C01 measurement range [N] (10 lb)
k_sensor_rad      = 1.05e9;     % 208C stiffness [N/m] (1.05 kN/um)
m_transducer_rad  = 0.0114;     % Seismic mass [kg] — ASSUMED half of the
                                 % 22.7 g sensor (McConnell & Cappa, 2000)

% Axial: TAS510 10 kg strain-gauge load cells
sensor_res_axial  = 0.29;       % Rated combined error ±0.3% FS [N] (static,
                                 % conservative for dynamic resolution)
k_sensor_ax       = Inf;        % Load-cell stiffness unknown [N/m]
m_transducer_ax   = 0.005;      % Seismic mass [kg] — placeholder, unknown

% DAQ: NI cDAQ, NI 9232 (radial) and NI 9237 (axial), FlexLogger
V_DAQ             = 30;         % NI 9232 input range [±V]
fs                = 10000;      % Sample rate [Hz]
N_avg             = 20;         % Number of revolutions averaged
f_measure_max     = 500;        % Max microvibration frequency of interest [Hz]

%% =========================================================================
%  SECTION 6 — DESIGN TARGETS
% =========================================================================

fn_target_best    = 500;        % Best case: one-third rule (report)
fn_target_acc     = 300;        % Acceptable case (poster next-step target)
SF_buckle_target  = 5;          % Min buckling safety factor
SF_yield_target   = 3;          % Min yield safety factor
ratio_target      = 3000;       % Min axial/lateral stiffness ratio
K_end             = 1;          % Buckling end factor used for pass/fail
                                 % (1 = pinned, design convention; 0.5 = fixed)

% Largest compressions measured in testing (campaign A, 750 rpm, 9.56 g
% bolt) — INFO only, reproduces the report's stress and buckling tables
F_meas_max_ax     = 9.3;        % Axial stinger [N] (3.3 static + ~6 dynamic)
F_meas_max_rad    = 5.2;        % Radial stinger, Ry1 [N]

%% =========================================================================
%  DERIVED QUANTITIES
% =========================================================================

A_ax    = pi * d_axial^2 / 4;
I_ax    = pi * d_axial^4 / 64;
A_rad   = pi * d_radial^2 / 4;
I_rad   = pi * d_radial^4 / 64;

m_total = m_RWA + m_plate;

% Stinger axial stiffness in series with its sensor
k_ax_wire   = E * A_ax / L_axial;
k_rad_wire  = E * A_rad / L_radial;
k_ax_path   = 1 / (1/k_ax_wire  + 1/k_sensor_ax);
k_rad_path  = 1 / (1/k_rad_wire + 1/k_sensor_rad);

%% =========================================================================
%  FORCE AND MOMENT ESTIMATES
% =========================================================================

F_radial_max    = Us_max * Omega_max^2;     % Design rotating force (2.6 N)
F_radial_test   = Us_max * Omega_test^2;

F_static_each   = (m_total * 9.81) / 3;     % Static load per axial stinger

M_overturn      = F_radial_max * h_eff;     % Overturning moment at axial plane
F_axial_dyn     = M_overturn / (R_triangle * sqrt(3));
F_axial_max     = F_static_each + F_axial_dyn;

Mx_max          = F_radial_max * h_eff;
Md_max          = Ud_max * Omega_max^2;

%% =========================================================================
%  PRINT HEADER
% =========================================================================

fprintf('\n');
fprintf('=================================================================\n');
fprintf('  STINGER DESIGN CALCULATOR  v3   (case: %s)\n', design_case);
fprintf('  Material: %s\n', mat_name);
fprintf('  Frequency targets: best > %d Hz, acceptable > %d Hz\n', ...
    fn_target_best, fn_target_acc);
fprintf('=================================================================\n\n');

fprintf('--- RWA PARAMETERS ---\n');
fprintf('  RWA mass:              %.3f kg\n', m_RWA);
fprintf('  Total supported mass:  %.3f kg\n', m_total);
fprintf('  Max spin speed:        %.0f rpm (%.0f Hz)\n', Omega_max*60/(2*pi), Omega_max/(2*pi));
fprintf('  Test spin speed:       %.0f rpm\n', Omega_test*60/(2*pi));
fprintf('  Max static imbalance:  %.1f g·mm\n', Us_max*1e6);
fprintf('  Max dynamic imbalance: %.1f g·mm²\n\n', Ud_max*1e9);

fprintf('--- GEOMETRY ---\n');
fprintf('  h_CoM:        %.1f mm  (rotor CoM above axial sensor plane)\n', h_CoM*1000);
fprintf('  z_r:          %.1f mm  (radial stingers above axial plane)\n', z_r*1000);
fprintf('  h_eff:        %.1f mm  (h_CoM - z_r)\n', h_eff*1000);
fprintf('  R_triangle:   %.1f mm  (axial stinger circumradius)\n', R_triangle*1000);
fprintf('  s_separation: %.1f mm  (Rx1-Rx2 spacing)\n\n', s_separation*1000);

fprintf('--- FORCE AND MOMENT ESTIMATES ---\n');
fprintf('  Design radial force (max speed): %.4f N\n', F_radial_max);
fprintf('  Radial force (test speed):       %.4f N\n', F_radial_test);
fprintf('  Static load per axial stinger:   %.4f N\n', F_static_each);
fprintf('  Dynamic axial load per stinger:  %.4f N\n', F_axial_dyn);
fprintf('  Total max axial load per stinger:%.4f N\n', F_axial_max);
fprintf('  Max overturning moment:          %.6f N·m\n', Mx_max);
fprintf('  Max dynamic imbalance moment:    %.6f N·m\n\n', Md_max);

%% =========================================================================
%  AXIAL STINGER CHECKS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  AXIAL STINGERS   d = %.1f mm   L = %.0f mm\n', ...
    d_axial*1000, L_axial*1000);
fprintf('=================================================================\n\n');

k_lat_ax    = 3 * E * I_ax / L_axial^3;     % cantilever (report convention)
k_lat_ax_ff = 12 * E * I_ax / L_axial^3;    % both ends fixed against rotation

% CHECK 1 — Axial bounce natural frequency (n = 3)
fn_ax_wire = (1/(2*pi)) * sqrt(3*k_ax_wire / m_total);
fn_ax      = (1/(2*pi)) * sqrt(3*k_ax_path / m_total);
lvl_ax1    = freq_level(fn_ax, fn_target_best, fn_target_acc);
fprintf('  CHECK 1 — Axial bounce natural frequency (n = 3)\n');
fprintf('    EA/L per stinger:     %.3e N/m\n', k_ax_wire);
fprintf('    fn (stingers only) = %.1f Hz\n', fn_ax_wire);
fprintf('    fn (with sensor)   = %.1f Hz   best > %d, acceptable > %d Hz\n', ...
    fn_ax, fn_target_best, fn_target_acc);
fprintf('    RESULT: %s\n\n', level_str(lvl_ax1));

% CHECK 2 — Axial/lateral stiffness ratio
ratio_ax    = k_ax_wire / k_lat_ax;
ratio_ax_ff = k_ax_wire / k_lat_ax_ff;
lvl_ax2     = 2 * (ratio_ax > ratio_target);
fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    Ratio (cantilever 3EI/L^3) = %.0f : 1   target > %d : 1\n', ratio_ax, ratio_target);
fprintf('    Ratio (fixed ends 12EI/L^3) = %.0f : 1\n', ratio_ax_ff);
fprintf('    RESULT: %s\n\n', level_str(lvl_ax2));

% CHECK 3 — Buckling under design load (static + overturning)
Fcr_ax_pin = pi^2 * E * I_ax / L_axial^2;
Fcr_ax_fix = pi^2 * E * I_ax / (0.5*L_axial)^2;
Fcr_ax     = pi^2 * E * I_ax / (K_end*L_axial)^2;
SF_bk_ax   = Fcr_ax / F_axial_max;
lvl_ax3    = 2 * (SF_bk_ax > SF_buckle_target);
fprintf('  CHECK 3 — Buckling (K = %.1f for pass/fail)\n', K_end);
fprintf('    Critical load pinned / fixed: %.2f / %.2f N\n', Fcr_ax_pin, Fcr_ax_fix);
fprintf('    Design load (static + overturning): %.3f N\n', F_axial_max);
fprintf('    SF pinned / fixed (design load):    %.1f / %.1f\n', ...
    Fcr_ax_pin/F_axial_max, Fcr_ax_fix/F_axial_max);
fprintf('    SF pinned / fixed (static only):    %.1f / %.1f\n', ...
    Fcr_ax_pin/F_static_each, Fcr_ax_fix/F_static_each);
fprintf('    SF pinned / fixed (measured %.1f N): %.1f / %.1f\n', F_meas_max_ax, ...
    Fcr_ax_pin/F_meas_max_ax, Fcr_ax_fix/F_meas_max_ax);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_bk_ax, SF_buckle_target);
fprintf('    RESULT: %s\n\n', level_str(lvl_ax3));

% CHECK 4 — Yield from axial stress
sig_ax   = F_axial_max / A_ax;
SF_y_ax  = sigma_y / sig_ax;
lvl_ax4  = 2 * (SF_y_ax > SF_yield_target);
fprintf('  CHECK 4 — Yield (axial stress)\n');
fprintf('    Stress at design load:       %.2f MPa\n', sig_ax/1e6);
fprintf('    Stress at measured %.1f N:    %.2f MPa\n', F_meas_max_ax, F_meas_max_ax/A_ax/1e6);
fprintf('    Yield strength:              %.0f MPa\n', sigma_y/1e6);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_y_ax, SF_yield_target);
fprintf('    RESULT: %s\n\n', level_str(lvl_ax4));

% INFO — mid-year convention: axial stinger as a cantilever under 1/3 of
% the radial force (conservative; in the final design the radial
% stingers carry the lateral load)
F_lat_each = F_radial_max / 3;
sig_bend_ax = (F_lat_each * L_axial * d_axial/2) / I_ax;
fprintf('  INFO — Tip-load bending (mid-year convention)\n');
fprintf('    Stress %.1f MPa, SF %.1f, deflection %.4f mm\n\n', ...
    sig_bend_ax/1e6, sigma_y/sig_bend_ax, F_lat_each/k_lat_ax*1000);

% CHECK 5 — Transducer-inertia/stinger resonance (McConnell & Cappa, 2000)
fn_comb_ax = (1/(2*pi)) * sqrt(k_ax_path / m_transducer_ax);
lvl_ax5    = freq_level(fn_comb_ax, fn_target_best, fn_target_acc);
fprintf('  CHECK 5 — Transducer-inertia/stinger resonance (McConnell & Cappa, 2000)\n');
fprintf('    Transducer mass:     %.4f kg (placeholder)\n', m_transducer_ax);
fprintf('    fn_combined = %.1f Hz\n', fn_comb_ax);
fprintf('    RESULT: %s\n\n', level_str(lvl_ax5));

checks_ax = [lvl_ax1, lvl_ax2, lvl_ax3, lvl_ax4, lvl_ax5];

%% =========================================================================
%  RADIAL STINGER CHECKS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  RADIAL STINGERS  d = %.1f mm   L = %.0f mm\n', ...
    d_radial*1000, L_radial*1000);
fprintf('=================================================================\n\n');

k_lat_rad    = 3 * E * I_rad / L_radial^3;
k_lat_rad_ff = 12 * E * I_rad / L_radial^3;

% CHECK 1 — Lateral natural frequencies: x (Rx pair, n = 2), y (Ry1, n = 1)
fn_rad_x_wire = (1/(2*pi)) * sqrt(2*k_rad_wire / m_total);
fn_rad_y_wire = (1/(2*pi)) * sqrt(1*k_rad_wire / m_total);
fn_rad_x      = (1/(2*pi)) * sqrt(2*k_rad_path / m_total);
fn_rad_y      = (1/(2*pi)) * sqrt(1*k_rad_path / m_total);
lvl_rad1      = freq_level(min(fn_rad_x, fn_rad_y), fn_target_best, fn_target_acc);
fprintf('  CHECK 1 — Lateral natural frequency (x: n = 2, y: n = 1)\n');
fprintf('    EA/L per stinger:     %.3e N/m\n', k_rad_wire);
fprintf('    fn x (stingers only / with sensor) = %.1f / %.1f Hz\n', fn_rad_x_wire, fn_rad_x);
fprintf('    fn y (stingers only / with sensor) = %.1f / %.1f Hz\n', fn_rad_y_wire, fn_rad_y);
fprintf('    best > %d, acceptable > %d Hz\n', fn_target_best, fn_target_acc);
fprintf('    RESULT: x %s, y %s\n\n', ...
    level_str(freq_level(fn_rad_x, fn_target_best, fn_target_acc)), level_str(lvl_rad1));

% CHECK 2 — Axial/lateral stiffness ratio
ratio_rad    = k_rad_wire / k_lat_rad;
ratio_rad_ff = k_rad_wire / k_lat_rad_ff;
lvl_rad2     = 2 * (ratio_rad > ratio_target);
fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    Ratio (cantilever 3EI/L^3) = %.0f : 1   target > %d : 1\n', ratio_rad, ratio_target);
fprintf('    Ratio (fixed ends 12EI/L^3) = %.0f : 1\n', ratio_rad_ff);
fprintf('    RESULT: %s\n\n', level_str(lvl_rad2));

% CHECK 3 — Buckling (Ry1 carries all of the design radial force)
Fcr_rad_pin = pi^2 * E * I_rad / L_radial^2;
Fcr_rad_fix = pi^2 * E * I_rad / (0.5*L_radial)^2;
Fcr_rad     = pi^2 * E * I_rad / (K_end*L_radial)^2;
SF_bk_rad   = Fcr_rad / F_radial_max;
lvl_rad3    = 2 * (SF_bk_rad > SF_buckle_target);
fprintf('  CHECK 3 — Buckling (K = %.1f for pass/fail)\n', K_end);
fprintf('    Critical load pinned / fixed: %.2f / %.2f N\n', Fcr_rad_pin, Fcr_rad_fix);
fprintf('    Design load:                        %.3f N\n', F_radial_max);
fprintf('    SF pinned / fixed (design load):    %.1f / %.1f\n', ...
    Fcr_rad_pin/F_radial_max, Fcr_rad_fix/F_radial_max);
fprintf('    SF pinned / fixed (measured %.1f N): %.2f / %.1f\n', F_meas_max_rad, ...
    Fcr_rad_pin/F_meas_max_rad, Fcr_rad_fix/F_meas_max_rad);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_bk_rad, SF_buckle_target);
fprintf('    RESULT: %s\n\n', level_str(lvl_rad3));

% CHECK 4 — Yield from axial stress
sig_rad  = F_radial_max / A_rad;
SF_y_rad = sigma_y / sig_rad;
lvl_rad4 = 2 * (SF_y_rad > SF_yield_target);
fprintf('  CHECK 4 — Yield (axial stress)\n');
fprintf('    Stress at design load:       %.2f MPa\n', sig_rad/1e6);
fprintf('    Stress at measured %.1f N:    %.2f MPa\n', F_meas_max_rad, F_meas_max_rad/A_rad/1e6);
fprintf('    Yield strength:              %.0f MPa\n', sigma_y/1e6);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_y_rad, SF_yield_target);
fprintf('    RESULT: %s\n\n', level_str(lvl_rad4));

% CHECK 5 — Transducer-inertia/stinger resonance (McConnell & Cappa, 2000)
fn_comb_rad = (1/(2*pi)) * sqrt(k_rad_path / m_transducer_rad);
lvl_rad5    = freq_level(fn_comb_rad, fn_target_best, fn_target_acc);
fprintf('  CHECK 5 — Transducer-inertia/stinger resonance (McConnell & Cappa, 2000)\n');
fprintf('    Transducer mass:     %.4f kg (assumed)\n', m_transducer_rad);
fprintf('    fn_combined = %.1f Hz\n', fn_comb_rad);
fprintf('    RESULT: %s\n\n', level_str(lvl_rad5));

checks_rad = [lvl_rad1, lvl_rad2, lvl_rad3, lvl_rad4, lvl_rad5];

%% =========================================================================
%  IMBALANCE AMPLIFICATION AND AS-BUILT COMPARISON
% =========================================================================

fprintf('=================================================================\n');
fprintf('  IMBALANCE AMPLIFICATION  1/(1-(f/fn)^2)\n');
fprintf('=================================================================\n\n');

f_spin_max = Omega_max/(2*pi);
fn_lowest  = min([fn_ax, fn_rad_x, fn_rad_y]);
amp_max    = 1 / (1 - (f_spin_max/fn_lowest)^2);
fprintf('  Lowest stinger-only mode:  %.1f Hz\n', fn_lowest);
fprintf('  Top spin frequency:        %.1f Hz (%.0f rpm)\n', f_spin_max, Omega_max*60/(2*pi));
fprintf('  fn / f_spin:               %.2f\n', fn_lowest/f_spin_max);
fprintf('  Amplification at top speed: %.3f (%.1f%%)\n', amp_max, (amp_max-1)*100);
fprintf('  (Highest microvibration frequency at the one-third rule: %.0f Hz)\n\n', fn_lowest/3);

fprintf('=================================================================\n');
fprintf('  AS-BUILT COMPARISON — measured lowest modes (tap tests)\n');
fprintf('=================================================================\n\n');

% Measured lowest lateral modes, knowledge/10_experimental_results.md
% {label, mass [kg], fx [Hz], fy [Hz]}
asbuilt = { 'A: PLA brackets',   0.993, 24.9, 22.2;
            'B: steel brackets', 0.993, 38.8, 47.9;
            'C: Al plate',       1.351, 39.8, 48.6;
            'Rigid case',        1.078, 46.3, 73.1 };
k_wire_x = 2*k_rad_wire;
k_wire_y = 1*k_rad_wire;
fprintf('  Wire-only lateral stiffness: x %.2f MN/m, y %.2f MN/m\n\n', ...
    k_wire_x/1e6, k_wire_y/1e6);
fprintf('  Setup              | m [kg] | fx [Hz] fy [Hz] | kx [kN/m] ky [kN/m] | softer than wires x / y\n');
fprintf('  ------------------------------------------------------------------------------------\n');
for i = 1:size(asbuilt,1)
    m_i = asbuilt{i,2};
    kx  = m_i*(2*pi*asbuilt{i,3})^2;
    ky  = m_i*(2*pi*asbuilt{i,4})^2;
    fprintf('  %-18s | %6.3f | %7.1f %7.1f | %9.0f %9.0f | %5.0fx / %4.0fx\n', ...
        asbuilt{i,1}, m_i, asbuilt{i,3}, asbuilt{i,4}, kx/1e3, ky/1e3, ...
        k_wire_x/kx, k_wire_y/ky);
end
fprintf('\n  The compliance is outside the stingers (supports, base, RWA frame).\n\n');

%% =========================================================================
%  SIGNAL CHAIN CHECKS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  SIGNAL CHAIN CHECKS\n');
fprintf('=================================================================\n\n');

% CHECK — Nyquist criterion
pass9 = fs > 2 * f_measure_max;
fprintf('  CHECK — Nyquist criterion\n');
fprintf('    Sample rate:    %d Hz\n', fs);
fprintf('    Required:       > %d Hz (2 × %d Hz)\n', 2*f_measure_max, f_measure_max);
fprintf('    %s\n\n', result_str(pass9));

% INFO — Frequency resolution
T_rev = 2*pi / Omega_test;
N_samples = round(T_rev * fs * N_avg);
delta_f = fs / N_samples;
fprintf('  INFO — Frequency resolution\n');
fprintf('    Test speed:        %.0f rpm\n', Omega_test*60/(2*pi));
fprintf('    Revolution period: %.4f s\n', T_rev);
fprintf('    Averages:          %d revolutions\n', N_avg);
fprintf('    Total samples:     %d\n', N_samples);
fprintf('    Frequency resolution: %.4f Hz\n', delta_f);
fprintf('    Spin frequency:       %.2f Hz\n\n', Omega_test/(2*pi));

% CHECK — Signal level at design force
V_max_signal = F_radial_max * S_sensor;
pass10 = V_max_signal < V_DAQ;
fprintf('  CHECK — Signal level within DAQ range\n');
fprintf('    Design radial force: %.4f N\n', F_radial_max);
fprintf('    Sensor sensitivity:  %.1f mV/N\n', S_sensor*1000);
fprintf('    Max signal voltage:  %.4f V\n', V_max_signal);
fprintf('    DAQ range:           ±%.1f V\n', V_DAQ);
fprintf('    %s\n\n', result_str(pass10));

% CHECK — Force within sensor range (largest measured and design loads)
pass11 = max(F_radial_max, F_meas_max_rad) < F_range_sensor;
fprintf('  CHECK — Force within 208C01 range\n');
fprintf('    Largest radial force: %.2f N   range %.1f N\n', ...
    max(F_radial_max, F_meas_max_rad), F_range_sensor);
fprintf('    %s\n\n', result_str(pass11));

% INFO — Signal at minimum detectable force
V_min_signal = sensor_resolution * S_sensor;
fprintf('  INFO — Signal at sensor resolution\n');
fprintf('    Min force:           %.5f N\n', sensor_resolution);
fprintf('    Min signal voltage:  %.4f mV\n', V_min_signal*1000);
fprintf('    (DAQ must resolve this — check ADC bit depth)\n\n');

checks_sig = [pass9, pass10, pass11];

%% =========================================================================
%  MEASUREMENT SENSITIVITY
% =========================================================================

fprintf('=================================================================\n');
fprintf('  MEASUREMENT SENSITIVITY\n');
fprintf('=================================================================\n\n');

Us_min = sensor_resolution / Omega_test^2;
fprintf('  Static imbalance sensitivity (radial sensors, test speed)\n');
fprintf('    Test speed:                   %.0f rpm\n', Omega_test*60/(2*pi));
fprintf('    Sensor resolution:            %.5f N\n', sensor_resolution);
fprintf('    Min detectable Us:            %.3f g·mm\n', Us_min*1e6);
fprintf('    Flight spec:                  26 g·mm\n');
if Us_min*1e6 < 26
    fprintf('    Can resolve to spec\n\n');
else
    fprintf('    Cannot resolve to spec — increase test speed or improve sensor\n\n');
end

% Dynamic imbalance from the axial (TAS510) moments
Mx_min = sensor_res_axial * R_triangle;
Ud_min = Mx_min / Omega_test^2;
fprintf('  Dynamic imbalance sensitivity (axial load cells)\n');
fprintf('    Axial resolution (rated):     %.3f N\n', sensor_res_axial);
fprintf('    Min detectable moment:        %.5f N·m\n', Mx_min);
fprintf('    Min detectable Ud:            %.0f g·mm²\n', Ud_min*1e9);
fprintf('    Flight spec:                  800 g·mm²\n');
if Ud_min*1e9 < 800
    fprintf('    Can resolve to spec\n\n');
else
    fprintf('    Cannot resolve to spec — dynamic imbalance left as future work\n\n');
end

Mz_min = sensor_resolution * s_separation / 2;
fprintf('  Torque (Mz) sensitivity\n');
fprintf('    Rx1-Rx2 separation:           %.1f mm\n', s_separation*1000);
fprintf('    Min detectable Mz:            %.2e N·m\n\n', Mz_min);

%% =========================================================================
%  DYNAMIC IMBALANCE SEPARATION — KEY EQUATIONS (mid-year method)
% =========================================================================
% Superseded: too sensitive to h_CoM, so the final design uses the
% moments only as a consistency check (report Section 3). Kept for history.

fprintf('=================================================================\n');
fprintf('  DYNAMIC IMBALANCE SEPARATION — mid-year method (superseded)\n');
fprintf('=================================================================\n\n');

fprintf('  h_CoM = %.1f mm   z_r = %.1f mm   h_eff = %.1f mm\n\n', ...
    h_CoM*1000, z_r*1000, h_eff*1000);
fprintf('  Us = F_radial / Omega²,  phi = atan2(Fy, Fx)\n');
fprintf('  M_dyn_x = Mx - Fy × h_eff,  M_dyn_y = My - Fx × h_eff\n');
fprintf('  Ud = sqrt(M_dyn_x² + M_dyn_y²) / Omega²\n');
fprintf('  Correction masses (De Munter), r = %.1f mm:\n', r_rotor*1000);
fprintf('    mA_s = Us × hB / [r × (hA + hB)],  mB_s = Us × hA / [r × (hA + hB)]\n');
fprintf('    mA_d = Ud / (2 × r × hA),          mB_d = Ud / (2 × r × hB)\n\n');

%% =========================================================================
%  PARAMETRIC STUDY
% =========================================================================

fprintf('=================================================================\n');
fprintf('  PARAMETRIC STUDY — Axial stinger diameter\n');
fprintf('  L = %.0f mm   Material: %s   m = %.2f kg\n', L_axial*1000, mat_name, m_total);
fprintf('=================================================================\n\n');
fprintf('  d [mm] | fn [Hz] | Buckle SF | Ratio      | Yield SF\n');
fprintf('  -------------------------------------------------------\n');

d_range = (0.5:0.5:6) * 1e-3;
for d_i = d_range
    [fn_i, SF_bk_i, ratio_i, SF_y_i] = axial_metrics(d_i, L_axial, E, sigma_y, ...
        m_total, F_axial_max, K_end);
    fprintf('  %5.1f  | %7.1f | %9.1f | %10.0f | %.1f\n', ...
        d_i*1000, fn_i, SF_bk_i, ratio_i, SF_y_i);
end

%% =========================================================================
%  PLOTS
% =========================================================================

figure('Name','Stinger Design v3','Position',[50 50 1000 700]);

d_plot  = linspace(0.5e-3, 6e-3, 300);
fn_p    = zeros(size(d_plot));
SF_bk_p = zeros(size(d_plot));
ratio_p = zeros(size(d_plot));
SF_y_p  = zeros(size(d_plot));
for i = 1:length(d_plot)
    [fn_p(i), SF_bk_p(i), ratio_p(i), SF_y_p(i)] = axial_metrics(d_plot(i), ...
        L_axial, E, sigma_y, m_total, F_axial_max, K_end);
end

subplot(2,2,1);
plot(d_plot*1000, fn_p, 'b-', 'LineWidth',2); hold on;
yline(fn_target_best,'r--','LineWidth',1.5);
yline(fn_target_acc,'--','Color',[0.9 0.5 0],'LineWidth',1.5);
xline(d_axial*1000,'k:','LineWidth',1.2);
xlabel('Diameter [mm]'); ylabel('f_n [Hz]');
title('Axial bounce frequency vs diameter');
legend('f_n','Best case','Acceptable','Design','Location','northwest');
grid on;

subplot(2,2,2);
plot(d_plot*1000, SF_bk_p, 'g-', 'LineWidth',2); hold on;
yline(SF_buckle_target,'r--','LineWidth',1.5);
xline(d_axial*1000,'k:','LineWidth',1.2);
xlabel('Diameter [mm]'); ylabel('Safety factor');
title('Buckling safety factor vs diameter');
ylim([0 min(max(SF_bk_p),100)]);
legend('SF buckle','Target','Design','Location','northwest');
grid on;

subplot(2,2,3);
semilogy(d_plot*1000, ratio_p, 'm-', 'LineWidth',2); hold on;
yline(ratio_target,'r--','LineWidth',1.5);
xline(d_axial*1000,'k:','LineWidth',1.2);
xlabel('Diameter [mm]'); ylabel('k_{ax}/k_{lat}');
title('Directional stiffness ratio vs diameter');
legend('Ratio','Target','Design','Location','northeast');
grid on;

subplot(2,2,4);
semilogy(d_plot*1000, SF_y_p, 'c-', 'LineWidth',2); hold on;
yline(SF_yield_target,'r--','LineWidth',1.5);
xline(d_axial*1000,'k:','LineWidth',1.2);
xlabel('Diameter [mm]'); ylabel('Safety factor');
title('Yield safety factor (axial stress) vs diameter');
legend('SF yield','Target','Design','Location','northwest');
grid on;

sgtitle(sprintf('Axial Stinger Design — %s, L = %.0f mm, m_{total} = %.2f kg', ...
    mat_name, L_axial*1000, m_total), 'FontWeight','bold');

%% =========================================================================
%  FINAL SUMMARY
% =========================================================================

fprintf('\n=================================================================\n');
fprintf('  FINAL SUMMARY  (best > %d Hz, acceptable > %d Hz)\n', ...
    fn_target_best, fn_target_acc);
fprintf('=================================================================\n');

fprintf('\n  AXIAL STINGERS   d=%.1fmm  L=%.0fmm  %s\n', ...
    d_axial*1000, L_axial*1000, mat_name);
ax_labels = {sprintf('Bounce frequency (%.0f Hz)', fn_ax), 'Stiffness ratio', ...
    'Buckling SF', 'Yield SF', 'Transducer-stinger resonance'};
for i = 1:5
    fprintf('    [%-10s] %s\n', level_str(checks_ax(i)), ax_labels{i});
end

fprintf('\n  RADIAL STINGERS  d=%.1fmm  L=%.0fmm  %s\n', ...
    d_radial*1000, L_radial*1000, mat_name);
rad_labels = {sprintf('Lateral frequency (x %.0f Hz, y %.0f Hz)', fn_rad_x, fn_rad_y), ...
    'Stiffness ratio', 'Buckling SF', 'Yield SF', 'Transducer-stinger resonance'};
for i = 1:5
    fprintf('    [%-10s] %s\n', level_str(checks_rad(i)), rad_labels{i});
end

fprintf('\n  SIGNAL CHAIN\n');
sig_labels = {'Nyquist criterion','Signal within DAQ range','Force within sensor range'};
for i = 1:3
    fprintf('    [%-10s] %s\n', pass_str(checks_sig(i)), sig_labels{i});
end

overall = min([checks_ax, checks_rad, 2*checks_sig]);
fprintf('\n');
switch overall
    case 2
        fprintf('  ALL CHECKS MEET THE BEST CASE\n');
    case 1
        fprintf('  ALL CHECKS MEET THE ACCEPTABLE CASE (frequency between %d and %d Hz)\n', ...
            fn_target_acc, fn_target_best);
    otherwise
        fprintf('  SOME CHECKS FAIL — adjust inputs and re-run\n');
end
fprintf('=================================================================\n\n');

%% =========================================================================
%  OPTIMISATION — Sweep d and L independently and in combination
%  Finds all geometry combinations that pass all five checks, for the
%  best-case and acceptable-case frequency targets
% =========================================================================

fprintf('\n=================================================================\n');
fprintf('  OPTIMISATION STUDY\n');
fprintf('  Sweeping d_axial, d_radial, L_axial, L_radial  (m = %.2f kg)\n', m_total);
fprintf('=================================================================\n\n');

d_ax_range  = (0.6:0.2:4.0) * 1e-3;   % axial diameter [m]
d_rad_range = (0.6:0.2:4.0) * 1e-3;   % radial diameter [m]
L_ax_range  = (30:5:175)   * 1e-3;    % axial length [m]
L_rad_range = (30:5:175)   * 1e-3;    % radial length [m]

% Each row: [d_ax, d_rad, L_ax, L_rad, fn_ax, fn_rad_y, ratio_ax, ratio_rad,
%            SF_bk_ax, SF_bk_rad, SF_y_ax, SF_y_rad, fn_comb_ax, fn_comb_rad, is_best]
results = [];

n_total = length(d_ax_range)*length(d_rad_range)*length(L_ax_range)*length(L_rad_range);
fprintf('  Evaluating %d combinations...\n\n', n_total);

for d_ax = d_ax_range
    A_ax_i = pi*d_ax^2/4;
    I_ax_i = pi*d_ax^4/64;
    for L_ax = L_ax_range
        k_ax_w_i  = E*A_ax_i/L_ax;
        k_ax_p_i  = 1/(1/k_ax_w_i + 1/k_sensor_ax);
        fn_ax_i   = (1/(2*pi))*sqrt(3*k_ax_p_i/m_total);
        ratio_ax_i = k_ax_w_i/(3*E*I_ax_i/L_ax^3);
        SF_bk_ax_i = pi^2*E*I_ax_i/(K_end*L_ax)^2 / F_axial_max;
        SF_y_ax_i  = sigma_y/(F_axial_max/A_ax_i);
        fn_comb_ax_i = (1/(2*pi))*sqrt(k_ax_p_i/m_transducer_ax);

        ok_ax = fn_ax_i >= fn_target_acc && ratio_ax_i >= ratio_target && ...
                SF_bk_ax_i >= SF_buckle_target && SF_y_ax_i >= SF_yield_target && ...
                fn_comb_ax_i >= fn_target_acc;
        if ~ok_ax, continue; end

        for d_rad = d_rad_range
            A_rad_i = pi*d_rad^2/4;
            I_rad_i = pi*d_rad^4/64;
            for L_rad = L_rad_range
                k_rad_w_i  = E*A_rad_i/L_rad;
                k_rad_p_i  = 1/(1/k_rad_w_i + 1/k_sensor_rad);
                fn_rad_i   = (1/(2*pi))*sqrt(k_rad_p_i/m_total);   % y, n = 1 (worst)
                ratio_rad_i = k_rad_w_i/(3*E*I_rad_i/L_rad^3);
                SF_bk_rad_i = pi^2*E*I_rad_i/(K_end*L_rad)^2 / F_radial_max;
                SF_y_rad_i  = sigma_y/(F_radial_max/A_rad_i);
                fn_comb_rad_i = (1/(2*pi))*sqrt(k_rad_p_i/m_transducer_rad);

                ok_rad = fn_rad_i >= fn_target_acc && ratio_rad_i >= ratio_target && ...
                         SF_bk_rad_i >= SF_buckle_target && SF_y_rad_i >= SF_yield_target && ...
                         fn_comb_rad_i >= fn_target_acc;
                if ~ok_rad, continue; end

                is_best = min([fn_ax_i, fn_rad_i, fn_comb_ax_i, fn_comb_rad_i]) >= fn_target_best;
                results(end+1,:) = [d_ax*1000, d_rad*1000, L_ax*1000, L_rad*1000, ...
                                    fn_ax_i, fn_rad_i, ratio_ax_i, ratio_rad_i, ...
                                    SF_bk_ax_i, SF_bk_rad_i, SF_y_ax_i, SF_y_rad_i, ...
                                    fn_comb_ax_i, fn_comb_rad_i, is_best]; %#ok<AGROW>
            end
        end
    end
end

n_best = 0; n_acc = 0;
if ~isempty(results)
    n_best = sum(results(:,15) == 1);
    n_acc  = size(results,1);
end
fprintf('  Best case (> %d Hz):       %d of %d combinations pass all checks.\n', ...
    fn_target_best, n_best, n_total);
fprintf('  Acceptable case (> %d Hz): %d of %d combinations pass all checks.\n\n', ...
    fn_target_acc, n_acc, n_total);

if isempty(results)
    fprintf('  NO feasible combinations found.\n');
    fprintf('  Consider relaxing targets or expanding search ranges.\n\n');
else
    best = results(results(:,15) == 1, :);
    if isempty(best)
        show = sortrows(results, 5);
        fprintf('  No best-case combinations; showing acceptable-case ones.\n\n');
    else
        show = sortrows(best, 5);
    end

    fprintf('  Top 10 feasible combinations (sorted by axial fn):\n\n');
    fprintf('  d_ax  d_rad  L_ax  L_rad | fn_ax  fn_rady | ratio_ax ratio_rad | SF_bk_ax SF_bk_rad | fn_cmb_ax fn_cmb_rad\n');
    fprintf('  [mm]  [mm]   [mm]  [mm]  | [Hz]   [Hz]    |                   |                    | [Hz]      [Hz]\n');
    fprintf('  ---------------------------------------------------------------------------------------------------------\n');
    for i = 1:min(10, size(show,1))
        r = show(i,:);
        fprintf('  %4.1f  %4.1f   %4.0f  %4.0f  | %6.1f %6.1f  | %8.0f %8.0f | %7.1f  %7.1f   | %8.1f  %8.1f\n', ...
            r(1), r(2), r(3), r(4), r(5), r(6), r(7), r(8), r(9), r(10), r(13), r(14));
    end

    % Plot 1: feasibility map for same axial and radial geometry
    figure('Name','Optimisation — Feasibility Map','Position',[50 50 700 500]);
    same = results(results(:,1)==results(:,2) & results(:,3)==results(:,4), :);
    if ~isempty(same)
        acc_only = same(same(:,15)==0, :);
        bst      = same(same(:,15)==1, :);
        hold on;
        if ~isempty(acc_only)
            scatter(acc_only(:,1), acc_only(:,3), 40, [0.75 0.75 0.75], 'filled');
        end
        if ~isempty(bst)
            scatter(bst(:,1), bst(:,3), 60, bst(:,5), 'filled');
            colorbar; colormap(jet);
        end
        plot(d_axial*1000, L_axial*1000, 'kp', 'MarkerSize', 14, 'MarkerFaceColor', 'k');
        xlabel('Stinger Diameter  d  [mm]', 'FontSize', 12);
        ylabel('Stinger Length  L  [mm]', 'FontSize', 12);
        title('Feasible Combinations — Same Axial and Radial Geometry', ...
              'FontSize', 12, 'FontWeight', 'bold');
        subtitle(sprintf('Colour = axial f_n (best > %d Hz); grey = acceptable only (> %d Hz); star = design', ...
            fn_target_best, fn_target_acc), 'FontSize', 10);
        grid on; box on;
    end

    % Plot 2: fn_axial vs fn_radial
    figure('Name','Optimisation — fn Axial vs Radial','Position',[50 50 600 500]);
    scatter(results(:,5), results(:,6), 30, results(:,1), 'filled'); hold on;
    xline(fn_target_best,'r--'); yline(fn_target_best,'r--');
    xline(fn_target_acc,'--','Color',[0.9 0.5 0]); yline(fn_target_acc,'--','Color',[0.9 0.5 0]);
    colorbar; colormap(parula);
    xlabel('Axial f_n  [Hz]', 'FontSize', 12);
    ylabel('Radial f_n (y, one stinger)  [Hz]', 'FontSize', 12);
    title('Feasible Combinations — Axial vs Radial Natural Frequency', ...
          'FontSize', 12, 'FontWeight', 'bold');
    subtitle('Colour = axial stinger diameter [mm]', 'FontSize', 10);
    grid on; box on;

    % Plot 3: stiffness ratio vs fn for axial stingers
    figure('Name','Optimisation — Ratio vs fn','Position',[50 50 600 500]);
    scatter(results(:,5), results(:,7), 30, results(:,3), 'filled');
    colorbar; colormap(cool);
    xlabel('Axial f_n  [Hz]', 'FontSize', 12);
    ylabel('Axial Stiffness Ratio  k_{ax}/k_{lat}', 'FontSize', 12);
    title('Feasible Combinations — Natural Frequency vs Stiffness Ratio', ...
          'FontSize', 12, 'FontWeight', 'bold');
    subtitle('Colour = axial stinger length [mm]', 'FontSize', 10);
    grid on; box on;
end

fprintf('\n=================================================================\n');
fprintf('  OPTIMISATION COMPLETE\n');
fprintf('=================================================================\n\n');

%% =========================================================================
%  HELPER FUNCTIONS (must be at the end of a MATLAB script)
% =========================================================================

function [fn, SF_bk, ratio, SF_y] = axial_metrics(d, L, E, sigma_y, m, F_ax, K)
    A     = pi*d^2/4;
    I     = pi*d^4/64;
    fn    = (1/(2*pi))*sqrt(3*E*A/L/m);
    SF_bk = pi^2*E*I/(K*L)^2 / F_ax;
    ratio = (E*A/L)/(3*E*I/L^3);
    SF_y  = sigma_y/(F_ax/A);
end

function lvl = freq_level(fn, best, acc)
    % 2 = meets best case, 1 = meets acceptable case, 0 = fail
    if fn >= best
        lvl = 2;
    elseif fn >= acc
        lvl = 1;
    else
        lvl = 0;
    end
end

function s = level_str(lvl)
    switch lvl
        case 2
            s = 'PASS';
        case 1
            s = 'ACCEPTABLE';
        otherwise
            s = 'FAIL';
    end
end

function s = result_str(pass)
    if pass
        s = 'RESULT: PASS';
    else
        s = 'RESULT: FAIL';
    end
end

function s = pass_str(pass)
    if pass
        s = 'PASS';
    else
        s = 'FAIL';
    end
end
