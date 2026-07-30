% =========================================================================
% STINGER DESIGN CALCULATOR  v2
% RWA Microvibration & Imbalance Measurement Device
% =========================================================================
% Updates from v1:
%   - Added z_r: radial sensor height above axial sensor plane
%   - Added r_rotor: rotor outer radius for correction mass calculation
%   - Added Omega_test: separate test speed for imbalance measurement
%   - Added DAQ/sensor signal chain checks (fs, S_sensor, V_DAQ, N_avg)
%   - Corrected moment equations: effective arm = (h_CoM - z_r)
%   - Added dynamic imbalance separation using corrected moments
%   - Added correction mass outputs (De Munter equations)
%   - Added signal level checks for DAQ compatibility
% =========================================================================
% Instructions:
%   1. Fill in ALL inputs marked *** UPDATE ***
%   2. Run the script
%   3. Check all PASS/FAIL results
%   4. Adjust geometry if any checks fail
% =========================================================================

clc; clear; close all;

%% =========================================================================
%  SECTION 1 — RWA PARAMETERS
% =========================================================================

m_RWA           = 1;          % RWA total mass [kg]              *** UPDATE ***
Omega_max       = 3000*2*pi/60; % Maximum spin speed [rad/s]       *** UPDATE ***
Omega_test      = 1000*2*pi/60; % Test speed for imbalance [rad/s] *** UPDATE ***
Us_max          = 26e-6;        % Max static imbalance [kg·m]      (26 g·mm)
Ud_max          = 800e-9;       % Max dynamic imbalance [kg·m²]    (800 g·mm²)

r_rotor         = 0.045;         % Rotor outer radius at            *** UPDATE ***
                                 % correction plane [m]

%% =========================================================================
%  SECTION 2 — DEVICE GEOMETRY
% =========================================================================

% Stinger lengths
L_axial         = 0.1;         % Axial stinger length [m]         *** UPDATE ***
L_radial        = 0.05;         % Radial stinger length [m]        *** UPDATE ***

h_CoM           = 0.065 + 0.075; % Height of rotor CoM above      *** UPDATE ***
                                  % axial sensor plane [m]

mount_t = 0.01;                 % Thicknes of mounting plate

% Axial stinger triangle
R_triangle = 0.05;         % Circumradius of axial stinger    *** UPDATE ***
                                 % triangle [m]

% Radial sensor geometry
z_r = 0.065;         % Height of ALL radial sensors     *** UPDATE ***
                                 % above axial sensor plane [m]
                                 % (all 3 radial sensors in plane)

s_separation = 0.115;         % Horizontal separation between    *** UPDATE ***
                                 % Rx1 and Rx2 [m]

% Derived effective moment arm
h_eff           = h_CoM - z_r;  % Effective moment arm [m]
                                 % = h_CoM - z_r
                                 % (radial stinger reaction reduces moment)

%% =========================================================================
%  SECTION 3 — STINGER GEOMETRY
% =========================================================================

d_axial         = 0.002;        % Axial stinger diameter [m]       *** UPDATE ***
d_radial        = 0.002;        % Radial stinger diameter [m]      *** UPDATE ***

%% =========================================================================
%  SECTION 4 — MATERIAL PROPERTIES
% =========================================================================
% Steel (default)
E               = 200e9;        % Young's modulus [Pa]
rho             = 7800;         % Density [kg/m³]
sigma_y         = 350e6;        % Yield strength [Pa]
mat_name        = 'Steel';

% Aluminium — uncomment to use
% E             = 69e9;
% rho           = 2700;
% sigma_y       = 270e6;
% mat_name      = 'Aluminium 6061';

%% =========================================================================
%  SECTION 5 — SENSOR AND DAQ PARAMETERS
% =========================================================================

sensor_resolution = 0.01;       % Min detectable force [N]         *** UPDATE ***
S_sensor          = 100e-3;     % Sensor sensitivity [V/N]         *** UPDATE ***
                                 % (mV/N × 1e-3, or pC/N for charge)
V_DAQ             = 5.0;        % DAQ input voltage range [V]      *** UPDATE ***
fs                = 10000;      % DAQ sample rate [Hz]             *** UPDATE ***
N_avg             = 20;         % Number of revolutions averaged   *** UPDATE ***
f_measure_max     = 500;        % Max measurement frequency [Hz]

%% =========================================================================
%  SECTION 6 — DESIGN TARGETS
% =========================================================================

