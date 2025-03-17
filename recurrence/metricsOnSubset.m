function [RR,DET,ENTR,L,ratioMeas] = metricsOnSubset(RP, tVec, stTime, dur)
% metricsOnSubset  This function computes the recurrence quantification metrics for a square subsection
% of a recurrence plot.
% Omkar Athavale, December 2024
%
% INPUTS:
%   RP:         m x n matrix with the signal phase in radians for m electrodes
%               with n samples
%   tVec:       1 x k array of times in seconds
%   stTime:     1 x 2 numeric array for the start time (in seconds) of the
%               square subsection in both dimensions of the recurrence plot
%   dur:        subsection duration in seconds
% OUTPUTS:
%   RR, DET, ENTR, L, ratioMeas: as defined in Recu_RQA
%

selA = tVec <= stTime(1)+dur & tVec >= stTime(1);
selB = tVec <= stTime(2)+dur & tVec >= stTime(2);

if (sum(selA) - sum(selB)~= 0) && (abs(sum(selA) - sum(selB)) < 10)
    diffInd = sum(selA) - sum(selB);
    selC = zeros(size(selB));
    selC(find(selB, 1, 'first'):find(selB, 1, 'last')+diffInd) = 1;
    selB = selC(1:length(selB));
end

if sum(selA) == sum(selB)
    [RR,DET,ENTR,L,ratioMeas] = Recu_RQA(RP(selA, logical(selB)),0);
else
    RR = NaN; DET = NaN; ENTR = NaN; L = NaN; ratioMeas = NaN;
end


end