function y=vec2ind_t(x)
%VEC2IND Transform single-value vectors into indices.
%	
%	VEC2IND(X)
%	  X - Matrix with at least one non-zero element per column.
%	Returns row vector of non-zero element row indices of
%	  the first largest non-zero element in each column.
%	
%	EXAMPLE: x = [1 0 0; 1 0 1; 1 1 0];
%	         y = vec2ind(x)= [1 3 2]
%	
%	See also IND2VEC.

% 2/9/96 Xiaoou Tang

[dum, y] = max(x);