fn_target         = 500;       % Min natural frequency [Hz]
SF_buckle_target  = 5;          % Min buckling safety factor
SF_yield_target   = 3;          % Min yield safety factor
ratio_target      = 3000;      % Min axial/lateral stiffness ratio

%% =========================================================================
%  DERIVED QUANTITIES
% =========================================================================

% Cross-section properties — axial stingers
A_ax    = pi * d_axial^2 / 4;
I_ax    = pi * d_axial^4 / 64;

% Cross-section properties — radial stingers
A_rad   = pi * d_radial^2 / 4;
I_rad   = pi * d_radial^4 / 64;

% Total suspended mass
m_plate = 0.2;                  % Mounting plate mass estimate [kg] *** UPDATE ***
m_total = m_RWA + m_plate;

%% =========================================================================
%  FORCE AND MOMENT ESTIMATES
% =========================================================================

% Maximum imbalance radial force (at max speed)
F_radial_max    = Us_max * Omega_max^2;

% Maximum imbalance radial force (at test speed)
F_radial_test   = Us_max * Omega_test^2;

% Static load per axial stinger
F_static_each   = (m_total * 9.81) / 3;

% Dynamic axial load per stinger from overturning moment
% Uses corrected effective moment arm (h_CoM - z_r)
M_overturn      = F_radial_max * h_eff;
F_axial_dyn     = M_overturn / (R_triangle * sqrt(3));

% Total maximum axial load per stinger
F_axial_max     = F_static_each + F_axial_dyn;

% Maximum moment at axial sensor plane (corrected)
Mx_max          = F_radial_max * h_eff;

% Dynamic imbalance moment
Md_max          = Ud_max * Omega_max^2;

% Maximum Mz (torque) from differential Rx reading
Mz_expected     = Ud_max * Omega_max^2;  % approximate

%% =========================================================================
%  PRINT HEADER
% =========================================================================

fprintf('\n');
fprintf('=================================================================\n');
fprintf('  STINGER DESIGN CALCULATOR  v2\n');
fprintf('  Material: %s\n', mat_name);
fprintf('=================================================================\n\n');

fprintf('--- RWA PARAMETERS ---\n');
fprintf('  RWA mass:              %.3f kg\n', m_RWA);
fprintf('  Total suspended mass:  %.3f kg\n', m_total);
fprintf('  Max spin speed:        %.0f rpm\n', Omega_max*60/(2*pi));
fprintf('  Test spin speed:       %.0f rpm\n', Omega_test*60/(2*pi));
fprintf('  Max static imbalance:  %.1f g·mm\n', Us_max*1e6);
fprintf('  Max dynamic imbalance: %.1f g·mm²\n\n', Ud_max*1e9);

fprintf('--- GEOMETRY ---\n');
fprintf('  h_CoM:        %.1f mm  (CoM above axial sensor plane)\n', h_CoM*1000);
fprintf('  z_r:          %.1f mm  (radial sensors above axial plane)\n', z_r*1000);
fprintf('  h_eff:        %.1f mm  (effective moment arm = h_CoM - z_r)\n', h_eff*1000);
fprintf('  R_triangle:   %.1f mm  (axial stinger circumradius)\n', R_triangle*1000);
fprintf('  s_separation: %.1f mm  (Rx1-Rx2 horizontal separation)\n\n', s_separation*1000);

fprintf('--- FORCE AND MOMENT ESTIMATES ---\n');
fprintf('  Max radial force (max speed):    %.4f N\n', F_radial_max);
fprintf('  Max radial force (test speed):   %.4f N\n', F_radial_test);
fprintf('  Static load per axial stinger:   %.4f N\n', F_static_each);
fprintf('  Dynamic axial load per stinger:  %.4f N\n', F_axial_dyn);
fprintf('  Total max axial load per stinger:%.4f N\n', F_axial_max);
fprintf('  Max overturning moment at axial plane: %.6f N·m\n', Mx_max);
fprintf('  Max dynamic imbalance moment:    %.6f N·m\n\n', Md_max);

%% =========================================================================
%  AXIAL STINGER CHECKS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  AXIAL STINGERS   d = %.1f mm   L = %.0f mm\n', ...
    d_axial*1000, L_axial*1000);
fprintf('=================================================================\n\n');

