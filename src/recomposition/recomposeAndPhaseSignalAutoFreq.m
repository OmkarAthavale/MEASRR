function [sigPhase, newSigValues, timer] = recomposeAndPhaseSignalAutoFreq(sigSegment,fs)
% recomposeAndPhaseSignalAutoFreq  This function recomposes the recording signal using a sinusoidal
% recomposition method. The frequency of the sinusoidal wavelets used to
% recompose the signal is set automatically to the frequency of the highest
% signal power component of the signal for each channel. See the readme file for
% citation details.
% Nira Paskaranadavadivel, 2019
% Omkar Athavale, November 2020
%
% INPUTS:
%   sigSegment:     m x n matrix with the signal amplitude for m electrodes
%                   with n samples
%   fs:             sampling frequency of the signal in Hz
% OUTPUTS:
%   sigPhase:       m x n matrix with the phase of the recomposed signal for m electrodes
%                   with n samples. Phase is measured in radians.
%   newSigValues:   m x n matrix with the amplitude of the recomposed signal for m electrodes
%                   with n samples.
%   timer:          time in seconds taken to compute the recomposed signal
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

%remove mean
sigSegment1 = sigSegment - repmat(mean(sigSegment,2),1,size(sigSegment,2));

% compute recompostion wavelet frequency
L = size(sigSegment1,2);
windowMult = tukeywin(L,1); % with 1 it is a hanning window
windowMult = repmat(windowMult',size(sigSegment1,1),1);
sigSegment1 = sigSegment1.*windowMult;

n = 2^(nextpow2(L));
Y = fft(sigSegment1',n);
f = fs*(0:(n/2))/n;
P = abs(Y/n);P=P';  %plot(f,P(10,1:n/2+1))
P1 = P(:,1:n/2+1);

[~,ii] = max(P1'); % max per channel
freqAll = f(ii);

% find non-zero frequency with greatest power
zeroFreqs = find(freqAll < 0.015);

for k = 1:length(zeroFreqs)
    [~,ii] = sort(P1(zeroFreqs(k), :));
    freqAll(zeroFreqs(k)) = f(ii(end-1));
end

zeroFreqs = find(freqAll < 0.015);

% calculate frequency of all channels
t1=tic;
newSigValues = nan(size(sigSegment));
for i = 1:size(sigSegment,1)
    if ismember(i, zeroFreqs)
        newSigValues(i, :) = nan;
    else
        % fprintf('Recomp signal %d\n',i)
        freqToRecomp = freqAll(i);
        
        T = 1/freqToRecomp ;
        tt = 0:1/fs:T+1/fs ; % time step for one time period
        sine_wavelet = sin(2 * pi * freqToRecomp * tt);
        
        centerVal = round(length(sine_wavelet)/2);
        if rem(length(sine_wavelet),2) ~=1
            % if even sine wave
            sine_wavelet(end-1)=[];
            centerVal = round(length(sine_wavelet)/2);
        end
        
        % weighting computation
        gradSig = gradient(sigSegment(i,:));
        gradSigPos = gradSig>0;
        gradSig(gradSig>0)=0;
        gradSig = exp(rescale(gradSig.*-1, 0, 5));
        gradSig(gradSigPos) = 0;
        
        % initialise recomposed signal
        recompSig = ones(size(sigSegment,2)+length(sine_wavelet),size(sigSegment,2)+length(sine_wavelet)).*NaN;
        
        % compute recomposed signal
        for j = centerVal:size(recompSig,2)-centerVal
            recompSig(j,j-centerVal+1:j+centerVal-1) =  sine_wavelet * gradSig(j-centerVal+1);
        end
        newSigValues(i,:) = nanmean(recompSig(:,centerVal:end-centerVal));
    end
end
timer = toc(t1);

% Compute phase signals
for j = 1:size(newSigValues,1)
    hA(j,:) = hilbert(newSigValues(j,:));
    sigPhase(j,:) = atan2(real(hA(j,:)), -imag(hA(j,:)));
end

end