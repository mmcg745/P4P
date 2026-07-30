% =========================================================================
% STINGER DESIGN CALCULATOR
% RWA Microvibration & Imbalance Measurement Device
% =========================================================================
% Instructions:
%   1. Fill in the INPUTS section with your RWA parameters
%   2. Run the script
%   3. Check all PASS/FAIL results at the bottom
%   4. Adjust stinger geometry if any checks fail
% =========================================================================

clc; clear; close all;

%% =========================================================================
%  INPUTS — Fill these in when you have the RWA details
% =========================================================================

% --- Frame Geometry ---
L_axial     = 0.10;         % Axial stinger length [m]     *** UPDATE ***
L_radial    = 0.10;         % Radial stinger length [m]    *** UPDATE ***
R_triangle  = 0.1;         % Circumradius of axial stinger triangle [m]
s_separation = 0.1;        % Horizontal separation between Rx1 and Rx2 [m]

% --- RWA Parameters ---
m_RWA       = 0.8;          % RWA total mass [kg]          *** UPDATE ***
Omega_max   = 3000 * 2*pi/60; % Max spin speed [rad/s]     *** UPDATE ***
Us_max      = 26e-6;        % Max static imbalance [kg·m] (26 g·mm default)
Ud_max      = 800e-9;       % Max dynamic imbalance [kg·m²] (800 g·mm² default)
h_CoM       = L_axial + 0.10; % Height of rotor CoM above axial sensor plane [m] *** UPDATE ***


% --- Stinger Material ---
% Steel
E_steel     = 200e9;        % Young's modulus [Pa]
rho_steel   = 7800;         % Density [kg/m³]
sigma_y_steel = 350e6;      % Yield strength [Pa] (mild steel — conservative)

% Aluminium (uncomment to use instead)
% E_al        = 69e9;
% rho_al      = 2700;
% sigma_y_al  = 270e6;

% Select material (change to al variables if using aluminium)
E           = E_steel;
rho         = rho_steel;
sigma_y     = sigma_y_steel;
mat_name    = 'Steel';

% --- Stinger Diameters to evaluate ---
d_axial     = 0.002;        % Axial stinger diameter [m]   *** UPDATE ***
d_radial    = 0.002;        % Radial stinger diameter [m]  *** UPDATE ***

% --- Performance Targets ---
fn_target   = 1500;         % Minimum natural frequency [Hz]
SF_buckle   = 5;            % Safety factor against buckling
SF_yield    = 3;            % Safety factor against yield
ratio_target = 10000;       % Minimum axial/lateral stiffness ratio

%% =========================================================================
%  DERIVED QUANTITIES
% =========================================================================

% Cross-section properties
A_axial     = pi * d_axial^2 / 4;
I_axial     = pi * d_axial^4 / 64;
A_radial    = pi * d_radial^2 / 4;
I_radial    = pi * d_radial^4 / 64;

% Mounting plate mass estimate (approximate — update when known)
m_plate     = 0.25;          % Estimated mounting plate mass [kg]
m_total     = m_RWA + m_plate; % Total suspended mass

%% =========================================================================
%  FORCE ESTIMATES
% =========================================================================

% Maximum imbalance radial force
F_radial_max = Us_max * Omega_max^2;

% Maximum imbalance axial force (from moment)
F_axial_dynamic = Us_max * Omega_max^2 * h_CoM / R_triangle;

% Static load per axial stinger
F_static_per_stinger = (m_total * 9.81) / 3;

% Total maximum axial load per stinger
F_axial_max = F_static_per_stinger + F_axial_dynamic;

%% =========================================================================
%  AXIAL STINGER CALCULATIONS
% =========================================================================

fprintf('\n=========================================================\n');
fprintf('  STINGER DESIGN CALCULATOR\n');
fprintf('  Material: %s\n', mat_name);
fprintf('=========================================================\n\n');

fprintf('--- FORCE ESTIMATES ---\n');
fprintf('  Max radial imbalance force:     %.4f N\n', F_radial_max);
fprintf('  Static load per axial stinger:  %.4f N\n', F_static_per_stinger);
fprintf('  Max axial load per stinger:     %.4f N\n', F_axial_max);
fprintf('  Max spin speed:                 %.1f rpm\n\n', Omega_max * 60/(2*pi));