% Stiffnesses
k_ax_single     = E * A_ax / L_axial;          % axial stiffness per stinger
k_ax_total      = 3 * k_ax_single;             % 3 stingers in parallel
k_lat_ax        = 3 * E * I_ax / L_axial^3;   % lateral stiffness per stinger

% CHECK 1 — Axial natural frequency
fn_ax = (1/(2*pi)) * sqrt(k_ax_total / m_total);
pass1 = fn_ax > fn_target;
fprintf('  CHECK 1 — Axial natural frequency\n');
fprintf('    k_axial (3 stingers): %.3e N/m\n', k_ax_total);
fprintf('    fn = %.1f Hz   target > %d Hz\n', fn_ax, fn_target);
fprintf('    %s\n\n', result_str(pass1));

% CHECK 2 — Axial/lateral stiffness ratio
ratio_ax = k_ax_single / k_lat_ax;
pass2 = ratio_ax > ratio_target;
fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    k_axial per stinger:    %.3e N/m\n', k_ax_single);
fprintf('    k_lateral per stinger:  %.4f N/m\n', k_lat_ax);
fprintf('    Ratio = %.0f : 1   target > %d : 1\n', ratio_ax, ratio_target);
fprintf('    %s\n\n', result_str(pass2));

% CHECK 3 — Buckling (fixed-fixed)
F_crit_ax = pi^2 * E * I_ax / L_axial^2;
SF_bk_ax  = F_crit_ax / F_axial_max;
pass3 = SF_bk_ax > SF_buckle_target;
fprintf('  CHECK 3 — Buckling (fixed-fixed)\n');
fprintf('    Critical load: %.2f N\n', F_crit_ax);
fprintf('    Applied load:  %.4f N\n', F_axial_max);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_bk_ax, SF_buckle_target);
fprintf('    %s\n\n', result_str(pass3));

% CHECK 4 — Bending stress from lateral imbalance force
F_lat_each = F_radial_max / 3;
sig_ax = (F_lat_each * L_axial * d_axial/2) / I_ax;
SF_y_ax = sigma_y / sig_ax;
pass4 = SF_y_ax > SF_yield_target;
fprintf('  CHECK 4 — Yield (bending from lateral load)\n');
fprintf('    Lateral force per stinger: %.4f N\n', F_lat_each);
fprintf('    Max bending stress:        %.2f MPa\n', sig_ax/1e6);
fprintf('    Yield strength:            %.0f MPa\n', sigma_y/1e6);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_y_ax, SF_yield_target);
fprintf('    %s\n\n', result_str(pass4));

% INFO — Lateral deflection
delta_lat_ax = F_lat_each / k_lat_ax;
fprintf('  INFO — Lateral deflection under max radial force\n');
fprintf('    Delta = %.4f mm\n\n', delta_lat_ax*1000);

checks_ax = [pass1, pass2, pass3, pass4];

%% =========================================================================
%  RADIAL STINGER CHECKS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  RADIAL STINGERS  d = %.1f mm   L = %.0f mm\n', ...
    d_radial*1000, L_radial*1000);
fprintf('=================================================================\n\n');

% Stiffnesses
k_rad_single    = E * A_rad / L_radial;
k_lat_rad       = 3 * E * I_rad / L_radial^3;

% CHECK 1 — Axial (measurement direction) natural frequency
fn_rad = (1/(2*pi)) * sqrt(k_rad_single / m_total);
pass5 = fn_rad > fn_target;
fprintf('  CHECK 1 — Measurement direction natural frequency\n');
fprintf('    k_axial (single): %.3e N/m\n', k_rad_single);
fprintf('    fn = %.1f Hz   target > %d Hz\n', fn_rad, fn_target);
fprintf('    %s\n\n', result_str(pass5));

% CHECK 2 — Axial/lateral stiffness ratio
ratio_rad = k_rad_single / k_lat_rad;
pass6 = ratio_rad > ratio_target;
fprintf('  CHECK 2 — Axial/lateral stiffness ratio\n');
fprintf('    k_axial:   %.3e N/m\n', k_rad_single);
fprintf('    k_lateral: %.4f N/m\n', k_lat_rad);
fprintf('    Ratio = %.0f : 1   target > %d : 1\n', ratio_rad, ratio_target);
fprintf('    %s\n\n', result_str(pass6));

