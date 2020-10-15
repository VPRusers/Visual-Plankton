function [W1,b1,W2,b2,epochs,TR] = nnffbpx_train(x, tnet, tp, mx)

% NNFFBPX_TRAIN Back propagation training of feed forward network
% ***************************************************************************
% Inputs:
%    X, training feature matrix, each row is an ovservation of a feature 
%       vector.
%    CN, class number.
%    MX, training data size in each class.
%    TNET, Network structure.
%    TP, Training parameters.
% Outputs:
%    Wi - Weight matrix of the ith layer.
%    Bi - Bias (column) vector of the ith layer.
% Usage:
%    [W1,b1,W2,b2,epochs,TR] = nnffbpx_train(x, tnet, tp, mx)
% Defaults:
% Functions:         

% Created:       2/27/95, Xiaoou Tang
% Last modified: 2/28/95, X.Tang
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

%[W1, b1, W2, b2] = initff(x,tnet,'logsig',T,'logsig');

%[W1,b1,W2,b2,epochs,TR] = trainbpx(W1,b1,'logsig',W2,b2,'logsig',x,T,tp);

[W1, b1, W2, b2] = initff(x,tnet,'tansig', T,'purelin');
[W1,b1,W2,b2,epochs,TR] = trainbpx(W1,b1,'tansig',W2,b2,'purelin',x,T,tp);


