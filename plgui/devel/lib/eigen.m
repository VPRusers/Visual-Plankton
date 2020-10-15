function [evec_mat, evalue_x] = eigen(x)
% EIGEN  Fast covariance matrix eigenvalue computation according to data size
% ***************************************************************************
% Inputs:
%    X,  training feature matrix, each row is an ovservation of a feature 
%        vector, and each column is a variable.
% Outputs:
%    EIGV_MAT, eigen vector matrix.
%    EVALUE_X, eigen value vector.
% Usage:
%    [eigv_mat,evalue_x] = eig_fast(x)
% Defaults:
% Functions:         
%    Eig_fast.
%  Notes: 

% Created:       8/29/94, Xiaoou Tang
% Last modified: 2/26/94, X. Tang
%***************************************************************************
 
[lall, wall] = size(x);
if lall > wall                 % more training samples, short feature vec
   cov_mat = cov(x);
   [evec_mat, evalue_x] = eig(cov_mat);
   evalue_x = diag(evalue_x);
else
   [evec_mat, evalue_x] = eig_fast(x);
end