% CHECK 3 — Buckling (max compressive = max radial force)
F_crit_rad = pi^2 * E * I_rad / L_radial^2;
SF_bk_rad  = F_crit_rad / F_radial_max;
pass7 = SF_bk_rad > SF_buckle_target;
fprintf('  CHECK 3 — Buckling\n');
fprintf('    Critical load: %.2f N\n', F_crit_rad);
fprintf('    Applied load:  %.4f N\n', F_radial_max);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_bk_rad, SF_buckle_target);
fprintf('    %s\n\n', result_str(pass7));

% CHECK 4 — Bending stress from out-of-plane axial loads
k_lat_rad_vert  = 3 * E * I_rad / L_radial^3;
k_ax_per        = E * A_ax / L_axial;
frac_weight_rad = k_lat_rad_vert / (k_ax_per + k_lat_rad_vert);
F_bend_radial   = frac_weight_rad * m_total * 9.81 / 3;
sig_rad = (F_bend_radial * L_radial * d_radial/2) / I_rad;
SF_y_rad = sigma_y / sig_rad;
pass8 = SF_y_rad > SF_yield_target;
fprintf('  CHECK 4 — Yield (bending from out-of-plane load)\n');
fprintf('    Out-of-plane load:  %.4f N\n', F_static_each);
fprintf('    Max bending stress: %.2f MPa\n', sig_rad/1e6);
fprintf('    Yield strength:     %.0f MPa\n', sigma_y/1e6);
fprintf('    Safety factor: %.1f   target > %.1f\n', SF_y_rad, SF_yield_target);
fprintf('    %s\n\n', result_str(pass8));

checks_rad = [pass5, pass6, pass7, pass8];

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

% CHECK — Frequency resolution
delta_f = fs / (N_avg * Omega_test/(2*pi) * fs/Omega_test*2*pi);
% Simpler: one revolution at test speed takes T = 2pi/Omega_test seconds
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

% CHECK — Signal level at max force
V_max_signal = F_radial_max * S_sensor;
pass10 = V_max_signal < V_DAQ;
fprintf('  CHECK — Signal level within DAQ range\n');
fprintf('    Max radial force:    %.4f N\n', F_radial_max);
fprintf('    Sensor sensitivity:  %.0f mV/N\n', S_sensor*1000);
fprintf('    Max signal voltage:  %.4f V\n', V_max_signal);
fprintf('    DAQ range:           ±%.1f V\n', V_DAQ);
fprintf('    %s\n\n', result_str(pass10));

% CHECK — Signal level at minimum detectable force
V_min_signal = sensor_resolution * S_sensor;
fprintf('  INFO — Signal at minimum detectable force\n');
fprintf('    Min force:           %.4f N\n', sensor_resolution);
fprintf('    Min signal voltage:  %.4f mV\n', V_min_signal*1000);
fprintf('    (DAQ must resolve this — check ADC bit depth)\n\n');

checks_sig = [pass9, pass10];

%% =========================================================================
%  MEASUREMENT SENSITIVITY
% =========================================================================

fprintf('=================================================================\n');
fprintf('  MEASUREMENT SENSITIVITY\n');
fprintf('=================================================================\n\n');

% Static imbalance at test speed
Us_min = sensor_resolution / Omega_test^2;
fprintf('  Static imbalance sensitivity (at test speed)\n');
fprintf('    Test speed:                   %.0f rpm\n', Omega_test*60/(2*pi));
fprintf('    Sensor resolution:            %.4f N\n', sensor_resolution);
fprintf('    Min detectable Us:            %.4f g·mm\n', Us_min*1e6);
fprintf('    Rocket Lab spec:              26 g·mm\n');
if Us_min*1e6 < 26
    fprintf('    Can resolve to spec\n\n');
else
    fprintf('    Cannot resolve to spec — increase test speed or improve sensor\n\n');
end

% Dynamic imbalance sensitivity
% Dynamic imbalance appears in residual axial moment
% Min detectable Mx = sensor_resolution × R_triangle (differential)
Mx_min = sensor_resolution * R_triangle;
Ud_min = Mx_min / Omega_test^2;
fprintf('  Dynamic imbalance sensitivity\n');
fprintf('    Min detectable moment:        %.6f N·m\n', Mx_min);
fprintf('    Min detectable Ud:            %.2f g·mm²\n', Ud_min*1e9);
fprintf('    Rocket Lab spec:              800 g·mm²\n');
if Ud_min*1e9 < 800
    fprintf('    Can resolve to spec\n\n');
else
    fprintf('    Cannot resolve to spec — check geometry or sensor\n\n');
end

