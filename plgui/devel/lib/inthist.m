function [no, xo] = inthist(y)

% INTHIST returns sparse histogam of integral values within a vector.
% Inputs:
%    Y, input integral array
% Outputs:
%    no,  	number of each integer found in input vector
%    xo,  	the value of each integer found in input vector
% Defaults:
%    If no MX as input, assume equal data size of all classes.
% Usage:
%    [n,x] = inthist(y)

% 
% Created:       5/02/95, M. Marra
% Modified       9/20/95, X. Tang,  extended to matrix input.
%***************************************************************************

no = []; xo = [];
maxy = max(y);
if y ~= fix(y),
  error('input vector contains non-integral elements');
end
for i=1:maxy,
%  count = size(find(y==i),1);
   count = sum(sum(y==i));
  if count,
    no = [no count];
    xo = [xo i]; 
  end;
end
