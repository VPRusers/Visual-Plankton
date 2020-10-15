function class = clfier_nnff(x, W1, b1, W2, b2) 
% CLFIER_NNFF feed forward network classifier.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (colum vector).
%    Wi - Weight matrix of the ith layer.
%    Bi - Bias (column) vector of the ith layer.
% Outputs:
%    CLASS, class label.
% Usage:
%    class = clfier_nnff(x, W1, b1, W2, b2) 
% Defaults:
% Functions:         

% Created:       2/27/95, Xiaoou Tang
% Last modified: 4/15/95, X. Tang
%***************************************************************************

a = simuff(x,W1,b1,'logsig',W2,b2,'logsig');
% a = simuff(x,W1,b1,'tansig',W2,b2,'purelin');
a = compet(a);
class = find(a == 1);
