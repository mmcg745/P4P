% =========================================================================
% MODAL ANALYSIS PARAMETRIC STUDY PLOTS
% RWA Measurement Device — Stinger Geometry Study
% =========================================================================

clc; clear; close all;

%% DATA

% Study 1: Diameter variation, L = 50mm fixed
diameters = [1.6, 1.8, 2.0, 2.2];
data_diam = [
    279.70, 325.89, 592.80, 742.66, 801.25, 842.54;
    306.03, 354.58, 650.84, 817.44, 869.83, 919.67;
    330.38, 380.70, 704.95, 887.71, 930.93, 989.97;
    352.93, 404.41, 755.31, 953.60, 985.51, 1054.2;
];

% Study 2: Both lengths varied equally, d = 2mm
lengths_both = [50, 52.5, 55, 75];
data_both = [
    330.38, 380.70, 704.95, 887.71, 930.93, 989.97;
    323.52, 373.89, 692.71, 869.40, 911.04, 969.86;
    316.95, 367.45, 681.25, 852.22, 892.17, 950.92;
    276.54, 326.04, 605.88, 743.81, 774.76, 831.66;
];

% Study 3: Axial length only, d = 2mm, L_rad = 50mm
L_axial_vals = [50, 80, 100];
data_axial = [
    330.38, 380.70, 704.95, 887.71, 930.93, 989.97;
    295.55, 336.51, 591.87, 761.69, 861.03, 876.84;
    277.42, 314.48, 540.77, 701.72, 810.36, 818.35;
];

%% SETTINGS

mode_labels = {'Mode 1','Mode 2','Mode 3','Mode 4','Mode 5','Mode 6'};
mode_colors = [
    0.85  0.10  0.10;
    0.90  0.45  0.10;
    0.15  0.45  0.80;
    0.10  0.62  0.30;
    0.55  0.18  0.75;
    0.00  0.62  0.62;
];
lw = 2.0;

%% STUDY 1 — DIAMETER

figure(1);
hold on;
for m = 1:6
    plot(diameters, data_diam(:,m), '-', ...
        'Color', mode_colors(m,:), 'LineWidth', lw);
end
% Line labels at right end
xr = diameters(end);
dx = (diameters(end)-diameters(1))*0.02;
for m = 1:6
    text(xr+dx, data_diam(end,m), mode_labels{m}, ...
        'Color', mode_colors(m,:), 'FontSize', 8.5, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
xlabel('Stinger Diameter  d  [mm]', 'FontSize', 12);
ylabel('Natural Frequency  [Hz]', 'FontSize', 12);
title('Effect of Stinger Diameter on Natural Frequencies', ...
      'FontSize', 13, 'FontWeight', 'bold');
subtitle('L_{axial} = L_{radial} = 50 mm', 'FontSize', 10);
grid on; box on;
xlim([1.55 2.38]);
xticks(diameters);
xticklabels({'1.6','1.8','2.0','2.2'});
set(gca, 'FontSize', 10);

%% STUDY 2 — BOTH LENGTHS

figure(2);
hold on;
for m = 1:6
    plot(lengths_both, data_both(:,m), '-', ...
        'Color', mode_colors(m,:), 'LineWidth', lw);
end
xr = lengths_both(end);
dx = (lengths_both(end)-lengths_both(1))*0.02;
for m = 1:6
    text(xr+dx, data_both(end,m), mode_labels{m}, ...
        'Color', mode_colors(m,:), 'FontSize', 8.5, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
xlabel('Stinger Length  L  [mm]  (L_{axial} = L_{radial})', 'FontSize', 12);
ylabel('Natural Frequency  [Hz]', 'FontSize', 12);
title('Effect of Equal Length Variation on Natural Frequencies', ...
      'FontSize', 13, 'FontWeight', 'bold');
subtitle('d = 2.0 mm', 'FontSize', 10);
grid on; box on;
xlim([49 83]);
xticks(lengths_both);
xticklabels({'50','52.5','55','75'});
set(gca, 'FontSize', 10);

%% STUDY 3 — AXIAL LENGTH ONLY

figure(3);
hold on;
for m = 1:6
    plot(L_axial_vals, data_axial(:,m), '-', ...
        'Color', mode_colors(m,:), 'LineWidth', lw);
end
xr = L_axial_vals(end);
dx = (L_axial_vals(end)-L_axial_vals(1))*0.02;
for m = 1:6
    text(xr+dx, data_axial(end,m), mode_labels{m}, ...
        'Color', mode_colors(m,:), 'FontSize', 8.5, ...
        'FontWeight', 'bold', 'VerticalAlignment', 'middle');
end
xlabel('Axial Stinger Length  L_{axial}  [mm]', 'FontSize', 12);
ylabel('Natural Frequency  [Hz]', 'FontSize', 12);
title('Effect of Axial Stinger Length on Natural Frequencies', ...
      'FontSize', 13, 'FontWeight', 'bold');
subtitle('d = 2.0 mm,  L_{radial} = 50 mm fixed', 'FontSize', 10);
grid on; box on;
xlim([48 108]);
xticks(L_axial_vals);
xticklabels({'50','80','100'});
set(gca, 'FontSize', 10);
