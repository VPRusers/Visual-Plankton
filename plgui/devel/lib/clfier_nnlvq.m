function class = clfier_nnlvq(x, W1, W2) 
% CLFIER_NNLVQ learning vector classifier.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (colum vector).
%    Wi - Weight matrix of the ith layer.
% Outputs:
%    CLASS, class label.
% Usage:
%    class = clfier_nnlvq(x, W1, W2) 
% Defaults:
% Functions:         

% Created:       3/16/95, Xiaoou Tang
% Last modified: 4/15/95, X. Tang
%***************************************************************************

avec = simulvq(x,W1,W2);
class = find(avec==1);