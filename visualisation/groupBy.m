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

gr = categorical(dat(:, groupingCols));
seq = unique(gr);

data = arrayfun(@(z) (dat(gr == z, dataCols)), seq, 'UniformOutput', 0);

end