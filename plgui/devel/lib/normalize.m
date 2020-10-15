function [y, x_mean, x_std]  = normalize(x, x_mean, x_std )

% normalization of feature vector elements

% Created 9/6/95, X. Tang
% ********************************************************

[m,n] = size(x);
if nargin < 3
  x_mean = mean(x);
  x_std = std(x);
end

y = (x - x_mean(ones(m,1),:))./(x_std(ones(m,1),:) + eps);
 