fprintf('--- AXIAL STINGERS ---\n');
fprintf('  Diameter:  %.1f mm\n', d_axial*1000);
fprintf('  Length:    %.1f mm\n', L_axial*1000);
fprintf('  Material:  %s\n\n', mat_name);

% 1. Axial stiffness
k_axial_Z = 3 * E * A_axial / L_axial;  % 3 stingers in parallel
fn_axial = (1/(2*pi)) * sqrt(k_axial_Z / m_total);

fprintf('  CHECK 1 — Axial natural frequency\n');
fprintf('    fn = %.1f Hz   (target > %d Hz)\n', fn_axial, fn_target);
if fn_axial > fn_target
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or decrease L\n\n');
end

% 2. Lateral stiffness ratio
k_lat_axial = 3 * E * I_axial / L_axial^3; % per stinger
k_ax_single = E * A_axial / L_axial;        % per stinger
ratio_axial = k_ax_single / k_lat_axial;

fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    k_axial per stinger:   %.2e N/m\n', k_ax_single);
fprintf('    k_lateral per stinger: %.4f N/m\n', k_lat_axial);
fprintf('    Ratio: %.0f : 1   (target > %d : 1)\n', ratio_axial, ratio_target);
if ratio_axial > ratio_target
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — use longer or thinner stinger\n\n');
end

% 3. Buckling (fixed-fixed)
F_crit_axial = (pi^2 * E * I_axial) / L_axial^2;  % fixed-fixed = 4x Euler
SF_buckle_actual = F_crit_axial / F_axial_max;

fprintf('  CHECK 3 — Buckling safety factor\n');
fprintf('    Critical load:     %.1f N\n', F_crit_axial);
fprintf('    Applied load:      %.4f N\n', F_axial_max);
fprintf('    Safety factor:     %.1f   (target > %.1f)\n', SF_buckle_actual, SF_buckle);
if SF_buckle_actual > SF_buckle
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or decrease L\n\n');
end

% 4. Bending stress (from lateral imbalance force on axial stinger)
% Lateral force on each axial stinger from radial imbalance
F_lat_per_stinger = F_radial_max / 3;
sigma_axial = (F_lat_per_stinger * L_axial * d_axial/2) / I_axial;
SF_yield_axial = sigma_y / sigma_axial;

fprintf('  CHECK 4 — Yield safety factor (bending from lateral load)\n');
fprintf('    Max bending stress: %.2f MPa\n', sigma_axial/1e6);
fprintf('    Yield strength:     %.2f MPa\n', sigma_y/1e6);
fprintf('    Safety factor:      %.1f   (target > %.1f)\n', SF_yield_axial, SF_yield);
if SF_yield_axial > SF_yield
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or use stronger material\n\n');
end

% Max lateral deflection of axial stinger under radial force
delta_lat_axial = F_lat_per_stinger / k_lat_axial;
fprintf('  INFO — Lateral deflection of axial stinger under max radial force\n');
fprintf('    Delta = %.4f mm\n\n', delta_lat_axial*1000);

%% =========================================================================
%  RADIAL STINGER CALCULATIONS
% =========================================================================

fprintf('--- RADIAL STINGERS ---\n');
fprintf('  Diameter:  %.1f mm\n', d_radial*1000);
fprintf('  Length:    %.1f mm\n', L_radial*1000);
fprintf('  Material:  %s\n\n', mat_name);

% 1. Axial (measurement direction) natural frequency
% Effective mass for radial stingers = total suspended mass
k_axial_radial = E * A_radial / L_radial;  % single stinger axial stiffness
fn_radial = (1/(2*pi)) * sqrt(k_axial_radial / m_total);

fprintf('  CHECK 1 — Axial (measurement) natural frequency\n');
fprintf('    k_axial (single stinger): %.2e N/m\n', k_axial_radial);
fprintf('    fn = %.1f Hz   (target > %d Hz)\n', fn_radial, fn_target);
if fn_radial > fn_target
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or decrease L\n\n');
end