% Torque (Mz) sensitivity
Mz_min = sensor_resolution * s_separation / 2;
fprintf('  Torque (Mz) sensitivity\n');
fprintf('    Rx1-Rx2 separation:           %.1f mm\n', s_separation*1000);
fprintf('    Min detectable Mz:            %.5f N·m\n\n', Mz_min);

%% =========================================================================
%  DYNAMIC IMBALANCE SEPARATION — KEY EQUATIONS
% =========================================================================

fprintf('=================================================================\n');
fprintf('  DYNAMIC IMBALANCE SEPARATION — EQUATION SUMMARY\n');
fprintf('=================================================================\n\n');

fprintf('  Using corrected effective moment arm h_eff = h_CoM - z_r\n');
fprintf('  h_CoM = %.1f mm   z_r = %.1f mm   h_eff = %.1f mm\n\n', ...
    h_CoM*1000, z_r*1000, h_eff*1000);

fprintf('  Step 1 — Static imbalance from radial sensors:\n');
fprintf('    F_radial = sqrt(Fx² + Fy²)\n');
fprintf('    Us = F_radial / Omega²\n');
fprintf('    phi = atan2(Fy, Fx)  [direction of heavy spot]\n\n');

fprintf('  Step 2 — Remove static contribution from axial moments:\n');
fprintf('    The static imbalance force at h_CoM, reacted by\n');
fprintf('    radial stingers at z_r, creates net moment:\n');
fprintf('    M_static_x = Fy × h_eff = Fy × (h_CoM - z_r)\n');
fprintf('    M_static_y = Fx × h_eff = Fx × (h_CoM - z_r)\n\n');

fprintf('  Step 3 — Residual = dynamic imbalance:\n');
fprintf('    M_dyn_x = Mx_measured - M_static_x\n');
fprintf('    M_dyn_y = My_measured - M_static_y\n\n');

fprintf('  Step 4 — Dynamic imbalance magnitude and direction:\n');
fprintf('    Ud = sqrt(M_dyn_x² + M_dyn_y²) / Omega²\n');
fprintf('    psi = atan2(M_dyn_y, M_dyn_x)  [direction]\n\n');

fprintf('  Step 5 — Correction masses (De Munter equations):\n');
fprintf('    Two correction planes A and B at heights hA, hB\n');
fprintf('    from rotor CoM, at radius r = %.1f mm\n', r_rotor*1000);
fprintf('    Static correction:\n');
fprintf('      mA_s = Us × hB / [r × (hA + hB)]\n');
fprintf('      mB_s = Us × hA / [r × (hA + hB)]\n');
fprintf('    Dynamic correction:\n');
fprintf('      mA_d = Ud / (2 × r × hA)\n');
fprintf('      mB_d = Ud / (2 × r × hB)\n\n');

%% =========================================================================
%  PARAMETRIC STUDY
% =========================================================================

fprintf('=================================================================\n');
fprintf('  PARAMETRIC STUDY — Axial stinger diameter\n');
fprintf('  L = %.0f mm   Material: %s\n', L_axial*1000, mat_name);
fprintf('=================================================================\n\n');
fprintf('  d [mm] | fn [Hz] | Buckle SF | Ratio      | Yield SF\n');
fprintf('  -------------------------------------------------------\n');

d_range = (1:0.5:6) * 1e-3;
for d_i = d_range
    A_i     = pi*d_i^2/4;
    I_i     = pi*d_i^4/64;
    k_i     = 3*E*A_i/L_axial;
    fn_i    = (1/(2*pi))*sqrt(k_i/m_total);
    Fcrit_i = pi^2*E*I_i/L_axial^2;
    SF_bk_i = Fcrit_i/F_axial_max;
    ratio_i = (E*A_i/L_axial)/(3*E*I_i/L_axial^3);
    F_lat_i = F_radial_max/3;
    sig_i   = (F_lat_i*L_axial*d_i/2)/I_i;
    SF_y_i  = sigma_y/sig_i;
    fprintf('  %5.1f  | %7.1f | %9.1f | %10.0f | %.1f\n', ...
        d_i*1000, fn_i, SF_bk_i, ratio_i, SF_y_i);
end

%% =========================================================================
%  PLOTS
% =========================================================================

figure('Name','Stinger Design v2','Position',[50 50 1000 700]);

d_plot  = linspace(0.5e-3, 6e-3, 300);
fn_p    = zeros(size(d_plot));
SF_bk_p = zeros(size(d_plot));
ratio_p = zeros(size(d_plot));
SF_y_p  = zeros(size(d_plot));

