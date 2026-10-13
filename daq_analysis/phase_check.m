% Phase repeatability of the 1x imbalance force for the 13 Oct known-mass runs, which all
% started with the 1.48 g mass at 6 o'clock (-Y). No tach: the wheel angle comes from the
% start time and the constant ramp, theta(t) = pi*(accel/60)*(t - tStart)^2, so the phase is
% taken from short windows early in the ramp (an error dt in tStart moves the phase by
% omega*dt, i.e. ~12 deg per 0.01 s at 200 rpm).
set(0, 'DefaultFigureVisible', 'off');
D  = 'C:/Users/matth/OneDrive - The University of Auckland/Part IV/P4P/P4P Shared/DAQ/P4P NI DAQ/12_10_26_tests';
Fs = 10000; ry1Scale = 1.11;
T  = readtable(fullfile(D, 'analysis_output', 'summary.csv'), 'TextType', 'string');
sel = find(T.Condition == "imbalanced_1W");
cols = {'cDAQ1Mod1/ai0', 'cDAQ1Mod1/ai1', 'cDAQ1Mod1/ai2'};
rpmQ = 150:50:450;
fprintf('%-30s %5s  %s   (phase of the rotating 1x force at t0 [deg]; dir)\n', 'run', 'accel', sprintf('%9d rpm', rpmQ));
allPh = nan(numel(sel), numel(rpmQ));
for r = 1:numel(sel)
    id = T.Run(sel(r)); acc = 37.5; if T.Kind(sel(r)) == "sweep", acc = 15; end
    t0 = T.tStart_s(sel(r));
    o = detectImportOptions(fullfile(D, id + ".csv"), 'VariableNamingRule', 'preserve');
    o.SelectedVariableNames = cols;
    S = table2array(readtable(fullfile(D, id + ".csv"), o)); S = S(all(isfinite(S), 2), :);
    z = (S(:,1) + S(:,2)) + 1i * ry1Scale * S(:,3);          % Fx + i*Fy
    t = (0:numel(z)-1)' / Fs;
    out = strings(1, numel(rpmQ)); dirs = strings(1, numel(rpmQ));
    for k = 1:numel(rpmQ)
        tc = t0 + rpmQ(k) / acc;
        idx = t >= tc - 0.5 & t < tc + 0.5;
        th = pi * (acc / 60) * (t(idx) - t0).^2;
        w = hann(nnz(idx));
        zz = z(idx) - mean(z(idx));
        Zccw = sum(w .* zz .* exp(-1i * th));             % force rotating counter-clockwise (top view)
        Zcw  = sum(w .* zz .* exp(+1i * th));             % clockwise
        if abs(Zccw) >= abs(Zcw), Z = Zccw; dirs(k) = "CCW"; else, Z = Zcw; dirs(k) = "CW"; end
        allPh(r, k) = rad2deg(angle(Z));
        out(k) = sprintf('%8.1f %-3s', allPh(r, k), dirs(k));
    end
    fprintf('%-30s %5.1f  %s\n', id, acc, strjoin(out, '  '));
end
for k = 1:numel(rpmQ)
    p = deg2rad(allPh(:, k));
    m = angle(mean(exp(1i * p)));
    cs = rad2deg(sqrt(-2 * log(abs(mean(exp(1i * p))))));   % circular std
    fprintf('%d rpm: circular mean %.1f deg, circular std %.1f deg (n = %d)\n', rpmQ(k), rad2deg(m), cs, numel(p));
end
% A start-time error dt adds omega*dt to the phase, i.e. a term proportional to rpm.
% Fitting phase vs rpm per run and taking the 0 rpm intercept removes it.
fprintf('\nIntercept at 0 rpm (start-time error removed) and implied start-time error:\n');
ic = nan(numel(sel), 1);
for r = 1:numel(sel)
    use = rpmQ <= T.RPM(sel(r)) - 50;            % windows fully inside this run's ramp
    ph = rad2deg(unwrap(deg2rad(allPh(r, use))));
    p = polyfit(rpmQ(use), ph, 1);
    ic(r) = mod(p(2) + 180, 360) - 180;
    dt = deg2rad(p(1)) / (2*pi/60);              % [s]: slope [deg/rpm] -> dt
    fprintf('%-30s intercept %7.1f deg   start-time error %+6.3f s\n', T.Run(sel(r)), ic(r), dt);
end
cm = angle(mean(exp(1i*deg2rad(ic))));
fprintf('Intercepts: circular mean %.1f deg, circular std %.1f deg (n = %d)\n', rad2deg(cm), ...
        rad2deg(sqrt(-2*log(abs(mean(exp(1i*deg2rad(ic))))))), numel(ic));
fprintf('Expected direction of the added mass at t0: -90 deg (6 o''clock, -Y).\n');
