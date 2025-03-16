% % syntheticScript.m
% This script gives examples of synthetic signal generation for a limited
% set of patterns as commented below.
%
% Omkar Athavale, February 2025
%

%% Setup
addpath(genpath('../'))

% set the phyical dimensions of the synthetic space
domain = [10 5]; %mm, [width, height]
spRes = 0.05;   %mm, higher than electrode resolution
fs = 30; %Hz, sampling frequency

% define a selection of direction and point vectors
dirA = [-1;2];
sourceA = [-7,-7];
speedA = 0.6;

dirB = [-2;1];
sourceB = [3;3];
speedB = 1.3;

%% Computation
% generate synthetic activation time maps using various combinations of
% the direction, source, and speed

radial_A = ATgenerator(sourceA+12, speedA.*dirA./vecnorm(dirA), domain, spRes, 'radial');
% radial_As = ATgenerator(sourceA, speedB.*dirA./vecnorm(dirA), domain, spRes, 'radial');
% radial_B = ATgenerator(sourceB, speedB.*dirB./vecnorm(dirB), domain, spRes, 'radial');

linear_A = ATgenerator(sourceA, speedA.*dirA./vecnorm(dirA), domain, spRes, 'linear');
linear_Afast = ATgenerator(sourceA, 2.8*speedA.*dirA./vecnorm(dirA), domain, spRes, 'linear');

collision_B = ATgenerator(sourceB, -speedA.*dirB./vecnorm(dirB), domain, spRes, 'collision');

% plot the full resolution activation time maps with 2s temporal contours
figure;
tiledlayout('flow')
nexttile;
imagesc(discretize(radial_A, 0:2:60));
nexttile;
imagesc(discretize(radial_B, 0:2:60));
nexttile;
imagesc(discretize(linear_A, 0:2:60));
nexttile;
imagesc(discretize(collision_B, 0:2:60));

set(gca, 'YDir', 'reverse')

% create a set of repeating waves
ms = [];

ms(:, :, end+1) = radial_A;
ms(:, :, end+1) = radial_A;
ms(:, :, end+1) = radial_A;
ms(:, :, end+1) = radial_A;
ms(:, :, end+1) = radial_A;
ms(:, :, end+1) = radial_A;

ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;

ms(:, :, end+1) = linear_Afast;
ms(:, :, end+1) = linear_Afast;
ms(:, :, end+1) = linear_Afast;
ms(:, :, end+1) = linear_Afast;
ms(:, :, end+1) = linear_Afast;
ms(:, :, end+1) = linear_Afast;

ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;
ms(:, :, end+1) = linear_A;

ms(:, :, end+1) = collision_B;
ms(:, :, end+1) = collision_B;
ms(:, :, end+1) = collision_B;
ms(:, :, end+1) = collision_B;
ms(:, :, end+1) = collision_B;
ms(:, :, end+1) = collision_B;

% combine waves into one data set and find length
for i = 2:size(ms, 3)
    ms(:, :, i) = ms(:, :, i);
end
fullTime = max(ms, [], 'all')+30;

% define electrode array size, location, and spacing
[aX, aY] = meshgrid(0:0.95:6.65, 0:0.95:2.85);

trform = [1,0;0,1]; % 2D transform matrix
trn = [2 ;1.5]; %mm translation vector

% transform the electrode array
trfArray = arrayfun(@(x, y) trn+trform*[x;y], aX, aY, 'UniformOutput', 0) ;
arrayF(:, :, 1) = cellfun(@(b) (b(1)), trfArray);
arrayF(:, :, 2) = cellfun(@(b) (b(2)), trfArray);

% get activation times for marker array
toa = cellfun(@transpose, resampleElectrode(ms, domain, spRes, aX, aY,trform, trn, fs), 'UniformOutput', 0);
assert(sum(isnan(cell2mat(toa)))==0, 'Ensure electrode is within simulated area')

% generate phase signals from marker times
phaseSigs = createPhaseSigs(toa, fullTime, 30);
tvec = [1:size(phaseSigs, 2)]/fs;

% trim to end of activity
cutoff = find(isnan(phaseSigs(1, :)), 1);
tvec(cutoff:end) = [];
phaseSigs(:, cutoff:end) = [];

% compute recurrence plot
RP = compute_recurrencePlots(phaseSigs, tvec,1,1:32, 'DownSample', 30);

%% Plotting 1: Recurrence plot with variable threshold
pp = 1;
hh = figure('units', 'centimeters', 'position', [3 3 17 8]);
fontOpt = { 'FontName', 'Times', 'FontSize', 8};

for i = [ 0.22 0.12 0.06] % threshold quantiles
ax = subplot(1, 3, pp);
tt = quantile(RP(:),i);
    imagesc(RP<tt);
    tt
    axis square
    subtitle(sprintf('\\epsilon = %.2f; %.0f^{th} percentile', tt, i*100), 'Interpreter', 'tex')
    colormap(flipud(gray))
    xticks([0:120:size(RP, 1), size(RP, 1)])
    yticks([0:120:size(RP, 1), size(RP, 1)])
    xlabel('Time (s)')
    ylabel('Time (s)')
    cellfun(@(oo) set(oo,fontOpt{:}), {ax.XAxis, ax.YAxis,ax.XLabel, ax.YLabel, ax.Subtitle})

pp = pp+1;
end

saveHQsvg(hh, 'syntheticfigureRP')

%% Plotting 2: Plot selected maps with transformed electrode array overlay

hh2 = figure('units', 'centimeters', 'position', [3 3 15 30]);

subplot(4, 1, 1)
ss = pcolor(padZeros(discretize(radial_A, 0:1:15)));
ss.EdgeColor = 'none';
set(gca, 'YDir', 'reverse')
colormap(jet(16))
caxis([0 16])
pbaspect([2 1 1])
hold on;
scatter(reshape(arrayF(:, :, 1), 1, [])./spRes, reshape(arrayF(:, :, 2), 1, [])./spRes, 5, 'k',  'filled')
axis off

subplot(4, 1, 2)
ss = pcolor(padZeros(discretize(linear_A, 0:1:15)));
ss.EdgeColor = 'none';
set(gca, 'YDir', 'reverse')
colormap(jet(16))
caxis([0 16])
pbaspect([2 1 1])
hold on;
scatter(reshape(arrayF(:, :, 1), 1, [])./spRes, reshape(arrayF(:, :, 2), 1, [])./spRes, 5, 'k',  'filled')
axis off

subplot(4, 1, 3)
ss = pcolor(padZeros(discretize(linear_Afast, 0:1:15)));
ss.EdgeColor = 'none';
set(gca, 'YDir', 'reverse')
colormap(jet(16))
caxis([0 16])
pbaspect([2 1 1])
hold on;
scatter(reshape(arrayF(:, :, 1), 1, [])./spRes, reshape(arrayF(:, :, 2), 1, [])./spRes, 5, 'k',  'filled')
axis off

subplot(4, 1, 4)
ss = pcolor(padZeros(discretize(collision_B, 0:1:15)));
ss.EdgeColor = 'none';
set(gca, 'YDir', 'reverse')
colormap(jet(16))
caxis([0 16])
pbaspect([2 1 1])
hold on;
scatter(reshape(arrayF(:, :, 1), 1, [])./spRes, reshape(arrayF(:, :, 2), 1, [])./spRes, 5, 'k',  'filled')
axis off
% colormap(repmat([1:9]'./9, 1, 3 ))
colorbar('location', 'southoutside','orientation', 'horizontal')
saveHQsvg(hh2, 'syntheticfigure_bar') 

