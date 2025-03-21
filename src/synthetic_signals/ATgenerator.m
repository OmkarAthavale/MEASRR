function ATmap = ATgenerator(source, velocity, domain, spatialRes, style)
% ATgenerator  Computes activation times (ATs) for selected propagation modes (styles)
% Omkar Athavale, January 2025
% INPUTS:
%   source:     1 x 2 numeric array of specifying the source coordinates (length units).
%               This a point at which the linear or radial modes have time 0 s. 
%   velocity:   1 x 2 numeric array specifying propagation velocity 
%               (length/time units). For radial modes only the magnitude 
%               is relevant. 
%   domain:     2 x 1 numeric array specifying the [width height] (length units)
%               of the electrode array.
%   spatialRes: scalar specifying the point spacing at which to sample ATs
%               (distance units)
%   style:      string specifying the mode to generate out of "radial",
%               "linear", "collision"
% OUTPUTS:
%   ATmap:      2D array containing the ATs (time units). Returns an empty
%               array if an invalid style is selected
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

% functions for each mode
ATfuncRadial = @(xq, yq) vecnorm([xq;yq]-source)./vecnorm(velocity);
ATfuncLinear = @(xq, yq) (vecnorm(cross(([xq;yq; 0]-[source;0]),[-velocity(2)./velocity(1); 1; 0]))./vecnorm([-velocity(2)./velocity(1); 1]))./vecnorm(velocity);
ATfuncCollision = @(map) (max(map(:))-map);

% define electrode grid at which to caluclate activation times
[gridX, gridY] = meshgrid(0:spatialRes:domain(1), 0:spatialRes:domain(2));

if strcmp(style, 'radial')
    ATmap = arrayfun(ATfuncRadial, gridX, gridY);
    
elseif strcmp(style, 'linear')
    ATmap = arrayfun(ATfuncLinear, gridX, gridY);
    
elseif strcmp(style, 'collision')
    ATmap = ATfuncCollision(arrayfun(ATfuncLinear, gridX, gridY));
    
else
    ATmap = [];
end


end