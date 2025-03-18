function saveHQsvg(h, name, noPainters)
% saveHQsvg  Saves a figure window as an svg file
% Omkar Athavale, 2021
%
% INPUTS:
%   h:          figure handle
%   name:       file save path and name
%   noPainters: logical true if svg objects are generated, false if using
%               painters. Default false. 
% OUTPUTS: none
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

if nargin < 3
    noPainters = false
end

origColor = get(h, 'color');
origHardCopy = get(h,'InvertHardcopy');
origPaperPositionMode = get(h, 'PaperPositionMode');
origRenderer = get(h, 'Renderer');

set(h, 'color', 'white')
set(h, 'InvertHardcopy', 'off')
set(h, 'PaperPositionMode', 'auto')
if ~noPainters
    set(h, 'Renderer', 'painter')
end
saveas(h, name, 'svg')


set(h, 'color', origColor);
set(h,'InvertHardcopy', origHardCopy);
set(h, 'PaperPositionMode', origPaperPositionMode);
set(h, 'Renderer', origRenderer);
end