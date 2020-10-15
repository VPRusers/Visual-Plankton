function class = clfier_nnusc(x, W, b)
% CLFIER_NNUSC neural net unsupervised classifier.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (row vector).
%    W - Weight matrix.
% Outputs:
%    CLASS, class label.
% Usage:
%    class = clfier_nnusc(x, W) 
% Defaults:
% Functions:         

% Created:       5/11/95, Xiaoou Tang
%***************************************************************************

class = simuc(x', W, b);
class = vec2ind(class)


