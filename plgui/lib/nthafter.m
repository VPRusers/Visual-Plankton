function fname = nthafter(flist,n)
% nthfile	return the Nth file in a given list
% Inputs:
%    flist, a file name vector returned from matlab's ls command
%    n, index of desired file in list (1 is the first)
% Outputs:
%    fname, the nth file name string and all the after
% Usage:
%    f = nthfile(ls('*.ras'), 3);
% Created:       6/20/97,   x. tang
% ***************************************************************************
p = find(flist == 10);
if n == 1
  first = 1;
else
  first = p(n-1)+1;
end
fname = flist(first:length(flist));
