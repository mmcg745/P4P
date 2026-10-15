function export_run_csv(matFile, csvFile)
% EXPORT_RUN_CSV  Recreate a FlexLogger-style CSV from a run .mat made by convert_csv_to_mat.
%   export_run_csv('15_10_26_tests/RPM_600_baseline_T1.mat')
%   export_run_csv(matFile, csvFile)   % choose the output name
% Writes Time + the six channels on the original uniform time base (fs from the .mat).

if nargin < 2, csvFile = [erase(matFile, '.mat') '.csv']; end
s = load(matFile);
n = size(s.data, 1);
t = datetime(s.t0, 'InputFormat', 'dd/MM/yyyy HH:mm:ss.SSSSSS') + seconds((0:n-1)' / s.fs);
ts = cellstr(string(t, 'dd/MM/yyyy HH:mm:ss.SSSSSS'));
fid = fopen(csvFile, 'w');
fprintf(fid, 'Time,%s\n', strjoin(s.channels, ','));
C = [ts, num2cell(double(s.data))]';
fprintf(fid, '%s,%.9g,%.9g,%.9g,%.9g,%.9g,%.9g\n', C{:});
fclose(fid);
fprintf('wrote %s (%d rows)\n', csvFile, n);
end
