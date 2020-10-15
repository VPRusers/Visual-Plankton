function [eigv_mat,evalue_x] = eig_fast(x)
% EIG_FAST  Fast covariance matrix eigenvalue computation given feature matrix.
% ***************************************************************************
% Inputs:
%    X,  training feature matrix, each row is an ovservation of a feature 
%        vector.
% Outputs:
%    EIGV_MAT, eigen vector matrix.
%    EVALUE_X, eigen value vector.
% Usage:
%    [eigv_mat,evalue_x] = eig_fast(x)
% Defaults:
% Functions:         
%  Notes: 

% Created:       8/25/94, Xiaoou Tang
% Last modified: 2/26/94, X. Tang
%***************************************************************************
 
[mm,nn] = size(x);
mean_val = mean(x);
x = (x - mean_val(ones(mm,1),:))';

[eigv_mat, evalue_x] = eig(x'*x/(mm-1));

evalue_x = diag(evalue_x);
eigv_mat = (x/sqrt(mm-1)) * eigv_mat;
norml = sqrt(abs(evalue_x))';
norml = norml(ones(nn,1), :);
eigv_mat = eigv_mat./(norml+eps);    % normalize eigen vectors

% the resulted eigen vectors have opposite sign as the regular eig(cov(x)) 
% method. Since constant*eigenvector is still eigenvector, so it is ok.

