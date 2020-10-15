function y = fselect_te(x, faxis, type)
% FSELECT_TE Feature selection for testing data.
% ***************************************************************************
% Inputs:
%    X,    feature vector matrix, each row is an feature vector observation.
%    FAXIS selected feature axis by fselect_tr.m
%    TYPE, feature selection method switch, 1 = Bhattacharyya, 2 = KLT, 
%          3 = Bha. + KLT, 4 = KLT + Bha.
% Outputs:
%    Y,    selected feature vector matix, with FLEN colums and same rows as X.
% Usage:
%    y = fselect_te(x, faxis, type);
% Defaults:
% Functions:         

% Created:       2/24/95,   Xiaoou Tang
% Last modified: 3/27/95,   X. Tang 
% ***************************************************************************

if type == 1
   y = x(:, faxis);
elseif type == 2 | type == 3 | type == 4
   y = x*faxis;
else
   error('Wrong feature selection type');
end

