function data = groupBy(dat, groupingCols, dataCols)
% groupBy  Selects and groups a matrix rows into cell arrays
% Omkar Athavale, 2021
%
% INPUTS:
%   dat:            m x n numeric array with data in rows
%   groupingCols:   1 x k numeric array of column numbers whose values define N groups
%   dataCols:       1 x j numeric array column numbers whose values are to be retained
%
% OUTPUTS:                                                                                                                                            
%   data:           1 x N cell array containing m x j numeric arrays
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

gr = categorical(dat(:, groupingCols));
seq = unique(gr);

data = arrayfun(@(z) (dat(gr == z, dataCols)), seq, 'UniformOutput', 0);

end