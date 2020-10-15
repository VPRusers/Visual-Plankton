function y=ind2vec(x)
%IND2VEC Transform indices into single-value vectors.
%	
%	IND2VEC(X)
%	  X - Row vector of N indices (integers >= 1).
%	Returns a sparse matrix with N columns where each ith column
%	  contains a 1 in the position corresponding to the ith
%	  index.  All other values are 0.
%	
%	EXAMPLE: x = [1 2 3 2 1];
%	         y = ind2vec(x)
%	
%	See also VEC2IND.

% 2/9/96 Xiaoou Tang

M = max(x);
N = length(x);
ind = 1:N;
val = ones(1,N);
y = sparse(x,1:N,ones(1,N),M,N,N);
