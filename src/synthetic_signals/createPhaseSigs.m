function Y_phase = createPhaseSigs(x,tEnd,fs)
% createPhaseSigs  This function generates a sawtooth phase signal based 
% on the activation time markers for an electrode. 
% Omkar Athavale, August 2020
%
% INPUTS:
%   x:      1 x k cell array of arrays of marker indices in the time
%           dimension for k electrodes (GEMS toapp.toaIndx format)
%   tEnd:   the end time of the signal in seconds
%   fs:     sampling frequency of the signal in Hz

% OUTPUTS:
%   Y_phase:    m x n array of phase in radians for m electrodes at n time
%               points.

%initialise 
xlenSig = 1:round(tEnd * fs);
Y_phase = zeros(size(x,2),length(xlenSig)); 

% compute
for i = 1:size(x,2)
    %set to 1 and 0 and interp
    if ~isempty(x{i})   % set rand Values to 0
        x_pos = x{i};   % AT times set to 1
        y_pos = ones(size(x_pos));
        x_pos = [x_pos x_pos+1];
        y_pos = [y_pos y_pos-1];
        [x_pos,ix]=sort(x_pos);
        y_pos = y_pos(ix);
        
        [xx, x_index] = unique(x_pos);
        
        %interp
        Y_phase(i,:) = interp1(x_pos(x_index),y_pos(x_index),xlenSig,'linear'); 
    else 
        Y_phase(i,:) = zeros(size(xlenSig)) * NaN;
    end
    % convenience plotting functions
%     figure, plot(x_pos,y_pos,'*-');hold
%     plot(xlenSig,Y_phase(i,:),'r--')
    clear x_pos y_pos 
end

Y_phase = rescale(Y_phase,-pi,pi);

end

