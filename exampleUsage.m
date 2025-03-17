% exampleUsage.m
% This script demonstrates the usage of the MEASRR functions. The example
% data is not meaningful and is provided to illustrate function usage only.
% 
% Omkar Athavale, March 2025

% load data
load('data/exampleData.mat')

% recompose
phase = recomposeAndPhaseSignalAutoFreq(d, fs);

% recurrence
ds = 5;
[RP,phaseD, tD] = compute_recurrencePlots(phase, t, fs, array, 'Downsample', ds);

% plot recurrence plot
threshold = 0.9;
figure;
imagesc(RP<threshold)
colormap(flipud(gray));

xticks(tD(1:60:end)*ds)
yticks(tD(1:60:end)*ds)
xticklabels(tD(1:60:end))
yticklabels(tD(1:60:end))

xlabel('Time (s)')
ylabel('Time (s)')

% metrics
windows = 10:30:140;
[RR, ~, ~, L] = metricsOnSubsetParallel(RP<threshold, tD, 100, 45, windows);

% plot metrics
figure;
subplot(2,1,1)
plot(windows, RR, 'k')
xlabel('Time (s)')
ylabel('Recurrence Rate')

subplot(2,1,2)
plot(windows, L, 'k')
xlabel('Time (s)')
ylabel('Average diagonal line length')