for i = 1:length(d_plot)
    d_i     = d_plot(i);
    A_i     = pi*d_i^2/4;
    I_i     = pi*d_i^4/64;
    k_i     = 3*E*A_i/L_axial;
    fn_p(i) = (1/(2*pi))*sqrt(k_i/m_total);
    Fcrit_i = pi^2*E*I_i/L_axial^2;
    SF_bk_p(i) = Fcrit_i/F_axial_max;
    ratio_p(i) = (E*A_i/L_axial)/(3*E*I_i/L_axial^3);
    F_lat_i = F_radial_max/3;
    sig_i   = (F_lat_i*L_axial*d_i/2)/I_i;
    SF_y_p(i) = sigma_y/sig_i;
end

subplot(2,2,1);
plot(d_plot*1000, fn_p, 'b-', 'LineWidth',2); hold on;
yline(fn_target,'r--','LineWidth',1.5);
xlabel('Diameter [mm]'); ylabel('f_n [Hz]');
title('Natural frequency vs diameter');
legend('f_n','Target','Location','northwest');
grid on;

subplot(2,2,2);
plot(d_plot*1000, SF_bk_p, 'g-', 'LineWidth',2); hold on;
yline(SF_buckle_target,'r--','LineWidth',1.5);
xlabel('Diameter [mm]'); ylabel('Safety factor');
title('Buckling safety factor vs diameter');
ylim([0 min(max(SF_bk_p),100)]);
legend('SF buckle','Target','Location','northwest');
grid on;

subplot(2,2,3);
semilogy(d_plot*1000, ratio_p, 'm-', 'LineWidth',2); hold on;
yline(ratio_target,'r--','LineWidth',1.5);
xlabel('Diameter [mm]'); ylabel('k_{ax}/k_{lat}');
title('Directional stiffness ratio vs diameter');
legend('Ratio','Target','Location','northeast');
grid on;

subplot(2,2,4);
plot(d_plot*1000, SF_y_p, 'c-', 'LineWidth',2); hold on;
yline(SF_yield_target,'r--','LineWidth',1.5);
xlabel('Diameter [mm]'); ylabel('Safety factor');
title('Yield safety factor vs diameter');
legend('SF yield','Target','Location','northwest');
grid on;

sgtitle(sprintf('Axial Stinger Design — %s, L = %.0f mm, m_{total} = %.2f kg', ...
    mat_name, L_axial*1000, m_total), 'FontWeight','bold');

%% =========================================================================
%  FINAL SUMMARY
% =========================================================================

fprintf('\n=================================================================\n');
fprintf('  FINAL SUMMARY\n');
fprintf('=================================================================\n');

fprintf('\n  AXIAL STINGERS   d=%.1fmm  L=%.0fmm  %s\n', ...
    d_axial*1000, L_axial*1000, mat_name);
ax_labels = {'Natural frequency','Stiffness ratio','Buckling SF','Yield SF'};
for i = 1:4
    fprintf('    [%s] %s\n', pass_str(checks_ax(i)), ax_labels{i});
end

fprintf('\n  RADIAL STINGERS  d=%.1fmm  L=%.0fmm  %s\n', ...
    d_radial*1000, L_radial*1000, mat_name);
for i = 1:4
    fprintf('    [%s] %s\n', pass_str(checks_rad(i)), ax_labels{i});
end

fprintf('\n  SIGNAL CHAIN\n');
sig_labels = {'Nyquist criterion','Signal within DAQ range'};
for i = 1:2
    fprintf('    [%s] %s\n', pass_str(checks_sig(i)), sig_labels{i});
end

all_pass = all(checks_ax) && all(checks_rad) && all(checks_sig);
fprintf('\n');
if all_pass
    fprintf('  ALL CHECKS PASSED\n');
else
    fprintf('  SOME CHECKS FAILED — adjust inputs and re-run\n');
end
fprintf('=================================================================\n\n');

%% =========================================================================
%  HELPER FUNCTIONS
% =========================================================================

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
%% =========================================================================
%  OPTIMISATION — Sweep d and L independently and in combination
%  Finds all geometry combinations that pass all four checks
% =========================================================================

fprintf('\n=================================================================\n');
fprintf('  OPTIMISATION STUDY\n');
fprintf('  Sweeping d_axial, d_radial, L_axial, L_radial\n');
fprintf('=================================================================\n\n');

