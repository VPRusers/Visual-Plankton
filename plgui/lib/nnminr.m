function m = nnminr(m)
%NNMINR Find minimum of each row.
%	
%	*WARNING*: This function is undocumented as it may be altered
%	at any time in the future without warning.

% NNMINR(M)
%   M - matrix.
% Returns column of minimum row values.
%
% EXAMPLE: M = [1 2 3; 4 5 2]
%          nnminr(M)
%
% SEE ALSO: nnmaxr

[N,M] = size(m);

if M > 1
  m = min(m')';
end