% 2. Lateral stiffness ratio for radial stinger
k_lat_radial = 3 * E * I_radial / L_radial^3;
ratio_radial = k_axial_radial / k_lat_radial;

fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    k_axial:   %.2e N/m\n', k_axial_radial);
fprintf('    k_lateral: %.4f N/m\n', k_lat_radial);
fprintf('    Ratio: %.0f : 1   (target > %d : 1)\n', ratio_radial, ratio_target);
if ratio_radial > ratio_target
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — use longer or thinner stinger\n\n');
end

% 3. Buckling (radial stingers — max compressive load = max radial force)
F_crit_radial = (pi^2 * E * I_radial) / L_radial^2;
SF_buckle_radial = F_crit_radial / F_radial_max;

fprintf('  CHECK 3 — Buckling safety factor\n');
fprintf('    Critical load:  %.2f N\n', F_crit_radial);
fprintf('    Applied load:   %.4f N\n', F_radial_max);
fprintf('    Safety factor:  %.1f   (target > %.1f)\n', SF_buckle_radial, SF_buckle);
if SF_buckle_radial > SF_buckle
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or decrease L\n\n');
end

% 4. Bending stress on radial stinger (from out-of-plane loads)
% Worst case: full axial load creates bending in radial stinger
sigma_radial = (F_static_per_stinger * L_radial * d_radial/2) / I_radial;
SF_yield_radial = sigma_y / sigma_radial;

fprintf('  CHECK 4 — Yield safety factor (bending from out-of-plane load)\n');
fprintf('    Max bending stress: %.2f MPa\n', sigma_radial/1e6);
fprintf('    Yield strength:     %.2f MPa\n', sigma_y/1e6);
fprintf('    Safety factor:      %.1f   (target > %.1f)\n', SF_yield_radial, SF_yield);
if SF_yield_radial > SF_yield
    fprintf('    RESULT: PASS\n\n');
else
    fprintf('    RESULT: FAIL — increase d or use stronger material\n\n');
end

%% =========================================================================
%  MEASUREMENT SENSITIVITY
% =========================================================================

fprintf('--- MEASUREMENT SENSITIVITY ---\n');

% Minimum detectable imbalance (assume sensor resolution of 0.01 N)
sensor_resolution = 0.01;   % [N] — update when sensor specs known
Us_min = sensor_resolution / Omega_max^2;
fprintf('  Assumed sensor resolution:      %.3f N\n', sensor_resolution);
fprintf('  Min detectable static imbalance: %.4f g·mm\n', Us_min*1e6);
fprintf('  Rocket Lab spec (static):        26 g·mm\n');
if Us_min*1e6 < 26
    fprintf('  RESULT: Can resolve to spec\n\n');
else
    fprintf('  RESULT: May not resolve to spec — need better sensor\n\n');
end

% Torque measurement sensitivity from Rx1-Rx2
F_Mz_resolution = sensor_resolution;
Mz_resolution = F_Mz_resolution * s_separation / 2;
fprintf('  Mz resolution (from Rx1-Rx2 separation):\n');
fprintf('    Sensor separation s = %.1f mm\n', s_separation*1000);
fprintf('    Min detectable Mz = %.5f N·m\n\n', Mz_resolution);

%% =========================================================================
%  PARAMETRIC STUDY — Diameter vs Natural Frequency
% =========================================================================

fprintf('--- PARAMETRIC STUDY ---\n');
fprintf('  Axial stinger: fn vs diameter (L = %.0f mm)\n\n', L_axial*1000);
fprintf('  Diameter [mm]  |  fn [Hz]  |  Buckle SF  |  Ratio\n');
fprintf('  ---------------------------------------------\n');

d_range = (1:0.5:6) * 1e-3;
for d_i = d_range
    A_i = pi*d_i^2/4;
    I_i = pi*d_i^4/64;
    k_i = 3*E*A_i/L_axial;
    fn_i = (1/(2*pi))*sqrt(k_i/m_total);
    Fcrit_i = pi^2*E*I_i/L_axial^2;
    SF_i = Fcrit_i/F_axial_max;
    lat_i = E*A_i/L_axial / (3*E*I_i/L_axial^3);
    fprintf('  %5.1f          |  %7.1f  |  %9.1f  |  %.0f\n', ...
        d_i*1000, fn_i, SF_i, lat_i);
