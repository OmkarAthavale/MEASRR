function toaMap = resampleElectrode(maps, domain, spatialRes, arrayX, arrayY, transform, translate, fs)
% resampleElectrode  Transforms a defined rectangluar electrode array grid
% and samples the activation time at electrode points given set of
% activation time maps
% Omkar Athavale, January 2025
%
% INPUTS:
%   maps:       m x n x p numeric array with the activation time (time units) of p
%               waves at m x n locations
%   domain:     2 x 1 numeric array specifying the [width height] (length units)
%               of the full simulation area
%   spatialRes: scalar specifying the point spacing at which the input activation 
%               time maps are spaced
%   arrayX:     u x v numeric array specifying locations of electrodes in
%               the x axis (distance units, width)
%   arrayY:     u x v numeric array specifying locations of electrodes in the
%               y axis (distance units, height)
%   transform:  2 x 2 numeric array for a linear transformation of the
%               electrode array
%   translate:  2 x 1 numeric array (in distance units) for the translation 
%               of the input electrode array
%   fs:         sampling frequency in Hz

% OUTPUTS:
%   toaMap:     1 x p cell array containing 1 x m*n numeric arrays with the 
%               activation time in each electrode for each wave
%

% transform array
trfArray = arrayfun(@(x, y) translate+transform*[x;y], arrayX, arrayY, 'UniformOutput', 0) ;
[gridX, gridY] = meshgrid(0:spatialRes:domain(1), 0:spatialRes:domain(2));
arrayF(:, :, 1) = cellfun(@(b) (b(1)), trfArray);
arrayF(:, :, 2) = cellfun(@(b) (b(2)), trfArray);

% resample
for i = 1:size(maps, 3)
    toaMap(:, i) = reshape(interp2(gridX, gridY, maps(:, :, i), arrayF(:, :, 1), arrayF(:, :, 2)), [], 1);
end

% restructure variables
toaMap = round(toaMap'.*fs);
toaMap = mat2cell(toaMap, size(toaMap, 1), ones(1, size(toaMap, 2)));
end