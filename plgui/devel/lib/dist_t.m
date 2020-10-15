function y = dist_t(w,p)
%DIST Distances between vectors.
%	
%	DIST(W,P)
%	  W - SxR matrix of rows vectors.
%	  P - RxQ matrix of column vectors.
%	Returns SxQ matrix of vectors distances.
%	
%	EXAMPLE: w = [1 2 1];
%	         p = [1; 2.1; 0.9];
%	         n = dist(w,p)

% 1/23/96, Xiaoou Tang

[s,r] = size(w);
[r2,q] = size(p);

if (r ~= r2), error('Matrix sizes do not match.'),end

y = zeros(s,q);

if s > q
  for i=1:q
    pp = p(:,i)';
    x = pp(ones(s,1),:)';
    y(:,i) = sqrt(sum((x-w').^2))';
  end
else
  for i = 1:s
    wi = w(i,:)';
    x = wi(:,ones(1,q));
    y(i,:) = sqrt(sum((x-p).^2));
  end
end

