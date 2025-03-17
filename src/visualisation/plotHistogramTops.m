function plotHistogramTops(inD, edges)
% plotHistogramTops  Plots relative frequency histograms.
% Omkar Athavale, January 2025
%
% INPUTS:
%   inD:    1 x m  numeric array of input data
%   edges:  1 x k numeric array of edges for the histogram bins
%
% OUTPUTS:  none
%
[y, x] = histcounts(inD, edges);
plot(reshape([x(1:end-1);x(2:end)], 1, []), reshape([y./length(inD(~isnan(inD))); y./length(inD(~isnan(inD)))], 1, []))

end

