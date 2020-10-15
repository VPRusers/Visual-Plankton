function fname = n2nthfile(flist, m, n)
% nthfile	return the Nth file in a given list
% Inputs:
%    flist, a file name vector returned from matlab's ls command
%    m, n, start and end index of desired file in list (1 is the first)
% Outputs:
%    fname, the m to nth file name string
% Usage:
%    f = nthfile(ls('*.ras'), 3, 5);
% Created:       11/20/96,   Xiaoou Tang
% ***************************************************************************
p = find(flist == 10);
if m == 1
  first = 1;
else
  first = p(m-1)+1;
end
fname = [flist(first:p(n)-1),10];