% --- Search ranges ---
d_ax_range  = (1.0:0.2:4.0) * 1e-3;   % axial diameter [m]
d_rad_range = (1.0:0.2:4.0) * 1e-3;   % radial diameter [m]
L_ax_range  = (30:5:150)   * 1e-3;    % axial length [m]
L_rad_range = (30:5:150)   * 1e-3;    % radial length [m]

% --- Storage for feasible solutions ---
results = [];  % each row: [d_ax, d_rad, L_ax, L_rad, fn_ax, fn_rad, ratio_ax, ratio_rad, SF_bk_ax, SF_bk_rad, SF_y_ax, SF_y_rad]

n_total = length(d_ax_range)*length(d_rad_range)*length(L_ax_range)*length(L_rad_range);
fprintf('  Evaluating %d combinations...\n\n', n_total);

for d_ax = d_ax_range
    for d_rad = d_rad_range
        for L_ax = L_ax_range
            for L_rad = L_rad_range

                % Cross-section properties
                A_ax_i = pi*d_ax^2/4;
                I_ax_i = pi*d_ax^4/64;
                A_rad_i = pi*d_rad^2/4;
                I_rad_i = pi*d_rad^4/64;

                % --- AXIAL STINGER CHECKS ---

                % Natural frequency
                k_ax_i  = 3*E*A_ax_i/L_ax;
                fn_ax_i = (1/(2*pi))*sqrt(k_ax_i/m_total);

                % Stiffness ratio
                k_lat_ax_i = 3*E*I_ax_i/L_ax^3;
                ratio_ax_i = k_ax_i/3 / k_lat_ax_i;

                % Buckling
                F_static_i   = (m_total*9.81)/3;
                F_axial_max_i = F_static_i + F_radial_max*h_eff/(R_triangle*sqrt(3));
                F_crit_ax_i  = pi^2*E*I_ax_i/L_ax^2;
                SF_bk_ax_i   = F_crit_ax_i/F_axial_max_i;

                % Yield — load sharing corrected
                k_lat_rad_v  = 3*E*I_rad_i/L_rad^3;
                k_ax_per     = E*A_ax_i/L_ax;
                frac_w       = k_lat_rad_v/(k_ax_per + k_lat_rad_v);
                F_bend_ax    = (F_radial_max/3);
                sig_ax_i     = (F_bend_ax*L_ax*d_ax/2)/I_ax_i;
                SF_y_ax_i    = sigma_y/sig_ax_i;

                % --- RADIAL STINGER CHECKS ---

                % Natural frequency
                k_rad_i  = E*A_rad_i/L_rad;
                fn_rad_i = (1/(2*pi))*sqrt(k_rad_i/m_total);

                % Stiffness ratio
                k_lat_rad_i = 3*E*I_rad_i/L_rad^3;
                ratio_rad_i = k_rad_i/k_lat_rad_i;

                % Buckling
                F_crit_rad_i = pi^2*E*I_rad_i/L_rad^2;
                SF_bk_rad_i  = F_crit_rad_i/F_radial_max;

                % Yield
                F_bend_rad_i = frac_w*m_total*9.81/3;
                sig_rad_i    = (F_bend_rad_i*L_rad*d_rad/2)/I_rad_i;
                SF_y_rad_i   = sigma_y/max(sig_rad_i, 1e-10);

                % --- CHECK ALL TARGETS ---
                pass_fn_ax  = fn_ax_i  >= fn_target;
                pass_fn_rad = fn_rad_i >= fn_target;
                pass_rt_ax  = ratio_ax_i  >= ratio_target;
                pass_rt_rad = ratio_rad_i >= ratio_target;
                pass_bk_ax  = SF_bk_ax_i  >= SF_buckle_target;
                pass_bk_rad = SF_bk_rad_i >= SF_buckle_target;
                pass_y_ax   = SF_y_ax_i   >= SF_yield_target;
                pass_y_rad  = SF_y_rad_i  >= SF_yield_target;

                all_pass_i = pass_fn_ax && pass_fn_rad && ...
                             pass_rt_ax && pass_rt_rad && ...
                             pass_bk_ax && pass_bk_rad && ...
                             pass_y_ax  && pass_y_rad;

                if all_pass_i
                    results(end+1,:) = [d_ax*1000, d_rad*1000, ...
                                        L_ax*1000, L_rad*1000, ...
                                        fn_ax_i, fn_rad_i, ...
                                        ratio_ax_i, ratio_rad_i, ...
                                        SF_bk_ax_i, SF_bk_rad_i, ...
                                        SF_y_ax_i, SF_y_rad_i]; %#ok
                end
            end
        end
    end
