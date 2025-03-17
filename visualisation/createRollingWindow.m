function output = createRollingWindow(vector, n)
% CREATEROLLINGWINDOW returns successive overlapping windows onto a vector
%   OUTPUT = CREATEROLLINGWINDOW(VECTOR, N) takes a numerical vector VECTOR
%   and a positive integer scalar N. The result OUTPUT is an MxN matrix,
%   where M = length(VECTOR)-N+1. The I'th row of OUTPUT contains
%   VECTOR(I:I+N-1).
% David Young, 2015. Retreived from Matlab Central
% https://au.mathworks.com/matlabcentral/answers/171154-create-rolling-window-matrix-from-vector#answer_166697

l = length(vector);
m = l - n + 1;
output = vector(hankel(1:m, m:l));
end
