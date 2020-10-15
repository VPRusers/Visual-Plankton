function [y] = maxsmooth(x,L)
%MAXSMOOTH Maximum smoothing filter.
%       [y] = MAXSMOOTH(X,L) smooths the input vector X choosing the max.
%       value from a  with a rectangular window of "L" samples.
%
%       See also: SP_STENG, SP_STMAG, SP_STZCR, AVSMOOTH
%

%       LT Dennis W. Brown 7-11-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Modified from MDSMOOTH.m   9/16/1997  CJA and CSD

% default output
y = [];

% check args
if nargin ~= 2,
    error('maxsmooth: Invalid number of input arguments...');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
        error('maxsmooth: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% number of samples
Ns = length(x);

% room for output
y = zeros(Ns,1);

% pad ends to compensate for filter length
x = [zeros(L/2-1,1); x ; zeros ; zeros(L/2,1)];

% pick maximum 
for k=1:Ns
        y(k,1) = max(x(k:k+L-1,1));
end
