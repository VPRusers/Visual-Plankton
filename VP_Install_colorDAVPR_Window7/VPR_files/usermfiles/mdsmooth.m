function [y] = mdsmooth(x,L)
%MDSMOOTH Median smoothing filter.
%       [y] = MDSMOOTH(X,L) smooths the input vector X using a
%       median filter with a rectangular window of "L" samples.
%
%       See also: SP_STENG, SP_STMAG, SP_STZCR, AVSMOOTH
%
%       MDSMOOTH is implemented as a mex function on some
%       installations.

%       LT Dennis W. Brown 7-11-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


% default output
y = [];

% check args
if nargin ~= 2,
    error('mdsmooth: Invalid number of input arguments...');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
        error('mdsmooth: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% number of samples
Ns = length(x);

% room for output
y = zeros(Ns,1);

% pad ends to compensate for filter length
x = [zeros(L/2-1,1); x ; zeros ; zeros(L/2,1)];

% median filter
for k=1:Ns
        y(k,1) = median(x(k:k+L-1,1));
end
