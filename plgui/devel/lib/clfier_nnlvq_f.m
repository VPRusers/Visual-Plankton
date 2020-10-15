function [class, neuroncl] = clfier_nnlvq_f(x, W1, W2) 
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
% Functions:  simulvq_t         

% Created:       3/16/95, Xiaoou Tang
% Last modified: 4/15/95, X. Tang
%***************************************************************************

[a1, a2] = simulvq_t(x',W1,W2);
[class, col_dum] = find(a2);		% a2 is in final class
[neuroncl, col_dum] = find(a1);		% a1 is in hidden class
