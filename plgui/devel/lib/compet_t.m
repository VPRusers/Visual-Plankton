function a = compet_t(n,b)
%COMPET Competitive transfer function.
%	
%	COMPET(N)
%	  N - SxQ matrix of net input (column) vectors.
%	Returns the output vectors with 1 where each net input
%	  vector had its maximum value, and 0 elsewhere.
%	
%	EXAMPLE: n = [0.0; 0.2; 0.6; 0.1];
%	         a = compet(n)
%	
%	COMPET(Z,B) ...Used when Batching.
%	  Z - SxQ Matrix of weighted input (column) vectors.
%	  B - Sx1 Bias (column) vector.
%	Returns results of applying competition to net input values
%	  found by adding B to each column of Z.
%	
%	COMPET('delta') returns name of delta function.
%	COMPET('init') returns name of initialization function.
%	COMPET('name') returns full name of this transfer function.
%	COMPET('output') returns output range of this function.
%	
%	See also NNTRANS, COMPNET, INITC, SIMC, TRAINC.

%  2/9/96, Xiaoou Tang

[nr,nc] = size(n);
if nargin==2
  n = n + b;
end

[dum, ind] = max(n);
a = sparse(ind, 1:nc, ones(1,nc),nr,nc,nc);


