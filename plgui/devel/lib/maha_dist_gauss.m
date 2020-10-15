function d = maha_dist_gauss(x, Wp, W, M, dim, p)
% MAHA_DIST_GAUSS,  Mahalanobis distance for gaussian classifier.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (row vector).
%    Wp, Covariance matrix.
%    W,  Inverse covariance matrix.
%    M,  Mean vector of the class (row vector).
%    DIM, Dimension of covariance matrix.
%    P,  Ckass probability.
% Outputs:
%    D, Gaussian Distance of the input vector X from the input class mean M.
% Usage:
%    d = maha_dist_gauss(x, Wp, W, M, dim, p) ;
% Defaults:
% Functions:         

%  Notes: 
% Created:       5/17/94, Xiaoou Tang
% Last modified: 2/9/96, X. Tang
%***************************************************************************

W = reshape(W, dim, dim);
Wp = reshape(Wp, dim, dim);
d = (x-M)* W *(x-M)'+log(abs(det(Wp)+eps))-2*log(p+eps);