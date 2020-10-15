function class = clfier_nm(x, W_pos, W_inv, means, dim, mx)

% CLFIER Gaussian minimum error classifier.
% ***************************************************************************
% Inputs:
%    X,  Input feature vector (row vector).
%    W_pos, Covariance matrix stack.
%    W_inv, Inverse covariance matrix stack..
%    MEANS,  Mean vector stack of the classes. Row vector.
%    DIM, Dimension of covariance matrix.
%    MX, sample number in each class.
% Outputs:
%    CLASS, classified class label.
% Usage:
%    class = clfier_nm(x, W_pos, W_inv, means, dim, mx)
% Defaults:
% Functions:
%    maha_dist_gauss.        

%  Notes: 
% Created:       5/17/94, Xiaoou Tang
% Last modified: 2/27/95, X. Tang
%***************************************************************************

nc = length(mx);
d = zeros(1,nc);
p = mx/sum(mx);
for c = 1:nc
   d(c) = maha_dist_gauss(x, W_pos(c,:), W_inv(c,:), means(c,:), dim, p(c));
end
[dum, ind] = min(d);           % if equal, the first min index is used
class = ind;
