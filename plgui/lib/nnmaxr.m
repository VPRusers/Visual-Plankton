function m = nnmaxr(m)
%NNMAXR Find maximum of each row.
%	
%	*WARNING*: This function is undocumented as it may be altered
%	at any time in the future without warning.

% NNMAXR(M)
%   M - Matrix.
% Returns column of maximum row values.
%
% EXAMPLE: M = [1 2 3; 4 5 2]
%          maxrow(M)
%
% SEE ALSO: nnmaxr

[N,M] = size(m);

if M > 1
  m = max(m')';
end
