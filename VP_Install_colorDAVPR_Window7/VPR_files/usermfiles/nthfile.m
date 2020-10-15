function fname = nthfile(flist,n)
% nthfile	return the Nth file in a given list
% Inputs:
%    flist, a file name vector returned from matlab's ls command
%    n, index of desired file in list (1 is the first)
% Outputs:
%    fname, the nth file name string
% Usage:
%    f = nthfile(ls('*.ras'), 3);
% Created:       4/20/95,   marra
% ***************************************************************************
p = find(flist == 10);
if n == 1
  first = 1;
else
  first = p(n-1)+1;
end
fname = flist(first:p(n)-1);
