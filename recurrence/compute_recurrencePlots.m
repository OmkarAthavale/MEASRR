function [apd, yPhaseResample, tVecResample] = compute_recurrencePlots(yPhase,tVec,fs,elecArray, opt)
% compute_recurrencePlots  This function computes the recurrence plot distance metric using the phase of a signal.
% Nira Paskaranadavadivel, 2019
% Omkar Athavale, November 2020
%
% INPUTS:
%   yPhase:         m x n matrix with the signal phase in radians for m electrodes
%                   with n samples
%   tVec:           a 1 x k array of times in seconds using in order for
%                   the recording length
%   fs:             sampling frequency of the signal in Hz
%   elecArray:      an m x n matrix containing the electrode numbers in the
%                   arrangement of the electrode which is in an m x n grid
%   'Downsample':   downsampling factor. default 5.
% OUTPUTS:
%   apd:            an n x n distance matrix containing the average phase
%                   difference
%   yPhaseResample: m x (n/'Downsample') numeric array with the downsampled signal
%   yPhaseResample: 1 x (n/'Downsample') numeric array with the downsampled
%                   time vector

arguments
    yPhase
    tVec
    fs
    elecArray
    opt.Downsample = 5;
end
%% Resample phase signals

yPhaseResample = downsample(yPhase',opt.Downsample)';
tVecResample = downsample(tVec,opt.Downsample);

% define electrode array of not defined
if nargin < 4
    elecArray = 1:size(yPhaseResample,1);
end

%% Generate phase maps 
getMap = @(A,elecArray) A(elecArray);

%store maps
aTime=tic;
for i = 1:size(yPhaseResample,2) % loop through all time and store AT map
    mapsAllTime{i}=getMap(yPhaseResample(:,i),elecArray);
end

%% compute average phase difference
apd=zeros(length(mapsAllTime),length(mapsAllTime));
for i = 1:size(yPhaseResample,2)
    for j = i:size(yPhaseResample,2)
        apd(i,j)= median(abs(mapsAllTime{i}(:) - mapsAllTime{j}(:)), 'omitnan');
    end    
end

apd = (apd+apd') - eye(size(apd,1)).*diag(apd);
apd(isnan(apd))=0; %%% need to check what this means
aTimeFin=toc(aTime);
fprintf('Recurrence plot calculated in %3.5f s\n',aTimeFin)

end