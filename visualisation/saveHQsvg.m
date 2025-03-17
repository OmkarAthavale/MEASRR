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