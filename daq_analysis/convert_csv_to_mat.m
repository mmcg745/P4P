function convert_csv_to_mat(folders)
% CONVERT_CSV_TO_MAT  Save each FlexLogger CSV run as a compressed .mat (~7x smaller).
%   convert_csv_to_mat({'11_10_26_tests', '12_10_26_tests', '15_10_26_tests'})
% For every <name>.csv directly in each folder this writes <name>.mat containing
%   data      N x 6 single, columns as in CHANNELS (same order as the CSV)
%   channels  1 x 6 cell of channel names
%   fs        sample rate [Hz] (10000; the CSV time base is uniform)
%   t0        time stamp of the first row (char, as in the CSV)
%   sourceCsv original file name
% Single precision keeps ~7 significant digits (rounding error ~5e-8 of full scale), far below
% the sensor noise. Existing .mat files are skipped. The CSVs are NOT deleted here.
% analyze_rwa_campbell.m / analyze_tap_test.m read the .mat when it exists. To get a CSV back,
% use export_run_csv.m.

if ischar(folders), folders = {folders}; end
here = fileparts(mfilename('fullpath'));
channels = {'cDAQ1Mod1/ai0', 'cDAQ1Mod1/ai1', 'cDAQ1Mod1/ai2', ...
            'cDAQ1Mod2/ai0', 'cDAQ1Mod2/ai1', 'cDAQ1Mod2/ai2'};
for k = 1:numel(folders)
    folder = folders{k};
    if ~isfolder(folder), folder = fullfile(here, folders{k}); end
    files = dir(fullfile(folder, '*.csv'));
    fprintf('\n%s: %d CSV file(s)\n', folder, numel(files));
    for f = files'
        src = fullfile(f.folder, f.name);
        dst = fullfile(f.folder, [erase(f.name, '.csv') '.mat']);
        if isfile(dst), fprintf('  skip (exists) %s\n', f.name); continue; end
        opts = detectImportOptions(src, 'VariableNamingRule', 'preserve');
        if ~all(ismember(channels, opts.VariableNames))
            fprintf('  skip (not a run file) %s\n', f.name); continue;
        end
        opts.SelectedVariableNames = channels;
        A = readmatrix(src, opts);
        [t0, t1] = firstLastTime(src);
        n = size(A, 1);
        fs = 10000;
        span = seconds(datetime(t1, 'InputFormat', 'dd/MM/yyyy HH:mm:ss.SSSSSS') - ...
                       datetime(t0, 'InputFormat', 'dd/MM/yyyy HH:mm:ss.SSSSSS'));
        if abs(span - (n - 1) / fs) > 1e-3
            warning('%s: time stamps are not a uniform 10 kHz grid (span %.4f s for %d rows) - skipped.', f.name, span, n);
            continue;
        end
        data = single(A);
        err = max(abs(double(data(:)) - A(:)), [], 'omitnan') / max(abs(A(:)), [], 'omitnan');
        sourceCsv = f.name;
        save(dst, 'data', 'channels', 'fs', 't0', 'sourceCsv', '-v7');
        g = dir(dst);
        fprintf('  %-40s %7.1f MB -> %6.1f MB, %d rows, max rel. rounding %.1e\n', f.name, f.bytes / 1e6, g.bytes / 1e6, n, err);
    end
end
end

function [t0, t1] = firstLastTime(file)
    fid = fopen(file, 'r');
    fgetl(fid);                                   % header
    l = fgetl(fid); t0 = extractBefore(string(l), ',');
    fseek(fid, -400, 'eof'); tail = fread(fid, [1 inf], '*char');
    fclose(fid);
    lines = splitlines(strtrim(string(tail)));
    t1 = extractBefore(lines(end), ',');
    t0 = char(t0); t1 = char(t1);
end
