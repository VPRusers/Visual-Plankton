function nclass = clmapping(oclass, map)

% CLCOMBINE mapping classes into new classes.
% ***************************************************************************
% Inputs:
%    OCLASS old class label
%    MAP mapping matrix with two rows. First row is the old class labels.
%        Second row is the corresponding new class labels.
% Outputs:
%    NCLASS, new class label.
% Usage:
%    nclass = clmapping(oclass, map)
% Defaults:
% Functions:

% Created:       5/11/95, Xiaoou Tang
%***************************************************************************
oclnum = size(map,2);
nclass = oclass;

for i = 1:oclnum
   ind = find(oclass == map(1,i));
   nclass(ind) = map(2,i)+zeros(size(ind));
%   nclass(ind) = map(2,i)*ones(size(ind));
end
 
    