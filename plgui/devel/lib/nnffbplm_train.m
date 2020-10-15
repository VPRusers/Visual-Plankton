function [W1,b1,W2,b2,epochs,TR] = nnffbplm_train(x, tnet, tp, mx)
% NNFFBPLM_TRAIN Back propagation training of feed forward network
% ***************************************************************************
% Inputs:
%    X, training feature matrix, each row is an ovservation of a feature 
%       vector.
%    TNET, Network structure.
%    TP, Training parameters.
%    MX, training data size in each class.
% Outputs:
%    Wi - Weight matrix of the ith layer.
%    Bi - Bias (column) vector of the ith layer.
% Usage:
%    [W1,b1,W2,b2,epochs,TR] = nnffbplm_train(x, tnet, tp, mx)
% Defaults:
% Functions:         

% History:       
%	2/9/96, Xiaoou Tang	
%***************************************************************************
[numob, dim] = size(x);
if sum(mx) ~= numob,
   error('Input data matrix does not match its class size discription')
end
cmx = cumsum(mx);
cmx = [0;cmx(:)];
nc = length(mx);

x = x';                   % colum vector as feature vector
T = zeros(nc,numob);
for i = 1:nc
    T(i, cmx(i)+1:cmx(i+1)) = ones(1, mx(i));
end

[W1, b1, W2, b2] = initff(x,tnet,'tansig', T,'purelin');
[W1,b1,W2,b2,epochs,TR] = trainlm(W1,b1,'tansig',W2,b2,'purelin',x,T,tp);



