%% ===================== RWA TEST ANALYSIS: WRENCH, CAMPBELL, IMBALANCE =====================
% Built on analyze_rwa_test.m. For every run found in the data folder
% (RPM<speed>_<condition>_T<test>.csv step tests, and optional slow sweeps
% SWEEP<speed>_<condition>_T<test>.csv) this script:
%   1) finds when the motor switches on / off: a coarse start from the vibration
%      level, then refined by fitting the 1x ridge (the quiet period before the
%      start is the noise floor)
%   2) builds the speed axis from the constant acceleration: rpm = accel*(t - tStart)
%   3) converts the 6 sensor readings into the 6-component wrench
%      Fx Fy Fz [N] and Mx My Mz [N m] using the stinger geometry
%   4) plots raw sensors, wrench time histories and hold-speed PSDs vs noise floor
%   5) computes the 1x (spin-frequency) amplitudes and the static imbalance U
%   6) builds Smet-style Campbell plots (PSD vs speed vs frequency) from the
%      acceleration ramps, averaged over tests, one figure per condition and run
%      type (step / sweep), plus a 0-cfg.fMaxLow Hz zoom with a longer window
%   7) tracks the 1x force through each ramp and plots U vs speed continuously,
%      with a single-resonance fit U = U0/(1-(f/fn)^2) per condition
%   8) finds the imbalance ANGLE at the motor start without a tach (needs every run to start
%      from the same wheel position) and subtracts the wheel's own residual imbalance as a
%      vector from each added-mass condition
%
% Requires: Signal Processing Toolbox (pwelch, spectrogram, hann), R2019b+
% (tiledlayout, exportgraphics, xline).

clear; clc; close all;

%% ===================== USER SETTINGS =====================

% --- Files ---
% Data folder is found relative to this script, so it works on any machine that
% syncs the P4P Shared folder. Falls back to the current folder if the script is
% run in a way that hides its own path (e.g. code pasted into the command window).
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
cfg.testFolder   = '15_10_26_tests';           % <<< change this for each test session
cfg.dataFolder   = fullfile(scriptDir, cfg.testFolder);
cfg.outputFolder = fullfile(cfg.dataFolder, 'analysis_output');
cfg.Fs           = 10000;                    % [Hz] FlexLogger sample rate

cfg.speedsRPM  = [300 450 600 750 1000 1500 1800];% commanded hold speeds (missing files are skipped)
% Conditions (any that have no files are skipped):
%   balanced / baseline : the wheel as built (16-bolt ring), no added mass. 'balanced' is the
%                         11-13 Oct name, 'baseline' the 15 Oct one
%   imbalanced_1A       : one M8 cap screw (9.56 g) added from the top at r = 65 mm (11 Oct)
%   imbalanced_1W       : one M8 washer (1.48 g) under a top bolt head at r = 65 mm, every run
%                         started with the washer at 6 o'clock (-Y)
%   imbalanced_1W_90deg : the same washer, started at 3 o'clock (+X) - checks the angle result
%   baseline_end        : washer removed again at the end of the session (drift check)
%   imbalanced_2W       : two washers stacked (2 x 1.48 g) at 6 o'clock - linearity check (15 Oct)
cfg.conditions = {'balanced', 'baseline', 'imbalanced_1A', 'imbalanced_1W', 'imbalanced_1W_90deg', 'baseline_end', 'imbalanced_2W'};
cfg.tests      = 1:3;                        % T1..T3
cfg.fileFmt    = 'RPM%d_%s_T%d.csv';         % rpm, condition, test number
cfg.accelRPMperS = 37.5;                     % constant spin-up acceleration [rpm/s]
                                             % Tic accel for 37.5 rpm/s: 100000 at 1/8 step, 25000 at 1/2 step

% --- Slow sweeps for Campbell plots (optional; skipped if no files) ---
cfg.sweepSpeedsRPM    = [750 1000 1500 1600 1800];% top speed of each sweep (15 Oct: 1600 = sweeps that cut out ~1600)
cfg.sweepTests        = 1:3;
cfg.sweepFileFmt      = 'SWEEP%d_%s_T%d.csv';% rpm, condition, test number
cfg.sweepAccelRPMperS = 15;                  % sweep acceleration [rpm/s] (Tic accel 10000 at 1/2 step)

% Optional per-run overrides, keyed by run id (RPM<rpm>_<condition>_T<n>):
%   tStart : time the motor switches on [s]
%   window : [t0 t1] of the steady-speed part to analyse [s]
%   accel  : ramp acceleration of that run [rpm/s], if it differs from the default
% Example:
%   cfg.override.RPM300_balanced_T1 = struct('tStart', 5.2, 'window', [14 40]);
cfg.override = struct();
% 13 Oct: the 2000 rpm run was at full step with Tic accel 25000 = 75 rpm/s, and the
% motor was cut before 2000 rpm was reached. Analyse it on its own (cfg.speedsRPM = 2000).
cfg.override.RPM_2000_imbalanced_1W_T1 = struct('accel', 75);

% --- Sensors (order matters: this is the column order of the sensor matrix) ---
cfg.sensorNames = {'Rx1', 'Rx2', 'Ry1', 'Az1', 'Az2', 'Az3'};
cfg.sensorCols  = {'cDAQ1Mod1/ai0', 'cDAQ1Mod1/ai1', 'cDAQ1Mod1/ai2', ...
                   'cDAQ1Mod2/ai0', 'cDAQ1Mod2/ai1', 'cDAQ1Mod2/ai2'};
% Sign convention. The axial strain gauges (TAS510) read > 0 in TENSION. The radial PCB
% piezos read > 0 in COMPRESSION (PCB convention, seen in FlexLogger 14 Oct). Leave all +1:
% the NET signs of this mapping (sensor sign x stinger direction x force-on-platform
% convention) were validated on 11-14 Oct by two independent checks:
%  (1) the moment/force heights Mx/Fy, My/Fx = 0.22-0.25 m match the added mass at the wheel
%      top face (~0.23 m); a radial-vs-axial sign flip gives ~0.04 m, which is impossible
%  (2) the imbalance angle at start = -80 deg for a mass placed at -90 deg; an overall
%      radial sign flip would give ~+90 deg
% Only change these if the stingers or sensors are re-mounted, and then repeat both checks.
cfg.sensorSign  = [ 1  1  1    1  1  1];
% Calibration corrections (F_true = F_exported * S_used / S_true).
% Rx1/Rx2 (208C01) were calibrated by a technician and are taken as the reference.
% Ry1 (208C02) uses a non-professional sensitivity (0.011241 V/N) and reads ~11% low:
% for a rotating imbalance Fx = Fy at low speed, and the resonance-corrected Fx/Fy
% ratio is 1.11 in both the 11 Oct (PLA brackets, bolt) and 13 Oct (steel, 1.48 g)
% runs at 300-600 rpm, so it is the sensor, not the structure (spec tolerance +/-15%).
cfg.sensorScale = [ 1  1  1.11    1  1  1];

% --- Geometry [m]. Origin = centre of the axial sensor circle, X right, Y up,
%     Z toward the viewer along the spin axis (top view), axial sensors in the Z=0 plane. ---
geo.R   = 0.050;          % axial sensor circle radius (100 mm diameter)
geo.axialAngleDeg = [240 0 120];   % Az1 bottom-left, Az2 right (+X), Az3 top-left
geo.s   = 0.105;          % Rx1-Rx2 spacing (confirmed 105 mm)
geo.yRx = [-geo.s/2, +geo.s/2];    % y of Rx1, Rx2 (Rx2 is higher in Y); confirmed centred, 52.5 mm either side
geo.zr  = 0.140;          % height of the radial stinger lines of action above the base plate [m] (measured on rig)
geo.xRy = 0;              % x position of the Ry1 line of action [m] (centre of the mounting plate)
% Any NaN above is set to 0 for the calculation and listed in a warning.
cfg.geo = geo;

