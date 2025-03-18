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
% Copyright (C) 2025 Omkar Athavale
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see https://www.gnu.org/licenses/.
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