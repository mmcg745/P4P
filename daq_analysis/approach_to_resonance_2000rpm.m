% 1x imbalance tracked through the 75 rpm/s ramp of the 2000 rpm washer run (cut at ~1900 rpm),
% compared with the resonance model fitted to the 1500 rpm washer sweeps (U0 = 108.5, fn = 39.0 Hz).
set(0,'DefaultFigureVisible','off');
Fs = 10000; acc = 75; f = fullfile('C:/Users/matth/OneDrive - The University of Auckland/Part IV/P4P/P4P Shared/DAQ/P4P NI DAQ/12_10_26_tests', 'RPM_2000_imbalanced_1W_T1.csv');
o = detectImportOptions(f,'VariableNamingRule','preserve'); o.SelectedVariableNames = {'cDAQ1Mod1/ai0','cDAQ1Mod1/ai1','cDAQ1Mod1/ai2'};
S = table2array(readtable(f,o)); S = S(all(isfinite(S),2),:);
Fx = S(:,1)+S(:,2); Fy = 1.11*S(:,3); N = size(S,1); t = (0:N-1)'/Fs;   % Ry1 scaled to the calibrated Rx sensors
% start time: fit t - f/slope on the ridge between 700 and 1800 rpm
nw = 2*Fs; [~,fr,tt,P1] = spectrogram(detrend(Fx),hann(nw),round(0.75*nw),2^16,Fs); [~,~,~,P2] = spectrogram(detrend(Fy),hann(nw),round(0.75*nw),2^16,Fs);
P = P1+P2; b = fr>=8 & fr<=31; fb = fr(b); [pk,k] = max(P(b,:),[],1); fpk = fb(k)';
[~, iCut] = max(pk);   % strongest 1x = just before the cut
m = fpk > 700/60 & fpk < 1800/60 & (1:numel(fpk)) < iCut;
fprintf('peak 1x %.0f rpm at t = %.1f s (cut)\n', 60*fpk(iCut), tt(iCut));
t0 = median(tt(m) - fpk(m)/(acc/60));
pf = polyfit(tt(m), fpk(m), 1);
fprintf('tStart = %.2f s, ramp rate check: %.1f rpm/s\n', t0, 60*pf(1));
rpm = 300:25:1900; U = nan(size(rpm)); w = hann(nw);
for kq = 1:numel(rpm)
  tc = t0 + rpm(kq)/acc; a = round((tc-1)*Fs)+1; bb = a+nw-1;
  tw = t(a:bb); ph = 2*pi*(acc/60)*0.5*(tw-t0).^2; A = zeros(1,2); X = [Fx(a:bb) Fy(a:bb)];
  for j = 1:2, x = X(:,j)-mean(X(:,j)); A(j) = abs(2/sum(w)*sum(w.*x.*exp(-1j*ph))); end
  U(kq) = sqrt((A(1)^2+A(2)^2)/2)/(2*pi*rpm(kq)/60)^2*1e6;
end
Um = 108.5./(1-(rpm/60/39.0).^2);
for r = [300 600 1000 1500 1700 1800 1900], i = find(rpm==r); fprintf('%5d rpm: measured %6.1f  model %6.1f g.mm\n', r, U(i), Um(i)); end
fig = figure('Position',[80 80 1000 600]); plot(rpm, U, 'b-', 'LineWidth', 1.5); hold on;
plot(rpm, Um, 'r--', 'LineWidth', 1.2); yline(96.2, 'k:', 'added mass m*r = 96.2 g.mm');
grid on; xlabel('Speed (rpm)'); ylabel('U = F_{1x}/\omega^2 (g mm)');
legend('measured, 75 rpm/s ramp to ~1900 rpm', 'model from 1500 rpm sweeps: U_0 = 108.5, f_n = 39.0 Hz', 'Location', 'northwest');
title('Known 1.48 g imbalance approaching the 39 Hz platform mode (RPM\_2000\_imbalanced\_1W\_T1)');
exportgraphics(fig, fullfile('C:/Users/matth/OneDrive - The University of Auckland/Part IV/P4P/P4P Shared/DAQ/P4P NI DAQ/12_10_26_tests', 'analysis_output', 'approach_to_resonance_2000rpm.png'), 'Resolution', 150);
