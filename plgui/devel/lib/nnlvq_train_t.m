function [W1,W2,correct] = nnlvq_train_t(x, tnet, tp, mx, pn)

% NNLVQ_TRAIN Learning vector quantization training.
% ***************************************************************************
% Inputs:
%    X, training feature matrix, each row is an ovservation of a feature 
%       vector.
%    MX, training data size in each class.
%    TNET, Network structure.
%    TP, Training parameters.
% Outputs:
%    Wi - Weight matrix of the ith layer.
% Usage:
%    [W1,W2] = nnlvq_train(x, tnet, tp, mx)
% Defaults:
% Functions:         

% Created:       3/16/95, Xiaoou Tang
% Last modified: 4/16/95, X. Tang
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

[W1,W2] = initlvq_t(x, tnet, T);
%[W1,W2] = initlvq_ts(x, tnet, T);
%[W1,W2] = initlvq_tplot(x, tnet, T);
[W1,W2,correct] = trainlvq_t(W1,W2,x,T,tp,pn); 
%[W1,W2] = trainlvq_tplot(W1,W2,x,T,tp,pn); 


