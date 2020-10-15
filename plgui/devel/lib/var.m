function y = var(x)
%VAR	Variance. 
%	For vectors, VAR(x) returns the sample variance.  
%	For matrices, VAR(X)is a row vector containing the sample
%	variance of each column. The variance is the square of the
%	standard deviation (STD). See also COV.

[m,n] = size(x);

if (m == 1) | (n == 1)
    m = max(m,n);
    y = norm(x - sum(x)/m).^2./(m-1);
elseif m == 1 & n == 1
    y = 0;
else
    avg = mean(x);
    centerx = x - avg(ones(m,1),:);
    y = sum(centerx .* centerx)/(m-1);
end