end

%% =========================================================================
%  PARAMETRIC STUDY — Plot
% =========================================================================

figure('Name','Stinger Design — Diameter vs Performance','Position',[100 100 900 600]);

d_plot = linspace(0.5e-3, 6e-3, 200);
fn_plot = zeros(size(d_plot));
SF_plot = zeros(size(d_plot));
ratio_plot = zeros(size(d_plot));

for i = 1:length(d_plot)
    d_i = d_plot(i);
    A_i = pi*d_i^2/4;
    I_i = pi*d_i^4/64;
    k_i = 3*E*A_i/L_axial;
    fn_plot(i) = (1/(2*pi))*sqrt(k_i/m_total);
    Fcrit_i = pi^2*E*I_i/L_axial^2;
    SF_plot(i) = Fcrit_i/F_axial_max;
    ratio_plot(i) = (E*A_i/L_axial) / (3*E*I_i/L_axial^3);
end

subplot(3,1,1);
plot(d_plot*1000, fn_plot, 'b-', 'LineWidth', 2); hold on;
yline(fn_target, 'r--', 'LineWidth', 1.5);
xlabel('Diameter [mm]'); ylabel('fn [Hz]');
title('Natural frequency vs diameter (axial stingers)');
legend('fn', sprintf('Target = %d Hz', fn_target));
grid on;

subplot(3,1,2);
plot(d_plot*1000, SF_plot, 'g-', 'LineWidth', 2); hold on;
yline(SF_buckle, 'r--', 'LineWidth', 1.5);
xlabel('Diameter [mm]'); ylabel('Safety factor');
title('Buckling safety factor vs diameter');
legend('SF buckling', sprintf('Target = %.0f', SF_buckle));
ylim([0 min(max(SF_plot), 200)]);
grid on;

subplot(3,1,3);
semilogy(d_plot*1000, ratio_plot, 'm-', 'LineWidth', 2); hold on;
yline(ratio_target, 'r--', 'LineWidth', 1.5);
xlabel('Diameter [mm]'); ylabel('k_{axial}/k_{lateral}');
title('Directional stiffness ratio vs diameter');
legend('Stiffness ratio', sprintf('Target = %d', ratio_target));
grid on;

sgtitle(sprintf('Stinger Design — %s, L = %.0f mm, m = %.2f kg', ...
    mat_name, L_axial*1000, m_total), 'FontWeight', 'bold');

%% =========================================================================
%  FINAL SUMMARY
% =========================================================================

fprintf('\n=========================================================\n');
fprintf('  FINAL SUMMARY\n');
fprintf('=========================================================\n');
fprintf('  AXIAL STINGERS  d=%.1fmm  L=%.0fmm  %s\n', ...
    d_axial*1000, L_axial*1000, mat_name);
checks_axial = [fn_axial > fn_target, ...
                ratio_axial > ratio_target, ...
                SF_buckle_actual > SF_buckle, ...
                SF_yield_axial > SF_yield];
labels = {'fn check', 'Stiffness ratio', 'Buckling SF', 'Yield SF'};
for i = 1:4
    if checks_axial(i)
        fprintf('    [PASS] %s\n', labels{i});
    else
        fprintf('    [FAIL] %s\n', labels{i});
    end
end

fprintf('\n  RADIAL STINGERS  d=%.1fmm  L=%.0fmm  %s\n', ...
    d_radial*1000, L_radial*1000, mat_name);
checks_radial = [fn_radial > fn_target, ...
                 ratio_radial > ratio_target, ...
                 SF_buckle_radial > SF_buckle, ...
                 SF_yield_radial > SF_yield];
for i = 1:4
    if checks_radial(i)
        fprintf('    [PASS] %s\n', labels{i});
    else
        fprintf('    [FAIL] %s\n', labels{i});
    end
end

if all(checks_axial) && all(checks_radial)
    fprintf('\n  ALL CHECKS PASSED — design is viable\n');
else
    fprintf('\n  SOME CHECKS FAILED — adjust geometry and re-run\n');
end
fprintf('=========================================================\n\n');

