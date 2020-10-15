function [W_pos,W_inv,means,dim] = cov_mean_extr(tr_data, mx)

% COV_MEAN_EXTR Extract covariance matrix and mean vectors from training data
%               for the Gaussian classifier.
% ***************************************************************************
% Inputs:
%    TR_DATA, training feature matrix, each row is an ovservation of a feature 
%             vector.
%    MX, training data size in each class.
% Outputs:
%    W_pos,  Covariance matrix.
%    W_inv,  Inverse covariance matrix.
%    means,  Mean vector matrix.
%    DIM, Dimension of covariance matrix for reshaping from vector to matrix.
% Usage:
%    [W_pos,W_inv,means,dim] = cov_mean_extr(tr_data, mx)
% Defaults:
% Functions:         

% Created:       8/30/94, Xiaoou Tang
% Last modified: 2/25/95, X. Tang 
%***************************************************************************

mark = 0;   % if W-pos is invertable for all classes data, otherwise mark =1
[numob, dim] = size(tr_data);
if sum(mx) ~= numob,
   error('Input data matrix does not match its class size discription')
end
nc = length(mx);
mx = cumsum(mx);
mx = [0;mx(:)];

means = zeros(nc, dim);
W_pos = zeros(nc, dim*dim);
W_inv = zeros(nc, dim*dim);

for i = 1:nc
   tr_class = tr_data(mx(i)+1:mx(i+1), :);
   means(i,:) = mean(tr_class);
end
for i = 1:nc
   tr_class = tr_data(mx(i)+1:mx(i+1), :);
   Wp = cov(tr_class);                  % covariance matrix of class i
   if  det(Wp)<eps
       disp(['The ', num2str(i), 'th class cov matrix noninvertable, use Euc_D']); 
       mark = 1;                        % flag for noninvertable
       break
   end
   W = inv(Wp);
   W_pos(i,:) = Wp(:)';
   W_inv(i,:) = W(:)';
end
if mark == 1              % if one class cov noninvertable,use eucled distance
   Wp = eye(size(Wp));
   Wp = Wp(:)';
   W_pos = Wp(ones(nc,1),:);
   W_inv = W_pos;
end