% --- Motor start/stop detection ---
cfg.blockSec       = 0.1;   % [s] block length for RMS
cfg.baselineSkipSec= 0.3;   % [s] ignore this much at the start (IEPE settling)
cfg.baselineProbeSec = 1.0; % [s] quiet reference period right after the skip
cfg.startThresh    = 3;     % motor 'on' when median RMS ratio vs quiet reference exceeds this
cfg.startBlocks    = 3;     % ...for this many consecutive blocks
cfg.tareOnBaseline = true;  % subtract the pre-start mean from every channel
cfg.refineStart    = true;  % refine tStart by fitting the 1x ridge (recommended)
cfg.startFitMinRPM = 150;   % use the ridge only above this speed [rpm]
cfg.startFitBandHz = 1.5;   % search +/- this around the predicted 1x line [Hz]

% --- Steady-speed window ---
cfg.settleSec    = 2;       % [s] wait after the ramp ends before analysing
cfg.endMarginSec = 1;       % [s] stop analysing this long before the motor stops
cfg.refineFrac   = 0.05;    % search +/-5% around the commanded speed for the true 1x peak

% --- Spectra ---
cfg.fMax          = 1000;   % [Hz] upper frequency of PSD / Campbell plots
cfg.psdWinSec     = 2;      % [s] Welch window for the hold-speed PSD
cfg.campWinSec    = 0.5;    % [s] spectrogram window (shorter = less speed smear, coarser frequency)
cfg.campOverlap   = 0.75;
cfg.orders        = [1 2 3];% spin orders drawn as dashed lines on the Campbell plots
cfg.rpmBinWidth   = 10;     % [rpm] speed grid for combining ramps
cfg.campbellDecades = 8;    % colour range = this many decades below the maximum
cfg.campbellClim  = [];     % or [log10(low) log10(high)] to force the same scale
cfg.fMaxLow       = 100;    % [Hz] upper frequency of the low-frequency Campbell zoom
cfg.trackWinSec   = 2;      % [s] window for the zoom and for 1x tracking through the ramp
cfg.trackMinRPM   = 150;    % [rpm] track the 1x force only above this speed
cfg.trackBandHz   = 1.5;    % [Hz] the 1x power is summed over +/- this around the 1x line
cfg.fitMinRPM     = 200;    % [rpm] lower speed limit for the resonance fit of U vs speed

% --- Optional: expected imbalance of the added bolt(s) ---
% For each entry of cfg.conditions: added mass [g] (NaN = none), its angle at the start of
% every run [deg, top view, 0 = 3 o'clock (+X), -90 = 6 o'clock (-Y); NaN = not controlled],
% and the condition(s) holding the wheel's own residual imbalance, which is subtracted as a
% vector (first one with data is used).
cfg.addedMass_g    = [NaN, NaN, 9.56, 1.48, 1.48, NaN, 2.96];
cfg.addedAngleDeg  = [NaN, NaN, NaN, -90, 0, NaN, -90];
cfg.refCondition   = {'', '', 'balanced', 'baseline|balanced', 'baseline|balanced', '', 'baseline|balanced'};
cfg.addedRadius_mm = 65;    % radius of the bolt holes from the spin axis [mm] (flywheel_test.pdf)

% --- Imbalance angle without a tach (from the start of every ramp) ---
cfg.phaseRPM    = 200:50:450;  % [rpm] window centres in the ramp (low speed = little amplification)
cfg.phaseWinSec = 1;           % [s] window length
cfg.phaseFnHz   = 44;          % 15 Oct taps (Al plate): x 39.8 Hz, y 48.6 Hz -> 44 Hz effective for |Fx+iFy|
                               % [Hz] lateral mode from the tap test: if set, each window is corrected
                               % for resonance amplification (x(1-(f/fn)^2)); NaN = no correction

% --- Output ---
cfg.plotDecim        = 50;    % plot every Nth sample in time-domain figures
cfg.savePlots        = true;  % PNGs into cfg.outputFolder
cfg.closeRunFigures  = true;  % close per-run figures after saving
cfg.perRunCampbell   = false; % also draw a Campbell plot for every single run
% Combined Campbell plots: only these conditions and run types are drawn (0-fMax and 0-fMaxLow).
% The slow sweeps give the cleanest maps; the step ramps only repeat them at lower speed.
cfg.campbellConditions = {'baseline', 'balanced', 'imbalanced_1W'};   % {} = every condition
cfg.campbellKinds      = {'sweep'};                                    % 'step' and/or 'sweep'

%% ===================== BUILD RUN LIST =====================

if ~exist(cfg.outputFolder, 'dir'), mkdir(cfg.outputFolder); end
cfg.rpmGrid = 0:cfg.rpmBinWidth:max([cfg.speedsRPM cfg.sweepSpeedsRPM]);

[W, unsetGeo] = buildWrenchMatrix(cfg.geo);
if ~isempty(unsetGeo)
    warning(['Geometry value(s) not set: %s. They were set to 0, so the moment terms that ' ...
             'depend on them (Mx, My from radial forces via zr; Mz from Fy via xRy) are NOT correct yet.'], ...
             strjoin(unsetGeo, ', '));
end

runs = {};
nMissing = 0;
for c = 1:numel(cfg.conditions)
    for k = 1:numel(cfg.speedsRPM)
        for q = cfg.tests
            fn = sprintf(cfg.fileFmt, cfg.speedsRPM(k), cfg.conditions{c}, q);
            fn = findRunFile(cfg.dataFolder, fn, 'RPM');  % accepts the lab naming variants
            fp = fullfile(cfg.dataFolder, fn);
            if ~isempty(fn)
                runs{end+1} = struct('id', erase(erase(fn, '.csv'), '.mat'), 'file', fp, 'cond', cfg.conditions{c}, ...
                                     'rpm', cfg.speedsRPM(k), 'test', q, ...
                                     'kind', 'step', 'accel', cfg.accelRPMperS); %#ok<SAGROW>
            else
                nMissing = nMissing + 1;                  % not every speed/condition is run
            end
        end
    end
    for k = 1:numel(cfg.sweepSpeedsRPM)
        for q = cfg.sweepTests
            fn = sprintf(cfg.sweepFileFmt, cfg.sweepSpeedsRPM(k), cfg.conditions{c}, q);
            fn = findRunFile(cfg.dataFolder, fn, 'SWEEP');
            fp = fullfile(cfg.dataFolder, fn);
            if ~isempty(fn)                       % sweeps are optional: no message if missing
                runs{end+1} = struct('id', erase(erase(fn, '.csv'), '.mat'), 'file', fp, 'cond', cfg.conditions{c}, ...
                                     'rpm', cfg.sweepSpeedsRPM(k), 'test', q, ...
                                     'kind', 'sweep', 'accel', cfg.sweepAccelRPMperS); %#ok<SAGROW>
            end
        end
    end
end
if isempty(runs), error('No run files found in %s', cfg.dataFolder); end
nSw = sum(cellfun(@(r) strcmp(r.kind, 'sweep'), runs));
fprintf('%d run file(s) found (%d step, %d sweep); %d other speed/condition/trial combinations have no file.\n', ...
    numel(runs), numel(runs) - nSw, nSw, nMissing);

%% ===================== ANALYSE EVERY RUN =====================

results = cell(1, numel(runs));
for r = 1:numel(runs)
    results{r} = analyseRun(runs{r}, cfg, W);
end

