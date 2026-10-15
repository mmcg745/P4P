% Convert the recovered FlexLogger TDMS (10240 Hz) to the 10 kHz CSV format FlexLogger exports.
src = 'SWEEP_1500_imbalanced_2W_T1.tdms'; out = 'SWEEP_1500_imbalanced_2W_T1.csv';
FsIn = 10240; FsOut = 10000; t0 = datetime(2026,10,15,10,57,28.132);
d = tdmsread(src); A = d{2}{:,:};
n = find(all(isfinite(A), 2), 1, 'last'); A = A(1:n, :);       % modules end a few samples apart
tin = (0:n-1)' / FsIn;
tout = (0:floor(tin(end) * FsOut))' / FsOut;
B = interp1(tin, A, tout, 'linear');
ts = string(t0 + seconds(tout), 'dd/MM/yyyy HH:mm:ss.SSSSSS');
fid = fopen(out, 'w');
fprintf(fid, 'Time,cDAQ1Mod1/ai0,cDAQ1Mod1/ai1,cDAQ1Mod1/ai2,cDAQ1Mod2/ai0,cDAQ1Mod2/ai1,cDAQ1Mod2/ai2\n');
C = [cellstr(ts), num2cell(B)]';
fprintf(fid, '%s,%.15g,%.15g,%.15g,%.15g,%.15g,%.15g\n', C{:});
fclose(fid);
fprintf('wrote %s: %d rows (%.1f s) from %d TDMS samples\n', out, numel(tout), tout(end), n);
% check: speed during the hold should be 25.00 Hz
x = B(:,1) + B(:,2); y = 1.11 * B(:,3);
for tc = [70 100 115 125]
    a = tc*FsOut + 1; b = a + 2*FsOut - 1; w = hann(b-a+1);
    X = abs(fft((x(a:b)-mean(x(a:b))).*w, 8*(b-a+1))).^2 + abs(fft((y(a:b)-mean(y(a:b))).*w, 8*(b-a+1))).^2;
    f = (0:numel(X)-1)' * FsOut / numel(X); m = f > 2 & f < 35; fm = f(m); [~, k] = max(X(m));
    fprintf('t=%3d s: 1x %5.2f Hz (%5.0f rpm)\n', tc, fm(k), 60*fm(k));
end
