function b_dis = batta_4_select(x, mx)

% BATTA_4_SELECT   Bhattacharyya distance given training feature matrix.
% ***************************************************************************
% Inputs:
%    X,  training feature matrix, each row is an ovservation of a feature 
%        vector.
%    MX, training data size in each class.
% Outputs:
%    B_DIS, Distance vector, each element is the distance of a feature. 
% Usage:
%    b_dis = batta_4_select(x, mx);
% Defaults:
% Functions: 
%    Batta, Var.        

% Created:       8/30/94, Xiaoou Tang
% Last modified: 2/9/96, X. Tang 
%***************************************************************************

[mall, nall] = size(x);
if sum(mx) ~= mall,
   error('Input data matrix does not match its class size discription')
end
mx = mx(mx~=0);
nc = length(mx);
p = mx/sum(mx);
if nc<2|sum(mx)<nc*3
  disp(['from batta_4_select nc = ', num2str(nc), ' mx = ', num2str(mx)]);
  disp('left over training data too sparse')
end
mx = cumsum(mx);
mx = [0;mx(:)];

var_mat = zeros(nc, nall);
mean_mat = zeros(nc, nall);
for i = 1:nc
   xclass = x(mx(i)+1:mx(i+1), :);
   if min(size(xclass)) == 1
      var_mat(i,:) = zeros(size(xclass));
      mean_mat(i,:) = xclass;
   else   
      var_mat(i,:) = var(xclass);
      mean_mat(i,:) = mean(xclass);
   end 
end
var_mat(var_mat==0) = var_mat(var_mat==0)+eps;
b_dis = batta(var_mat, mean_mat, p);