%% ===================== SUMMARY TABLE =====================

nR = numel(results);
T = table('Size', [nR 21], ...
    'VariableTypes', [{'string','string','string'}, repmat({'double'}, 1, 14), {'string'}, repmat({'double'}, 1, 3)], ...
    'VariableNames', {'Run','Condition','Kind','RPM','Test','tStart_s','fSpin_Hz', ...
                      'Fx_N','Fy_N','Fz_N','Mx_Nm','My_Nm','Mz_Nm','Fe_N','U_gmm','MzRampMean_Nm','tStop_s', ...
                      'SpinDir','Angle0_deg','ULow_gmm','tStartErr_s'});
for r = 1:nR
    s = results{r};
    T(r, :) = {string(s.id), string(s.cond), string(s.kind), s.rpm, s.test, s.tStart, s.fSpin, ...
               s.A6(1), s.A6(2), s.A6(3), s.A6(4), s.A6(5), s.A6(6), s.Fe, s.Uc_gmm, s.MzRampMean, s.tStop, ...
               string(s.dir), s.angle0, s.uLow, s.tErr};
end
fprintf('\n================ SUMMARY (1x amplitudes at the spin frequency) ================\n');
disp(T);
writetable(T, fullfile(cfg.outputFolder, 'summary.csv'));
fprintf('Summary saved to %s\n', fullfile(cfg.outputFolder, 'summary.csv'));
for c = find(~isnan(cfg.addedMass_g))
    fprintf('Expected added imbalance, %s: %.2f g.mm\n', cfg.conditions{c}, cfg.addedMass_g(c) * cfg.addedRadius_mm);
end

%% ===================== ADDED IMBALANCE AS A VECTOR (residual subtracted) =====================
% Each run gives a low-speed imbalance vector U*exp(i*angle) from its ramp (200-450 rpm, where
% the resonance amplification is only a few %). Subtracting the mean vector of the reference
% condition removes the wheel's own residual imbalance. Only meaningful if every run started
% from the same wheel position.

fprintf('\n================ ADDED IMBALANCE: VECTOR MINUS THE WHEEL''S OWN RESIDUAL ================\n');
uvec = @(s) s.uLow * exp(1i * deg2rad(s.angle0));
for c = find(~isnan(cfg.addedMass_g))
    sel = find(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && isfinite(s.angle0), results));
    if isempty(sel), continue; end
    Vc = mean(cellfun(uvec, results(sel)));
    Vr = NaN; refName = '';
    for ref = strsplit(cfg.refCondition{c}, '|')
        if isempty(ref{1}), continue; end
        sr = find(cellfun(@(s) strcmp(s.cond, ref{1}) && isfinite(s.angle0), results));
        if ~isempty(sr), Vr = mean(cellfun(uvec, results(sr))); refName = sprintf('%s (n = %d)', ref{1}, numel(sr)); break; end
    end
    fprintf('%-20s measured %6.1f g.mm at %6.1f deg (n = %d)', cfg.conditions{c}, abs(Vc), rad2deg(angle(Vc)), numel(sel));
    if isfinite(Vr)
        Va = Vc - Vr;
        fprintf('\n%-20s minus %s: %.1f g.mm at %.1f deg\n%-20s = ADDED %.1f g.mm at %.1f deg', '', refName, ...
                abs(Vr), rad2deg(angle(Vr)), '', abs(Va), rad2deg(angle(Va)));
    end
    fprintf('   | expected %.1f g.mm', cfg.addedMass_g(c) * cfg.addedRadius_mm);
    if ~isnan(cfg.addedAngleDeg(c)), fprintf(' at %.0f deg', cfg.addedAngleDeg(c)); end
    fprintf('\n');
end

%% ===================== COMBINED CAMPBELL PLOTS (one per condition) =====================

kinds = {'step', 'sweep'};
for c = 1:numel(cfg.conditions)
    if ~isempty(cfg.campbellConditions) && ~any(strcmp(cfg.conditions{c}, cfg.campbellConditions)), continue; end
    for kd = 1:2
        if ~any(strcmp(kinds{kd}, cfg.campbellKinds)), continue; end
        sel = find(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && strcmp(s.kind, kinds{kd}), results));
        if isempty(sel), continue; end
        sfx = cfg.conditions{c};
        if kd == 2, sfx = [sfx '_sweep']; end
        lbl = sprintf('%s, %s (mean of %d ramp(s))', cfg.conditions{c}, kinds{kd}, numel(sel));
        tmp = cellfun(@(s) s.Pcamp, results(sel), 'UniformOutput', false);
        Pm  = mean(cat(4, tmp{:}), 4, 'omitnan');          % nf x nrpm x 6
        fig = plotCampbell(results{sel(1)}.fCamp, cfg.rpmGrid, Pm, ['Campbell - ' lbl], cfg, cfg.fMax);
        saveFig(fig, cfg, ['campbell_' sfx], false);
        tmp = cellfun(@(s) s.PcampLow, results(sel), 'UniformOutput', false);
        Pm  = mean(cat(4, tmp{:}), 4, 'omitnan');
        fig = plotCampbell(results{sel(1)}.fCampLow, cfg.rpmGrid, Pm, ['Campbell 0-' num2str(cfg.fMaxLow) ' Hz - ' lbl], cfg, cfg.fMaxLow);
        saveFig(fig, cfg, ['campbell_low_' sfx], false);
    end
end

%% ===================== 1x FORCE AND IMBALANCE vs SPEED =====================

figure('Name', 'Imbalance vs speed');
cols = lines(numel(cfg.conditions));
for c = 1:numel(cfg.conditions)
    sel = find(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && strcmp(s.kind, 'step'), results));
    if isempty(sel), continue; end
    rp = cellfun(@(s) s.rpm, results(sel));
    Fe = cellfun(@(s) s.Fe, results(sel));
    Uc = cellfun(@(s) s.Uc_gmm, results(sel));
    subplot(2, 1, 1); hold on;
    plot(rp, Fe, 'o', 'Color', cols(c, :), 'HandleVisibility', 'off');
    [ur, ~, g] = unique(rp);
    plot(ur, accumarray(g(:), Fe(:), [], @mean), '-', 'Color', cols(c, :), 'DisplayName', cfg.conditions{c});
    subplot(2, 1, 2); hold on;
    plot(rp, Uc, 'o', 'Color', cols(c, :), 'HandleVisibility', 'off');
    plot(ur, accumarray(g(:), Uc(:), [], @mean), '-', 'Color', cols(c, :), 'DisplayName', cfg.conditions{c});
end
subplot(2, 1, 1); grid on; ylabel('Radial force at 1x (N)'); legend('Location', 'northwest');
title('Radial force at spin frequency (should grow with speed^2)');
subplot(2, 1, 2); grid on; xlabel('Speed (RPM)'); ylabel('U = F/\omega^2 (g mm)');
title('Static imbalance (should be flat if the imbalance is static)');
saveFig(gcf, cfg, 'imbalance_vs_speed', false);

%% ===================== 1x TRACKED THROUGH THE RAMPS: U vs SPEED + RESONANCE FIT =====================
% Continuous version of the plot above, from the 1x force during every ramp. Sweeps
% are used for the fit when there are any (slower ramp = cleaner), otherwise steps.

