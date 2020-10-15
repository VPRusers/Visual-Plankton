function [y ,thresh] = quantiz(x , bin_num, thresh)
% equal probability quantizing

if nargin == 2
  [m,n] = size(x);
  maxx = ceil(max(max(x)));             % gray level range
  minx = floor(min(min(x)));
  total = m*n;                         % total number of pixels
  bin_size = total/bin_num;            % quantization bin size in pixls
  acu_hist = zeros(1, maxx - minx +1); % accumulative histogram

  for i = minx:maxx
    j = i-minx +1;
    acu_hist(j) = sum(sum(x<i));       % use each integal as bin edge
  end

  for i = 1:bin_num                    % find quantization threshhold
    thresh (i) = minx + sum(acu_hist <= i*bin_size)-1;   
  end
end

  y = zeros(size(x));
  for i = 2:bin_num 
  y(x <= thresh(i) & x > thresh(i-1)) = i*ones(size(y(x <= thresh(i) ...
                                        & x > thresh(i-1))));
  end
  y(x <= thresh(1)) = ones(size(y(x <= thresh(1))));







