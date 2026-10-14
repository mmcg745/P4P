%% ===================== RWA RIG TAP TEST =====================
% Finds the natural frequencies of the platform from tap (impact) tests.
% For every TAP_*.csv in the test folder this script:
%   1) finds each tap (sudden jump above the quiet level at the start of the record)
%   2) takes the free ring-down after each tap and computes its spectrum
%   3) averages the spectra over all taps in the file, for each wrench component
%      Fx Fy Fz Mx My Mz (same sensor geometry as analyze_rwa_campbell.m)
%   4) lists the main peaks (natural frequencies) and plots everything
%
% How to record: motor OFF, ~3 s quiet at the start, then ~5 taps about 3 s apart.
% One file per tap direction, e.g. TAP_X_1.csv, TAP_Y_1.csv, TAP_Z_1.csv, TAP_TOP_1.csv.
% Light to moderate taps (pen / plastic handle). The script warns if a radial
% sensor sees more than cfg.radialWarnN (Ry1 is a 0.8 mm wire - buckling risk).
%
% Requires: Signal Processing Toolbox (hann), R2019b+.

clear; clc; close all;

%% ===================== USER SETTINGS =====================

scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
cfg.testFolder   = '15_10_26_tests';            % <<< change this for each test session
cfg.dataFolder   = fullfile(scriptDir, cfg.testFolder);
cfg.filePattern  = 'TAP_*.csv';
cfg.outputFolder = fullfile(cfg.dataFolder, 'tap_output');
cfg.Fs           = 10000;                      % [Hz] FlexLogger sample rate

% --- Sensors and geometry: keep these the same as analyze_rwa_campbell.m ---
cfg.sensorNames = {'Rx1', 'Rx2', 'Ry1', 'Az1', 'Az2', 'Az3'};
cfg.sensorCols  = {'cDAQ1Mod1/ai0', 'cDAQ1Mod1/ai1', 'cDAQ1Mod1/ai2', ...
                   'cDAQ1Mod2/ai0', 'cDAQ1Mod2/ai1', 'cDAQ1Mod2/ai2'};
cfg.sensorSign  = [ 1  1  1    1  1  1];
cfg.sensorScale = [ 1  1  1    1  1  1];
geo.R   = 0.050;
geo.axialAngleDeg = [240 0 120];
geo.s   = 0.105;
geo.yRx = [-geo.s/2, +geo.s/2];
geo.zr  = 0.140;
geo.xRy = 0;

% --- Tap detection ---
cfg.baselineSkipSec  = 0.3;  % [s] ignore the start (IEPE settling)
cfg.baselineSec      = 1.5;  % [s] quiet reference period after the skip
cfg.tapThresh        = 20;   % a tap = any channel jumps this many baseline std devs
cfg.minTapGapSec     = 1.0;  % [s] taps closer than this count as one (bounces)

% --- Ring-down spectrum ---
cfg.skipAfterTapSec  = 0.005;% [s] skip the impact itself
cfg.segSec           = 1.0;  % [s] ring-down length analysed after each tap (cut short by the next tap)
cfg.fMin             = 5;    % [Hz] ignore below this (IEPE high-pass, drift)
cfg.fMax             = 500;  % [Hz] upper limit for plots and peak search
cfg.nPeaks           = 6;    % number of peaks listed per component
cfg.peakMinRatio     = 10;   % a peak must be this many times the median spectrum level
cfg.radialWarnN      = 4;    % [N] warn if a radial sensor exceeds this

cfg.savePlots = true;

%% ===================== RUN =====================

if ~exist(cfg.outputFolder, 'dir'), mkdir(cfg.outputFolder); end
W = buildWrenchMatrix(geo);
files = dir(fullfile(cfg.dataFolder, cfg.filePattern));
if isempty(files), error('No %s files found in %s', cfg.filePattern, cfg.dataFolder); end
fprintf('%d tap file(s) found.\n', numel(files));