figure('Name', 'Imbalance vs speed (tracked)', 'Position', [80 80 1100 650]); hold on;
fprintf('\n================ RESONANCE FIT  U = U0 / (1 - (f/fn)^2)  (%d rpm and up) ================\n', cfg.fitMinRPM);
for c = 1:numel(cfg.conditions)
    for kd = 1:2
        sel = find(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && strcmp(s.kind, kinds{kd}), results));
        if isempty(sel), continue; end
        Um = mean(cell2mat(cellfun(@(s) s.trackU(:)', results(sel), 'UniformOutput', false)'), 1, 'omitnan');
        if kd == 1
            % step ramps differ in top speed (and may come from different sessions), so a
            % mean would jump wherever a run ends: draw every ramp on its own instead
            for q = 1:numel(sel)
                hv = 'off'; if q == 1, hv = 'on'; end
                plot(cfg.rpmGrid, results{sel(q)}.trackU, ':', 'Color', cols(c, :), 'LineWidth', 0.8, ...
                     'HandleVisibility', hv, 'DisplayName', sprintf('%s, step ramps (%d, each run)', cfg.conditions{c}, numel(sel)));
            end
        else
            plot(cfg.rpmGrid, Um, '-', 'Color', cols(c, :), 'LineWidth', 1.6, ...
                 'DisplayName', sprintf('%s, sweep ramps (mean of %d)', cfg.conditions{c}, numel(sel)));
        end
        hasSweep = any(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && strcmp(s.kind, 'sweep'), results));
        if (kd == 2) || ~hasSweep
            [U0, fn, ok] = fitResonance(cfg.rpmGrid / 60, Um, cfg.fitMinRPM / 60);
            if ok
                fprintf('%-16s (%s ramps): U0 = %.1f g.mm, fn = %.1f Hz (%.0f rpm)\n', cfg.conditions{c}, kinds{kd}, U0, fn, fn * 60);
                rg = cfg.rpmGrid(cfg.rpmGrid >= cfg.fitMinRPM & isfinite(Um));
                plot(rg, U0 ./ (1 - (rg / 60 / fn).^2), '--', 'Color', cols(c, :), 'HandleVisibility', 'off');
            else
                fprintf('%-16s (%s ramps): fit not possible (U does not rise with speed or too few points)\n', cfg.conditions{c}, kinds{kd});
            end
        end
    end
    sel = find(cellfun(@(s) strcmp(s.cond, cfg.conditions{c}) && strcmp(s.kind, 'step'), results));
    if ~isempty(sel)
        plot(cellfun(@(s) s.rpm, results(sel)), cellfun(@(s) s.Uc_gmm, results(sel)), 'o', ...
             'Color', cols(c, :), 'DisplayName', [cfg.conditions{c} ', hold-speed results']);
    end
end
for c = find(~isnan(cfg.addedMass_g))
    yline(cfg.addedMass_g(c) * cfg.addedRadius_mm, '--', ['expected ' cfg.conditions{c}], ...
          'Color', cols(c, :), 'Interpreter', 'none', 'HandleVisibility', 'off');
end
grid on; set(gca, 'YScale', 'log'); xlim([0 max(cfg.rpmGrid)]);
xlabel('Speed (rpm)'); ylabel('U = F_{1x}/\omega^2 (g mm)'); legend('Location', 'northwest', 'Interpreter', 'none');
title('Imbalance tracked through the ramps (dashed: resonance fit; flat = no amplification)');
saveFig(gcf, cfg, 'imbalance_vs_speed_tracked', false);

fprintf('\nDone. Figures and summary.csv are in %s\n', cfg.outputFolder);

%% ===================== LOCAL FUNCTIONS =====================

