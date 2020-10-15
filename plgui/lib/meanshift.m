function t = meanshift(x, n);

% Compute the binarization threshold
% x, imput image.
% n, number of iteration, default is 2

% Xiaoou Tang, 9/9/95
 
if nargin < 2
  n = 2;
end
x = x(:);
t = mean(x);
for i = 1:n
  m1 = mean(x(x<t));
  m2 = mean(x(x>t));
  t = (m1+m2)/2;
end

