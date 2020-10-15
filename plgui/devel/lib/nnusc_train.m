function [class, W, b] = nnusc_train(x, cn, tp)

% NNUSC_TRAIN unsupervised classifier self training.
% ***************************************************************************
% Inputs:
%    X, training feature matrix, each row is an ovservation of a feature 
%       vector.
%    CN, class number.
%    TP, Training parameters.
% Outputs:
%    CLASS, class label.
%    W - Weight matrix.
%    b - Bias vector
% Usage:
%    [class, W, b] = nnusc_train(x, cn, tp)
% Defaults:
% Functions:
%    clfier_nnusc         

% Created:       5/11/95, Xiaoou Tang
%***************************************************************************

lim = [min(x)' max(x)'];
W = initc(lim, cn);
[W, b] = trainc(W,x',tp);
class = clfier_nnusc(x, W, b);

%W = trainc(W,x',tp);
%class = clfier_nnusc(x, W)