function res = analyseRun(run, cfg, W)
    Fs = cfg.Fs; dec = cfg.plotDecim;
    fprintf('\n=== %s ===\n', run.id);

    % ---- load only the six sensor columns (.mat from convert_csv_to_mat, or the CSV) ----
    S = readRunFile(run.file, cfg.sensorCols, run.id);
    last = find(all(isfinite(S), 2), 1, 'last');      % modules can end a few samples apart
    S = S(1:last, :);
    N = last;
    t = (0:N-1)' / Fs;
    S = S .* (cfg.sensorSign .* cfg.sensorScale);
    fprintf('Loaded %d samples (%.1f s)\n', N, N / Fs);

    % ---- overrides ----
    ov = struct();
    if isfield(cfg.override, run.id), ov = cfg.override.(run.id); end
    if isfield(ov, 'accel')
        run.accel = ov.accel;
        fprintf('Ramp acceleration taken from override: %g rpm/s\n', run.accel);
    end

    % ---- motor start / stop ----
    % Coarse: vibration level vs the quiet period. Because the imbalance force grows
    % with speed^2, this can trigger several seconds AFTER the motor really starts,
    % so the start time is then refined by fitting the 1x ridge (f = accel/60*(t - tStart)).
    [tCoarse, tStop, score, tb] = detectMotorWindow(S, Fs, cfg);
    if isnan(tStop), tStop = N / Fs; end
    F6 = S * W.';                        % untared wrench, used only for the ridge fit
    dg = [];
    if isfield(ov, 'tStart')
        tStart = ov.tStart;
        fprintf('Motor start taken from override: %.2f s\n', tStart);
    else
        if isnan(tCoarse)
            error(['%s: no motor activity detected (RMS never exceeded %.1fx the quiet level). ' ...
                   'Set cfg.override.%s = struct(''tStart'', ..., ''window'', [..]).'], run.id, cfg.startThresh, run.id);
        end
        tStart = tCoarse;
        if cfg.refineStart
            [tFit, sdFit, dg] = refineTStart(F6, Fs, tCoarse, run.rpm, run.accel, cfg);
            if isfinite(tFit) && sdFit > 1 && abs(tFit - tCoarse) > 0.5
                % weak 1x (no added mass, low speed): the ridge fit wanders - the coarse start
                % (motor switch-on kick) is more reliable then
                warning(['%s: 1x ridge fit unreliable (scatter %.2f s, %.2f s from the coarse start) - ' ...
                         'using the coarse start %.2f s.'], run.id, sdFit, tFit - tCoarse, tCoarse);
            elseif isfinite(tFit)
                tStart = tFit;
                fprintf('Motor start: coarse %.2f s -> refined from 1x ridge %.2f s (scatter %.2f s)\n', tCoarse, tFit, sdFit);
                if sdFit > 0.3
                    warning('%s: 1x ridge fit is noisy (scatter %.2f s). Check the start-fit figure; override tStart if needed.', run.id, sdFit);
                end
            else
                warning('%s: 1x ridge fit failed, using the coarse start %.2f s.', run.id, tCoarse);
            end
        end
    end
    if isnan(tCoarse), tCoarse = tStart; end
    tRampEnd = tStart + run.rpm / run.accel;
    % the motor driver can cut out during the ramp (Tic T500 'motor driver error' near 1600 rpm):
    % then the wheel coasts and there is no hold. Detect it and end the ramp at the cut.
    tCut = findRampCut(F6, Fs, tStart, tRampEnd, run.accel);
    cutOut = tCut < tRampEnd - 1;
    rpmHold = run.rpm;
    if cutOut
        warning(['%s: motor cut out during the ramp at ~%.0f rpm (%.1f s). Ramp data used up to the cut; ' ...
                 'there is no hold, so the "hold" results come from the last 2 s of the ramp.'], ...
                 run.id, run.accel * (tCut - tStart), tCut);
        tCut = tCut - 1;                               % detection lags ~1 s: keep coast-down data out
        tRampEnd = tCut;
    elseif tRampEnd > tStop - 0.5
        % the motor stopped (or the record ended) before the commanded speed was reached
        cutOut = true;
        tCut = tStop - 1.5;
        warning(['%s: motor stopped at ~%.0f rpm (%.1f s), before the commanded %d rpm. Ramp data used up ' ...
                 'to there; no hold, so the "hold" results come from the last 2 s of the ramp.'], ...
                 run.id, run.accel * (tStop - tStart), tStop, run.rpm);
        tRampEnd = tCut;
    end
    fprintf('Motor on at %.2f s, ramp to %d rpm ends at %.2f s, motor off at ~%.2f s\n', ...
        tStart, run.rpm, tRampEnd, tStop);
    if tStart < cfg.baselineSkipSec + cfg.baselineProbeSec + 0.3
        warning('%s: motor start is very early in the record - baseline is short. Check the detection figure.', run.id);
    end
    if tRampEnd > tStop
        warning('%s: expected ramp end is after the detected motor stop - check tStart / commanded speed.', run.id);
    end
    % the motor may be decelerated before it stops: end the window where the 1x
    % line leaves the hold speed, not where the vibration stops
    if cutOut
        win = [tCut - 2.5, tCut - 0.5];               % end of the ramp, speed still rising slowly
        rpmHold = run.accel * (mean(win) - tStart);
    else
        tHoldEnd = findHoldEnd(F6, Fs, tRampEnd, tStop, run.rpm / 60);
        if tHoldEnd < tStop - 0.5
            fprintf('Speed starts to drop at ~%.2f s (deceleration; vibration stops at %.2f s)\n', tHoldEnd, tStop);
        end
        win = [tRampEnd + cfg.settleSec, tHoldEnd - cfg.endMarginSec];
    end
    if isfield(ov, 'window'), win = ov.window; end
    if win(2) - win(1) < 1                            % no usable hold (e.g. undetected cut-out)
        warning('%s: no usable steady-speed hold - using the last 2 s of the ramp instead.', run.id);
        win = [tRampEnd - 2.5, tRampEnd - 0.5];
        rpmHold = run.accel * (mean(win) - tStart);
        cutOut = true;
    end
    if win(2) - win(1) < 3 && ~cutOut
        warning('%s: steady-speed window is only %.1f s - use cfg.override to set it.', run.id, win(2) - win(1));
    end
    fprintf('Steady-speed window: %.1f - %.1f s\n', win(1), win(2));

    % ---- tare on the pre-start noise floor ----
    iBase = t >= cfg.baselineSkipSec & t < (tStart - 0.2);
    if cfg.tareOnBaseline && nnz(iBase) > 0
        S = S - mean(S(iBase, :), 1);
    end

    % ---- wrench: [Fx Fy Fz Mx My Mz] (force the wheel applies to the platform) ----
    F6 = S * W.';

    % ---- 1x amplitudes and static imbalance in the steady-speed window ----
    idx = t >= win(1) & t <= win(2);
    tw = t(idx); n = numel(tw);
    f0 = rpmHold / 60;
    xs = F6(idx, 1) - mean(F6(idx, 1));
    ys = F6(idx, 2) - mean(F6(idx, 2));
    wn = 0.5 - 0.5 * cos(2 * pi * (0:n-1)' / (n - 1));          % Hann window
    Nfft = 2^nextpow2(4 * n);
    X = fft(wn .* xs, Nfft); Y = fft(wn .* ys, Nfft);
    fv = (0:Nfft-1)' * Fs / Nfft;
    P = abs(X).^2 + abs(Y).^2;
    band = find(fv >= f0 * (1 - cfg.refineFrac) & fv <= f0 * (1 + cfg.refineFrac));
    [~, kk] = max(P(band));
    k = band(kk);
    if kk == 1 || kk == numel(band)
        warning('%s: 1x peak is at the edge of the search band - check commanded speed and window.', run.id);
        fSpin = fv(k);
    else
        a = log(P(k-1)); b = log(P(k)); c = log(P(k+1));
        delta = 0.5 * (a - c) / (a - 2*b + c);
        fSpin = (k - 1 + delta) * Fs / Nfft;
    end
    ph = @(sig) 2 / sum(wn) * sum(wn .* sig .* exp(-1j * 2 * pi * fSpin * tw));
    A6 = zeros(1, 6);
    for j = 1:6, A6(j) = abs(ph(F6(idx, j) - mean(F6(idx, j)))); end
    Ax = A6(1); Ay = A6(2);
    Fe = sqrt((Ax^2 + Ay^2) / 2);       % circular rotating force: Ax = Ay = U*omega^2
    om = 2 * pi * fSpin;
    res.id = run.id; res.cond = run.cond; res.rpm = run.rpm; res.test = run.test; res.kind = run.kind;
    res.tStart = tStart; res.tStop = tStop; res.fSpin = fSpin; res.A6 = A6; res.Fe = Fe;
    res.Ux_gmm = Ax / om^2 * 1e6; res.Uy_gmm = Ay / om^2 * 1e6; res.Uc_gmm = Fe / om^2 * 1e6;

    % ---- imbalance angle at the start (no tach: needs the same start position every run) ----
    [res.angle0, res.uLow, res.dir, res.tErr] = startAngle(F6(:, 1) + 1i * F6(:, 2), Fs, tStart, ...
        run.accel, cfg.phaseRPM(cfg.phaseRPM <= run.rpm - 50), cfg.phaseWinSec, cfg.phaseFnHz);
    fprintf('Imbalance at start: %.1f g.mm at %.1f deg (spin %s, start-time error %+.3f s)\n', ...
        res.uLow, res.angle0, res.dir, res.tErr);
    fprintf('Spin frequency: commanded %.3f Hz, measured %.3f Hz (%.1f rpm)\n', f0, fSpin, fSpin * 60);
    if abs(fSpin - f0) / f0 > 0.03
        warning('%s: measured spin frequency differs from commanded by more than 3%%.', run.id);
    end
    fprintf('1x amplitudes: Fx %.4f  Fy %.4f  Fz %.4f N | Mx %.5f  My %.5f  Mz %.5f N m\n', A6);
    fprintf('Static imbalance U: Fx %.2f, Fy %.2f, combined %.2f g.mm\n', res.Ux_gmm, res.Uy_gmm, res.Uc_gmm);

    % ---- torque during the acceleration ramp ----
    iRamp = t >= tStart & t <= tRampEnd;
    res.MzRampMean = mean(F6(iRamp, 6));
    fprintf(['Mean Mz during ramp: %.5f N m. NOTE: the radial piezo (IEPE) channels are AC-coupled, so a\n' ...
             '  steady torque is attenuated - treat Mz as the dynamic part only.\n'], res.MzRampMean);

    % ---- spectra: steady-speed PSD vs noise floor ----
    nWin = min(round(cfg.psdWinSec * Fs), floor(n / 2));
    nBase = nnz(iBase);
    nWb = min(nWin, floor(nBase / 2));
    Phold = cell(1, 6); fh = []; Pbase = cell(1, 6); fb = [];
    for j = 1:6
        [Phold{j}, fh] = pwelch(detrend(F6(idx, j)), nWin, round(nWin / 2), nWin, Fs);
        if nWb > 8
            [Pbase{j}, fb] = pwelch(detrend(F6(iBase, j)), nWb, round(nWb / 2), nWb, Fs);
        end
    end

    % ---- Campbell data from the acceleration ramp ----
    nw = round(cfg.campWinSec * Fs);
    no = round(cfg.campOverlap * nw);
    nfft = 2^nextpow2(nw) * 2;
    xr = F6(iRamp, :);
    res.fCamp = [];
    res.Pcamp = [];
    for j = 1:6
        [~, f, tt, Pst] = spectrogram(detrend(xr(:, j)), hann(nw), no, nfft, Fs);
        keep = f <= cfg.fMax;
        rpmT = run.accel * tt(:)';                              % tt measured from tStart
        Pg = interp1(rpmT, Pst(keep, :)', cfg.rpmGrid, 'linear', NaN)';   % nf x nrpm
        if j == 1
            res.fCamp = f(keep);
            res.Pcamp = nan(nnz(keep), numel(cfg.rpmGrid), 6);
        end
        res.Pcamp(:, :, j) = Pg;
    end

    % ---- low-frequency Campbell (longer window) + 1x tracked through the ramp ----
    % The 1x amplitude in each window comes from the PSD summed over +/- trackBandHz
    % around the 1x line: sum(P)*df = mean square = A^2/2  ->  A = sqrt(2*sum(P)*df).
    nwL = round(cfg.trackWinSec * Fs);
    nfftL = 2^nextpow2(nwL) * 2;
    res.trackU = nan(size(cfg.rpmGrid));
    if size(xr, 1) > 2 * nwL
        Axy = [];
        for j = 1:6
            [~, f, tt, Pst] = spectrogram(detrend(xr(:, j)), hann(nwL), round(0.75 * nwL), nfftL, Fs);
            keep = f <= cfg.fMaxLow;
            fk = f(keep); Pk = Pst(keep, :);
            rpmT = run.accel * tt(:)';
            if j == 1
                res.fCampLow = fk;
                res.PcampLow = nan(nnz(keep), numel(cfg.rpmGrid), 6);
                Axy = nan(2, numel(tt));
            end
            res.PcampLow(:, :, j) = interp1(rpmT, Pk', cfg.rpmGrid, 'linear', NaN)';
            if j <= 2
                df = fk(2) - fk(1);
                for q = 1:numel(tt)
                    if rpmT(q) < cfg.trackMinRPM, continue; end
                    b = abs(fk - rpmT(q) / 60) <= cfg.trackBandHz;
                    Axy(j, q) = sqrt(2 * sum(Pk(b, q)) * df);
                end
            end
        end
        FeT = sqrt((Axy(1, :).^2 + Axy(2, :).^2) / 2);
        UT  = FeT ./ (2 * pi * rpmT / 60).^2 * 1e6;           % [g mm]
        res.trackU = interp1(rpmT, UT, cfg.rpmGrid, 'linear', NaN);
    else
        warning('%s: ramp shorter than 2 x trackWinSec - no tracked 1x / low-frequency Campbell.', run.id);
        fL = (0:nfftL/2)' * Fs / nfftL;
        res.fCampLow = fL(fL <= cfg.fMaxLow);
        res.PcampLow = nan(numel(res.fCampLow), numel(cfg.rpmGrid), 6);
    end

    % ---- figures ----
    tt = t(1:dec:end);
    wl = {'Fx (N)', 'Fy (N)', 'Fz (N)', 'Mx (N m)', 'My (N m)', 'Mz (N m)'};

    f1 = figure('Name', [run.id ' - raw sensors'], 'Position', [100 100 1100 650]);
    tiledlayout(2, 1, 'TileSpacing', 'compact');
    nexttile; plot(tt, S(1:dec:end, 1:3)); grid on; legend(cfg.sensorNames(1:3)); ylabel('Force (N)');
    title([run.id ' - radial sensors (piezo)'], 'Interpreter', 'none'); marks(tStart, tRampEnd, win);
    nexttile; plot(tt, S(1:dec:end, 4:6)); grid on; legend(cfg.sensorNames(4:6)); ylabel('Force (N)');
    xlabel('Time (s)'); title('axial sensors (strain gauge)'); marks(tStart, tRampEnd, win);
    saveFig(f1, cfg, [run.id '_raw'], true);

    f2 = figure('Name', [run.id ' - wrench'], 'Position', [100 100 1200 750]);
    tiledlayout(3, 2, 'TileSpacing', 'compact');
    for j = 1:6
        nexttile; plot(tt, F6(1:dec:end, j)); grid on; ylabel(wl{j});
        if j >= 5, xlabel('Time (s)'); end
        marks(tStart, tRampEnd, win);
    end
    sgtitle([run.id ' - wrench (dotted: motor on, ramp end; dashed: analysis window)'], 'Interpreter', 'none');
    saveFig(f2, cfg, [run.id '_wrench'], true);

    f3 = figure('Name', [run.id ' - PSD'], 'Position', [100 100 1200 750]);
    tiledlayout(3, 2, 'TileSpacing', 'compact');
    for j = 1:6
        nexttile; semilogy(fh, Phold{j}); hold on;
        if ~isempty(Pbase{j}), semilogy(fb, Pbase{j}); end
        xline(fSpin, ':k', 'HandleVisibility', 'off'); grid on;
        xlim([0 cfg.fMax]); title(wl{j}); xlabel('Frequency (Hz)');
        if j <= 3, ylabel('PSD (N^2/Hz)'); else, ylabel('PSD (N^2m^2/Hz)'); end
        if j == 1, legend('steady speed', 'noise floor (before start)'); end
    end
    sgtitle([run.id ' - PSD at ' num2str(run.rpm) ' rpm vs pre-start noise floor'], 'Interpreter', 'none');
    saveFig(f3, cfg, [run.id '_psd'], true);

    f4 = figure('Name', [run.id ' - motor start/stop'], 'Position', [100 100 1100 650]);
    tiledlayout(2, 1, 'TileSpacing', 'compact');
    nexttile; semilogy(tb, score); hold on; yline(cfg.startThresh, '--k'); grid on;
    xline(tCoarse, 'm'); xline(tStart, 'g'); xline(tStop, 'r');
    ylabel('median RMS ratio vs quiet'); xlabel('Time (s)');
    title([run.id ' - coarse start (magenta), final start (green), stop (red)'], 'Interpreter', 'none');
    nexttile;
    if ~isempty(dg)
        imagesc(dg.tabs, dg.f, dg.L); axis xy; colormap(gca, jet); hold on;
        tl = [tStart tRampEnd];
        plot(tl, dg.slope * (tl - tStart), 'w--', 'LineWidth', 1.2);
        ylim([0 run.rpm / 60 + 5]); xlim([max(0, tStart - 3) tRampEnd + 3]);
        title('Radial 1x ridge (Fx+Fy) with fitted speed line (white dashed)');
    else
        title('1x ridge fit not used (override or disabled)');
    end
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    saveFig(f4, cfg, [run.id '_start_fit'], true);

    if cfg.perRunCampbell
        f5 = plotCampbell(res.fCamp, cfg.rpmGrid, res.Pcamp, ['Campbell - ' run.id], cfg, cfg.fMax);
        saveFig(f5, cfg, [run.id '_campbell'], true);
    end
end

function [tStart, tStop, score, tb] = detectMotorWindow(S, Fs, cfg)
    % Block RMS of every channel relative to a quiet reference right after the
    % record starts; the motor is 'on' while the median ratio is above threshold.
    blk = round(cfg.blockSec * Fs);
    nb = floor(size(S, 1) / blk);
    X = reshape(S(1:nb*blk, :), blk, nb, 6);
    Xd = X - mean(X, 1);
    r = squeeze(sqrt(mean(Xd.^2, 1)));                 % nb x 6
    b0 = max(1, ceil(cfg.baselineSkipSec / cfg.blockSec));
    b1 = min(nb, b0 + round(cfg.baselineProbeSec / cfg.blockSec) - 1);
    base = median(r(b0:b1, :), 1);
    score = median(r ./ base, 2);                       % nb x 1
    tb = (0:nb-1)' * cfg.blockSec;
    above = score > cfg.startThresh;
    runOn = movsum(double(above), [0 cfg.startBlocks - 1]) >= cfg.startBlocks;
    kStart = find(runOn, 1, 'first');
    kStop = find(above, 1, 'last');
    if isempty(kStart) || isempty(kStop)
        tStart = NaN; tStop = NaN;      % caller decides (override or error)
        return;
    end
    tStart = tb(kStart);
    tStop = min(tb(kStop) + cfg.blockSec, size(S, 1) / Fs);
end

function [t0, sd, dg] = refineTStart(F6, Fs, tc, rpm, accel, cfg)
    % Fit the motor start time from the 1x ridge of the radial force (Fx, Fy).
    % The 1x frequency during the constant-acceleration ramp is f = accel/60*(t - t0).
    % Step 1: slide candidate t0 and keep the one whose line carries most power.
    % Step 2: track the actual spectral peak near that line (parabolic interpolation)
    %         and take the median of  t - f_peak/slope  as the start time.
    slope = accel / 60;                                   % [Hz/s]
    tRamp = rpm / accel;
    nw = round(1.0 * Fs); nfft = 2^15;
    i0 = max(1, round((tc - tRamp - 5) * Fs) + 1);
    i1 = min(size(F6, 1), round((tc + tRamp + 3) * Fs));
    S = 0;
    for j = 1:2
        [~, f, tt, Pst] = spectrogram(detrend(F6(i0:i1, j)), hann(nw), round(0.75 * nw), nfft, Fs);
        S = S + Pst;
    end
    tabs = (i0 - 1) / Fs + tt(:)';                        % 1 x nt
    keep = f <= rpm / 60 + 5;
    f = f(keep); S = S(keep, :);
    L = 10 * log10(S + realmin);
    df = f(2) - f(1);

    cands = max(0, tc - tRamp - 5):0.1:(tc + 1);
    sc = -Inf(size(cands));
    for q = 1:numel(cands)
        sc(q) = lineScore(L, tabs, df, slope, cands(q), rpm, accel, cfg.startFitMinRPM);
    end
    [~, qb] = max(sc);
    t0 = cands(qb);
    sd = NaN;
    est = [];
    for pass = 1:2
        m = find(tabs > t0 + cfg.startFitMinRPM / accel & tabs < t0 + (rpm - 60) / accel);
        est = nan(1, numel(m));
        for q = 1:numel(m)
            k = m(q);
            fl = slope * (tabs(k) - t0);
            band = find(f > fl - cfg.startFitBandHz & f < fl + cfg.startFitBandHz);
            if numel(band) < 3, continue; end
            [~, kk] = max(S(band, k));
            fi = band(kk);
            fpk = f(fi);
            if fi > 1 && fi < numel(f)
                a = log(S(fi-1, k)); b = log(S(fi, k)); c = log(S(fi+1, k));
                d = 0.5 * (a - c) / (a - 2*b + c);
                if isfinite(d), fpk = f(fi) + d * df; end
            end
            est(q) = tabs(k) - fpk / slope;
        end
        if all(isnan(est)), t0 = NaN; break; end
        t0 = median(est, 'omitnan');
    end
    if ~isnan(t0), sd = std(est, 'omitnan'); end
    dg.f = f; dg.tabs = tabs; dg.L = L; dg.slope = slope;
end

function sc = lineScore(L, tabs, df, slope, t0, rpm, accel, minRPM)
    m = find(tabs > t0 + minRPM / accel & tabs < t0 + (rpm - 60) / accel);
    if numel(m) < 3, sc = -Inf; return; end
    fl = slope * (tabs(m) - t0);
    ii = min(max(round(fl / df) + 1, 1), size(L, 1));
    sc = mean(L(sub2ind(size(L), ii, m)));
end

function [W, unset] = buildWrenchMatrix(geo)
    % Maps the six signed sensor readings (tension > 0), in the order
    % [Rx1 Rx2 Ry1 Az1 Az2 Az3], to the wrench [Fx Fy Fz Mx My Mz] that the wheel
    % applies to the platform. Each column is [d; p x d] for a stinger with line
    % of action direction d through point p.
    unset = {};
    zr = geo.zr;  if isnan(zr),  zr = 0;  unset{end+1} = 'zr';  end
    xRy = geo.xRy; if isnan(xRy), xRy = 0; unset{end+1} = 'xRy'; end
    ang = deg2rad(geo.axialAngleDeg);
    P = [ 0,        geo.yRx(1), zr;                     % Rx1
          0,        geo.yRx(2), zr;                     % Rx2
          xRy,      0,          zr;                     % Ry1
          geo.R*cos(ang(1)), geo.R*sin(ang(1)), 0;      % Az1
          geo.R*cos(ang(2)), geo.R*sin(ang(2)), 0;      % Az2
          geo.R*cos(ang(3)), geo.R*sin(ang(3)), 0 ];    % Az3
    D = [1 0 0; 1 0 0; 0 1 0; 0 0 1; 0 0 1; 0 0 1];
    W = zeros(6, 6);
    for i = 1:6
        W(1:3, i) = D(i, :)';
        W(4:6, i) = cross(P(i, :), D(i, :))';
    end
end

function fig = plotCampbell(f, rpmGrid, Pm, ttl, cfg, fMax)
    % Smet-style Campbell: PSD (log colour) vs speed (x) and frequency (y).
    fig = figure('Name', ttl, 'Position', [60 60 1400 800]);
    tiledlayout(2, 3, 'TileSpacing', 'compact');
    % Crop the speed axis to the bins that hold data (any component), so there is no blank
    % strip where the grid runs past the top speed of these ramps.
    has = find(any(any(isfinite(Pm), 1), 3));
    if ~isempty(has)
        cols = has(1):has(end);
        rpmGrid = rpmGrid(cols); Pm = Pm(:, cols, :);
    end
    dr = (rpmGrid(end) - rpmGrid(1)) / max(numel(rpmGrid) - 1, 1);   % bin width
    xl = [rpmGrid(1) - dr / 2, rpmGrid(end) + dr / 2];                 % image edges
    names = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
    units = {'N^2/Hz', 'N^2/Hz', 'N^2/Hz', 'N^2m^2/Hz', 'N^2m^2/Hz', 'N^2m^2/Hz'};
    for j = 1:6
        nexttile;
        Z = log10(Pm(:, :, j));
        h = imagesc(rpmGrid, f, Z); axis xy; set(h, 'AlphaData', ~isnan(Z));
        colormap(gca, jet); hold on;
        if isempty(cfg.campbellClim)
            top = ceil(max(Z(:), [], 'omitnan')); lo = top - cfg.campbellDecades;
        else
            lo = cfg.campbellClim(1); top = cfg.campbellClim(2);
        end
        caxis([lo top]);
        cb = colorbar; cb.Ticks = lo:top;
        cb.TickLabels = arrayfun(@(q) sprintf('10^{%d}', q), lo:top, 'UniformOutput', false);
        cb.Label.String = ['PSD (' units{j} ')'];
        for ord = cfg.orders
            plot(rpmGrid, ord * rpmGrid / 60, 'k--', 'LineWidth', 0.8);
        end
        ylim([0 fMax]); xlim(xl);
        xlabel('Speed (rpm)'); ylabel('Frequency (Hz)'); title(names{j});
    end
    sgtitle([ttl ' (dashed: spin orders ' num2str(cfg.orders) ')'], 'Interpreter', 'none');
end

function [ang0, uLow, dirStr, tErr] = startAngle(z, Fs, t0, accel, rpmQ, winSec, fn)
    % Angle [deg, top view, 0 = +X] and size [g mm] of the rotating 1x force at the motor start.
    % The stepper is open-loop, so during the ramp the wheel has turned theta = pi*(accel/60)*(t-t0)^2
    % from its start position. Each window's phasor of z = Fx + i*Fy is demodulated against theta
    % (both spin directions are tried; the stronger one is the real direction). An error dt in the
    % start time adds omega*dt to the phase, i.e. a term proportional to rpm, so phase vs rpm is
    % fitted with a line and the 0 rpm intercept is kept.
    ang0 = NaN; uLow = NaN; dirStr = ""; tErr = NaN;
    if numel(rpmQ) < 2, return; end
    t = (0:numel(z) - 1)' / Fs;
    Zc = complex(nan(2, numel(rpmQ)), nan(2, numel(rpmQ)));
    for k = 1:numel(rpmQ)
        tc = t0 + rpmQ(k) / accel;
        idx = t >= tc - winSec / 2 & t < tc + winSec / 2;
        if nnz(idx) < 0.9 * winSec * Fs, continue; end
        th = pi * (accel / 60) * (t(idx) - t0).^2;
        w = hann(nnz(idx));
        zz = z(idx) - mean(z(idx));
        Zc(1, k) = sum(w .* zz .* exp(-1i * th)) / sum(w);   % counter-clockwise (top view)
        Zc(2, k) = sum(w .* zz .* exp(+1i * th)) / sum(w);   % clockwise
    end
    ok = all(isfinite(Zc), 1);
    if nnz(ok) < 2, return; end
    [~, d] = max(sum(abs(Zc(:, ok)), 2));
    dirStr = "CCW"; if d == 2, dirStr = "CW"; end
    Z = Zc(d, ok); r = rpmQ(ok);
    p = polyfit(r, unwrap(angle(Z)), 1);
    ang0 = rad2deg(angle(exp(1i * p(2))));
    tErr = p(1) / (2 * pi / 60);
    amp = 1;
    if isfinite(fn), amp = 1 ./ (1 - (r / 60 / fn).^2); end   % resonance amplification
    uLow = mean(abs(Z) ./ amp ./ (2 * pi * r / 60).^2) * 1e6;
end

function [U0, fn, ok] = fitResonance(f, U, fMin)
    % Least-squares fit of U = U0/(1-(f/fn)^2), linearised as 1/U = a + b*f^2
    % (a = 1/U0, b = -1/(U0*fn^2)); rows weighted by U so residuals are relative errors in U.
    f = f(:); U = U(:);
    m = isfinite(U) & U > 0 & f >= fMin;
    U0 = NaN; fn = NaN; ok = false;
    if nnz(m) < 5, return; end
    A = [ones(nnz(m), 1), f(m).^2] .* U(m);
    p = A \ ones(nnz(m), 1);                               % = U .* (1 ./ U)
    if p(1) <= 0 || p(2) >= 0, return; end                % U must rise with speed
    U0 = 1 / p(1); fn = sqrt(-p(1) / p(2)); ok = true;
end

function fn = findRunFile(folder, fn, prefix)
    % Accept the naming variants used in the lab: RPM300_ / RPM_300_, SWEEP1500_ / SWEEP_1500_,
    % and 'imbalanced' / 'imbalance', as .mat (preferred, from convert_csv_to_mat) or .csv.
    % Returns '' if none of them exists.
    c = {fn, strrep(fn, prefix, [prefix '_'])};
    c = [c, strrep(c, 'imbalanced', 'imbalance')];
    c = [strrep(c, '.csv', '.mat'), c];
    for k = 1:numel(c)
        if isfile(fullfile(folder, c{k})), fn = c{k}; return; end
    end
    fn = '';
end

function S = readRunFile(file, cols, id)
    % Six sensor columns, in the order of COLS, from a run .mat or a FlexLogger CSV.
    if endsWith(file, '.mat')
        s = load(file, 'data', 'channels');
        [ok, j] = ismember(cols, s.channels);
        if ~all(ok), error('Channel(s) not found in %s: %s', id, strjoin(cols(~ok), ', ')); end
        S = double(s.data(:, j));
        return;
    end
    opts = detectImportOptions(file, 'VariableNamingRule', 'preserve');
    missing = cols(~ismember(cols, opts.VariableNames));
    if ~isempty(missing)
        error('Channel(s) not found in %s: %s\nColumns in the file: %s', ...
            id, strjoin(missing, ', '), strjoin(opts.VariableNames, ', '));
    end
    opts.SelectedVariableNames = cols;
    data = readtable(file, opts);
    S = zeros(height(data), numel(cols));
    for i = 1:numel(cols), S(:, i) = data.(cols{i}); end
end

function tCut = findRampCut(F6, Fs, t0, t1, accel)
    % Time the motor cut out during the ramp, or t1 if it did not. During the ramp the radial 1x
    % sits on the line f = accel/60*(t - t0); after a cut-out the wheel coasts and leaves it.
    % The cut is the start of the first 1 s window (two in a row, line above 5 Hz) whose power
    % on the line is 30 dB below the highest power on the line so far.
    tCut = t1;
    nw = round(1 * Fs);
    i0 = max(1, round(t0 * Fs) + 1); i1 = min(size(F6, 1), round(t1 * Fs));
    if i1 - i0 < 4 * nw, return; end
    S = 0;
    for j = 1:2
        [~, f, tt, P] = spectrogram(detrend(F6(i0:i1, j)), hann(nw), round(0.75 * nw), 2^nextpow2(8 * nw), Fs);
        S = S + P;
    end
    tabs = (i0 - 1) / Fs + tt(:)';
    fLine = accel / 60 * (tabs - t0);
    Pl = zeros(size(tabs));
    for q = 1:numel(tabs)
        Pl(q) = max(S(abs(f - fLine(q)) <= 0.5, q));
    end
    Pmax = cummax(Pl);
    low = Pl < Pmax / 1000 & fLine > 5;
    q = find(low(1:end-1) & low(2:end), 1, 'first');
    if ~isempty(q), tCut = tabs(q) - 0.5 * nw / Fs; end
end

function tEnd = findHoldEnd(F6, Fs, t0, t1, f0)
    % Time the hold ends: the start of the first 2 s window (two in a row) whose
    % radial 1x peak is below 97% of the hold frequency f0. Returns t1 if the speed
    % never drops (motor cut, or the record ends at the stop).
    tEnd = t1;
    nw = round(2 * Fs);
    i0 = max(1, round(t0 * Fs) + 1); i1 = min(size(F6, 1), round(t1 * Fs));
    if i1 - i0 < 3 * nw, return; end
    S = 0;
    for j = 1:2
        [~, f, tt, P] = spectrogram(detrend(F6(i0:i1, j)), hann(nw), round(0.75 * nw), 2^nextpow2(4 * nw), Fs);
        S = S + P;
    end
    band = f >= 0.3 * f0 & f <= 1.1 * f0;
    fb = f(band);
    [~, k] = max(S(band, :), [], 1);
    slow = fb(k)' < 0.97 * f0;
    q = find(slow(1:end-1) & slow(2:end), 1, 'first');
    if ~isempty(q)
        tEnd = (i0 - 1) / Fs + tt(q) - 0.5 * nw / Fs;   % start of that window
    end
end

function marks(tStart, tRampEnd, win)
    xline(tStart, ':g', 'HandleVisibility', 'off');
    xline(tRampEnd, ':k', 'HandleVisibility', 'off');
    xline(win(1), '--k', 'HandleVisibility', 'off');
    xline(win(2), '--k', 'HandleVisibility', 'off');
end

function saveFig(fig, cfg, name, closeAfter)
    if cfg.savePlots
        % hide the axes toolbars so exportgraphics doesn't warn about them
        for ax = findall(fig, 'Type', 'axes')'
            try, ax.Toolbar.Visible = 'off'; catch, end
        end
        try
            exportgraphics(fig, fullfile(cfg.outputFolder, [name '.png']), 'Resolution', 150);
        catch ME
            fprintf('Could not save %s: %s\n', name, ME.message);
        end
    end
    if closeAfter && cfg.closeRunFigures, close(fig); end
end