end

fprintf('  Found %d feasible combinations out of %d total.\n\n', ...
    size(results,1), n_total);

if isempty(results)
    fprintf('  NO feasible combinations found.\n');
    fprintf('  Consider relaxing targets or expanding search ranges.\n\n');
else
    % Sort by fn_axial ascending (most constrained first)
    results = sortrows(results, 5);

    fprintf('  Top 10 feasible combinations (sorted by axial fn):\n\n');
    fprintf('  d_ax  d_rad  L_ax  L_rad | fn_ax  fn_rad | ratio_ax ratio_rad | SF_bk_ax SF_y_ax\n');
    fprintf('  [mm]  [mm]   [mm]  [mm]  | [Hz]   [Hz]   |                   |                  \n');
    fprintf('  ---------------------------------------------------------------------------------\n');

    n_show = min(10, size(results,1));
    for i = 1:n_show
        r = results(i,:);
        fprintf('  %4.1f  %4.1f   %4.0f  %4.0f  | %6.1f %6.1f | %8.0f %8.0f | %7.1f  %6.1f\n', ...
            r(1), r(2), r(3), r(4), r(5), r(6), r(7), r(8), r(9), r(11));
    end

    fprintf('\n  Best combination (lowest fn_axial that passes all checks):\n');
    r = results(1,:);
    fprintf('    d_axial  = %.1f mm\n', r(1));
    fprintf('    d_radial = %.1f mm\n', r(2));
    fprintf('    L_axial  = %.0f mm\n', r(3));
    fprintf('    L_radial = %.0f mm\n', r(4));
    fprintf('    fn_axial  = %.1f Hz\n', r(5));
    fprintf('    fn_radial = %.1f Hz\n', r(6));
    fprintf('    Stiffness ratio axial  = %.0f\n', r(7));
    fprintf('    Stiffness ratio radial = %.0f\n', r(8));
    fprintf('    Buckling SF axial  = %.1f\n', r(9));
    fprintf('    Yield SF axial     = %.1f\n', r(11));

    % --- PLOTS ---

    % Plot 1: Feasibility map — d_axial vs L_axial (same d_rad, L_rad)
    % Show which axial combinations pass, coloured by fn_axial
    figure('Name','Optimisation — Axial Stinger Feasibility Map', ...
           'Position',[50 50 700 500]);

    % Filter results where d_rad == d_ax and L_rad == L_ax (same geometry)
    same_geom = results(results(:,1)==results(:,2) & results(:,3)==results(:,4), :);

    if ~isempty(same_geom)
        scatter(same_geom(:,1), same_geom(:,3), 60, same_geom(:,5), 'filled');
        colorbar; colormap(jet);
        xlabel('Stinger Diameter  d  [mm]', 'FontSize', 12);
        ylabel('Stinger Length  L  [mm]', 'FontSize', 12);
        title('Feasible Combinations — Same Axial and Radial Geometry', ...
              'FontSize', 12, 'FontWeight', 'bold');
        subtitle('Colour = Mode 1 axial natural frequency [Hz]', 'FontSize', 10);
        grid on; box on;
    else
        text(0.5,0.5,'No same-geometry feasible combinations found', ...
            'HorizontalAlignment','center', 'Units','normalized');
    end

    % Plot 2: fn_axial vs fn_radial for all feasible combinations
    figure('Name','Optimisation — fn Axial vs Radial', ...
           'Position',[50 50 600 500]);
    scatter(results(:,5), results(:,6), 30, results(:,1), 'filled');
    colorbar; colormap(parula);
    xlabel('Axial f_n  [Hz]', 'FontSize', 12);
    ylabel('Radial f_n  [Hz]', 'FontSize', 12);
    title('Feasible Combinations — Axial vs Radial Natural Frequency', ...
          'FontSize', 12, 'FontWeight', 'bold');
    subtitle('Colour = axial stinger diameter [mm]', 'FontSize', 10);
    grid on; box on;

    % Plot 3: Stiffness ratio vs fn for axial stingers
    figure('Name','Optimisation — Ratio vs fn', ...
           'Position',[50 50 600 500]);
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
