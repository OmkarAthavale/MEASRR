function [RRi,DETi,ENTRi,Li]  = metricsOnSubsetParallel(RP, tVec, stTimeA, dur, arr)
% metricsOnSubsetParallel  This function computes the recurrence quantification metrics for square subsections 
% of the recurrence plot fixed in one dimension and as a rolling window in the other.
% Computation is performed in parallel if possible. 
% Omkar Athavale, December 2024
%
% INPUTS:
%   RP:         m x n matrix with the signal phase in radians for m electrodes
%               with n samples
%   tVec:       a 1 x k array of times in seconds
%   stTimeA:	start time of the fixed dimension in seconds
%   dur:        subsection duration in seconds
%   arr:        starting times in the un-fixed dimension
% OUTPUTS:
%   RRi, DETi, ENTRi, Li: as defined in Recu_RQA
%

% initialise arrays
RRi = nan(size(arr));
DETi = nan(size(arr));
ENTRi = nan(size(arr));
Li = nan(size(arr));

assert(length(unique(reshape(RP(~isnan(RP)), 1, []))) < 3 || islogical(RP), 'Must be logical array or numeric with only 1/0/NaN')

for i = 1:numel(arr)
    [RRi(i),DETi(i),ENTRi(i),Li(i)] = metricsOnSubset(RP, tVec, [stTimeA arr(i)], dur);
end

end