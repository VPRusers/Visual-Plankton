function [y, thresh] = quickquan(x, bin_num, thresh);

[ir,jc,s] = find(x);
[m,n] = size(x);
if nargin == 3
  s = quantiz(s, bin_num, thresh);
elseif nargin == 2
  s = quantiz(s, bin_num);
else
  error('wrong input argument number')
end
y = sparse(ir,jc,s,m,n);

%th = 256/bin_num;
%dum = ones(size(s));
%for i = 1:bin_num
%   i
%  s(find(s >= (i-1)*th+1 & s<=i*th)) = i*dum(find(s >= (i-1)*th+1 & s<=i*th));
%end




 