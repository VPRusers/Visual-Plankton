function d = maha_dist(x, W, M, dim)
% MAHA_DIST,  Mahalanobis distance.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (row vector).
%    W,  Inverse covariance matrix.
%    M,  Mean vector of the class (row vector).
%    DIM, Dimension of covariance matrix.
% Outputs:
%    D, Mahalanobis distance of the input vector X from the input class mean M.
% Usage:
%    d = maha_dist(x, W, M, dim) ;
% Defaults:
% Functions:         

%  Notes: 
% Created:       5/17/94, Xiaoou Tang
% Last modified: 2/27/95, X. Tang
%***************************************************************************

W = reshape(W, dim, dim);
d = sqrt((x-M)'* W *(x-M));