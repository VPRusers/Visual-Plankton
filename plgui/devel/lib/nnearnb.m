function class = nn(t,T,C,n,nc)

% function class = nn(t,T,C) classifies a sample vector t using the
% nearest-neighbor rule.  The columns of matrix T contain the
% training vectors, and the elements of row vector C indicate the
% class of each of the training vectors. (The #columns of T must
% equal #columns of C).  The class identifiers can be one-character
% text strings if desired. The result is the class identifier of the
% training vector which has the smallest Euclidean distance to the
% test vector t.
% N: n nearrest neighbor classifier
% NC: class number

% created 7/23/95  Xiaoou Tang


[m,n] = size(T);
diff = t*ones(1,n)-T;
%d = sqrt(diag(diff'*diff));
d = sqrt(sum(diff.*diff));
if n == 1
   [y,i] = min(d);
   class = C(i);
elseif n < 11              % use min operation
  ind = zeros(1,n);
  for i = 1:n
    [y, ind(i)] = min(d);
    d(ind(i)) = inf;
  end
  a = zeros(1,nc);
  C = C(ind);
  for k = 1:nc
    a(k) = sum(C == k);
  end
  [dum,class] = max(a);
else                     % use sort
  [y,ind] = sort(d);     % in increasing order
  ind = fliplr(ind);
  C = C(ind(1:n));
  for k = 1:nc
    a(k) = sum(C == k);
  end
  [dum,class] = max(a);
end
