function mm=minmax2(p,rc)
%minmax2 Ranges of matrix rows or columns
%
%  Syntax
%
%    mm = minmax2(p,rc)
%
%  Description
%
%    minmax2(p,rc) takes two arguments,
%      p = rxc matrix of values
%      rc = 1 for maximum of rows (default) or 2 for maximum of columns.
%      if rc is omitted and p is a column matrix, then mm is based on p'.
%    mm is a N x 2 matrix mm of minimum and maximum values
%    for each row or column of P.  If columns are specified (i.e., rc = 2),
%    the matrix is simply transposed to find the minmax matrix of
%    resulting rows which then is transposed for output as mm.
%
%    (For cell arrays rc is ignored)
%    Alternately, P can be an MxN cell array of matrices.  Each matrix
%    P{i,j} should Ri rows and C columns.  In this case, MINMAX returns
%    an Mx1 cell array where the mth matrix is an Rix2 matrix of the
%    minimum and maximum values of elements for the matrics on the
%    ith row of P.
%
%  Examples
%
%    p = [0 1 2; -1 -2 -0.5]
%    mm = minmax(p)
%
%    p = {[0 1; -1 -2] [2 3 -2; 8 0 2]; [1 -2] [9 7 3]};
%    mm = minmax(p)

% Mark Beale, 11-31-97
% Copyright 1992-2002 The MathWorks, Inc.
% $Revision: 1.11 $
% modified to enable column min max...CSD 24Mar2004
singlecolumnflag=0;
if iscell(p)
    [m,n] = size(p);
    mm = cell(m,1);
    for i=1:m
        mm{i} = minmax([p{i,:}]);
    end
elseif isa(p,'double')
    if nargin==2 & rc==2, p=p';end
    if size(p,2)==1,p=p';singlecolumnflag=1;end
    mm = [min(p,[],2) max(p,[],2)];
    if nargin==2 & rc==2, mm=mm';end
    if singlecolumnflag,mm=mm';end
else
    error('Argument has illegal type.')
end