wNames = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
rows = {};
allSpec = struct('name', {}, 'f', {}, 'P', {});
for k = 1:numel(files)
    [~, name] = fileparts(files(k).name);
    fprintf('\n=== %s ===\n', name);
    S = loadSensors(fullfile(files(k).folder, files(k).name), cfg);
    N = size(S, 1); t = (0:N-1)' / cfg.Fs;
    fprintf('Loaded %d samples (%.1f s)\n', N, N / cfg.Fs);

    % tare on the quiet start and convert to the wrench
    iBase = t >= cfg.baselineSkipSec & t < cfg.baselineSkipSec + cfg.baselineSec;
    if nnz(iBase) < 100, error('%s: record too short for a %.1f s quiet baseline.', name, cfg.baselineSec); end
    S = S - mean(S(iBase, :), 1);
    F6 = S * W.';

    % ---- find taps ----
    sd = std(S(iBase, :), 0, 1);
    sd(sd == 0) = eps;
    score = max(abs(S) ./ sd, [], 2);
    score(t < cfg.baselineSkipSec + cfg.baselineSec) = 0;
    hit = find(score > cfg.tapThresh);
    if isempty(hit)
        warning('%s: no taps found (no channel above %g x the quiet level). Skipped.', name, cfg.tapThresh);
        continue;
    end
    gap = round(cfg.minTapGapSec * cfg.Fs);
    tapIdx = hit([true; diff(hit) > gap]);
    nT = numel(tapIdx);
    fprintf('%d tap(s) found at t = %s s\n', nT, strjoin(compose('%.2f', t(tapIdx)), ', '));

    % peak sensor forces (buckling check on the thin radial wires)
    pk = max(abs(S), [], 1);
    fprintf('Peak sensor forces: %s\n', strjoin(compose('%s %.2f N', string(cfg.sensorNames'), pk'), ', '));
    if any(pk(1:3) > cfg.radialWarnN)
        warning('%s: a radial sensor saw more than %g N - tap more gently (Ry1 buckling risk).', name, cfg.radialWarnN);
    end

    % ---- ring-down spectra, averaged over taps ----
    nSeg = round(cfg.segSec * cfg.Fs);
    nfft = 2^nextpow2(4 * nSeg);                         % zero padding -> finer frequency grid
    f = (0:nfft/2)' * cfg.Fs / nfft;
    Psum = zeros(numel(f), 6); nUsed = 0;
    for q = 1:nT
        i0 = tapIdx(q) + round(cfg.skipAfterTapSec * cfg.Fs);
        i1 = i0 + nSeg - 1;
        if q < nT, i1 = min(i1, tapIdx(q+1) - round(0.05 * cfg.Fs)); end
        i1 = min(i1, N);
        if i1 - i0 < 0.2 * cfg.Fs, continue; end         % ring-down too short to use
        seg = F6(i0:i1, :);
        seg = seg - mean(seg, 1);
        w = hann(size(seg, 1), 'periodic');
        w = w(:);
        % half-Hann on the tail only: keep the start of the decay, taper the end to zero
        half = ceil(numel(w) / 2);
        win = ones(size(seg, 1), 1); win(half:end) = w(half:end);
        X = fft(seg .* win, nfft);
        Psum = Psum + abs(X(1:numel(f), :)).^2;
        nUsed = nUsed + 1;
    end
    if nUsed == 0
        warning('%s: taps too close together to analyse - leave ~3 s between taps.', name);
        continue;
    end
    P = Psum / nUsed;
    allSpec(end+1) = struct('name', name, 'f', f, 'P', P); %#ok<SAGROW>
    fprintf('Spectrum averaged over %d tap(s).\n', nUsed);

    % ---- peaks per component ----
    band = f >= cfg.fMin & f <= cfg.fMax;
    pkList = cell(1, 6);
    for j = 1:6
        pf = findPeaksSimple(f(band), P(band, j), cfg.nPeaks, cfg.peakMinRatio);
        pkList{j} = pf;
        fprintf('  %-2s peaks (Hz): %s\n', wNames{j}, strjoin(compose('%.1f', pf(:)'), ', '));
        rows(end+1, :) = {string(name), string(wNames{j}), strjoin(compose('%.1f', pf(:)'), ' ')}; %#ok<SAGROW>
    end

    % ---- figures ----
    fig1 = figure('Name', [name ' - time'], 'Position', [80 80 1100 600]);
    tiledlayout(2, 1, 'TileSpacing', 'compact');
    nexttile; plot(t, S(:, 1:3)); grid on; hold on;
    xline(t(tapIdx), ':k', 'HandleVisibility', 'off');
    legend(cfg.sensorNames(1:3)); ylabel('Force (N)');
    title([name ' - radial sensors (dotted: detected taps)'], 'Interpreter', 'none');
    nexttile; plot(t, S(:, 4:6)); grid on; hold on;
    xline(t(tapIdx), ':k', 'HandleVisibility', 'off');
    legend(cfg.sensorNames(4:6)); ylabel('Force (N)'); xlabel('Time (s)');
    title('axial sensors');
    saveFig(fig1, cfg, [name '_time']);

    fig2 = figure('Name', [name ' - spectra'], 'Position', [80 80 1200 750]);
    tiledlayout(3, 2, 'TileSpacing', 'compact');
    for j = 1:6
        nexttile; semilogy(f(band), P(band, j)); grid on; hold on;
        for pf = pkList{j}(:)'
            xline(pf, ':r', sprintf('%.0f', pf), 'LabelVerticalAlignment', 'top', 'HandleVisibility', 'off');
        end
        xlim([0 cfg.fMax]); title(wNames{j}); xlabel('Frequency (Hz)'); ylabel('|X|^2 (rel.)');
    end
    sgtitle([name ' - ring-down spectrum, mean of ' num2str(nUsed) ' tap(s)'], 'Interpreter', 'none');
    saveFig(fig2, cfg, [name '_spectrum']);
end

%% ===================== COMPARISON + SUMMARY =====================

if ~isempty(allSpec)
    fig3 = figure('Name', 'Tap comparison', 'Position', [80 80 1200 750]);
    tiledlayout(3, 2, 'TileSpacing', 'compact');
    for j = 1:6
        nexttile; hold on;
        for k = 1:numel(allSpec)
            b = allSpec(k).f >= cfg.fMin & allSpec(k).f <= cfg.fMax;
            P = allSpec(k).P(b, j);
            plot(allSpec(k).f(b), P / max(P), 'DisplayName', allSpec(k).name);
        end
        set(gca, 'YScale', 'log'); grid on; xlim([0 cfg.fMax]);
        title(wNames{j}); xlabel('Frequency (Hz)'); ylabel('normalised');
        if j == 1, legend('Interpreter', 'none', 'Location', 'southwest'); end
    end
    sgtitle('All tap files (each normalised to its own maximum)');
    saveFig(fig3, cfg, 'tap_comparison');

    T = cell2table(rows, 'VariableNames', {'File', 'Component', 'Peaks_Hz'});
    writetable(T, fullfile(cfg.outputFolder, 'tap_summary.csv'));
    fprintf('\nSummary saved to %s\n', fullfile(cfg.outputFolder, 'tap_summary.csv'));
end
fprintf('Done. Figures are in %s\n', cfg.outputFolder);

%% ===================== LOCAL FUNCTIONS =====================

function S = loadSensors(file, cfg)
    opts = detectImportOptions(file, 'VariableNamingRule', 'preserve');
    missing = cfg.sensorCols(~ismember(cfg.sensorCols, opts.VariableNames));
    if ~isempty(missing)
        error('Channel(s) not found in %s: %s\nColumns in the file: %s', ...
            file, strjoin(missing, ', '), strjoin(opts.VariableNames, ', '));
    end
    opts.SelectedVariableNames = cfg.sensorCols;
    data = readtable(file, opts);
    S = zeros(height(data), 6);
    for i = 1:6, S(:, i) = data.(cfg.sensorCols{i}); end
    last = find(all(isfinite(S), 2), 1, 'last');      % modules can end a few samples apart
    S = S(1:last, :) .* (cfg.sensorSign .* cfg.sensorScale);
end

function pf = findPeaksSimple(f, P, nMax, minRatio)
    % Local maxima that stand at least minRatio above the median level AND at least
    % minRatio above the dip separating them from any taller neighbour (prominence -
    % this drops bumps on the skirt of a bigger peak). Strongest first, at least 3%
    % apart in frequency. Returned sorted by frequency.
    isPk = [false; P(2:end-1) > P(1:end-2) & P(2:end-1) >= P(3:end); false];
    isPk = isPk & P > minRatio * median(P);
    idx = find(isPk);
    prom = false(size(idx));
    for q = 1:numel(idx)
        i = idx(q);
        L = find(P(1:i-1) > P(i), 1, 'last');  if isempty(L), L = 1; end
        R = find(P(i+1:end) > P(i), 1, 'first'); if isempty(R), R = numel(P); else, R = i + R; end
        base = max(min(P(L:i)), min(P(i:R)));
        prom(q) = P(i) >= minRatio * base;
    end
    idx = idx(prom);
    [~, o] = sort(P(idx), 'descend');
    idx = idx(o);
    keep = [];
    for i = idx(:)'
        if all(abs(f(i) - f(keep)) > 0.03 * f(i)), keep(end+1) = i; end %#ok<AGROW>
        if numel(keep) >= nMax, break; end
    end
    pf = sort(f(keep));
end

function W = buildWrenchMatrix(geo)
    % Same as analyze_rwa_campbell.m: columns [d; p x d] for each stinger,
    % sensor order [Rx1 Rx2 Ry1 Az1 Az2 Az3] -> wrench [Fx Fy Fz Mx My Mz].
    ang = deg2rad(geo.axialAngleDeg);
    P = [ 0,       geo.yRx(1), geo.zr;
          0,       geo.yRx(2), geo.zr;
          geo.xRy, 0,          geo.zr;
          geo.R*cos(ang(1)), geo.R*sin(ang(1)), 0;
          geo.R*cos(ang(2)), geo.R*sin(ang(2)), 0;
          geo.R*cos(ang(3)), geo.R*sin(ang(3)), 0 ];
    D = [1 0 0; 1 0 0; 0 1 0; 0 0 1; 0 0 1; 0 0 1];
    W = zeros(6, 6);
    for i = 1:6
        W(1:3, i) = D(i, :)';
        W(4:6, i) = cross(P(i, :), D(i, :))';
    end
end

function saveFig(fig, cfg, name)
    if ~cfg.savePlots, return; end
    for ax = findall(fig, 'Type', 'axes')'
        try, ax.Toolbar.Visible = 'off'; catch, end
    end
    try
        exportgraphics(fig, fullfile(cfg.outputFolder, [name '.png']), 'Resolution', 150);
    catch ME
        fprintf('Could not save %s: %s\n', name, ME.message);
    end
end
