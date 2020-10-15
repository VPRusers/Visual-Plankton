function [t1, t2, t3, t4] = training_t(cl_method, tr_feature, tnet, tp, mx, pn)

% classifier training

% created, 12/27/95, Xiaoou Tang

%keyboard

if cl_method == 1
  [t1, t2, t3, t4] = cov_mean_extr(tr_feature, mx); 
                     % [W_pos,W_inv,means,dim]
elseif cl_method == 2
  [t1, t2, t3, t4, epochs, TR] = nnffbpx_train(tr_feature, tnet, tp, mx);
                     % [W1, b1, W2, b2, epochs, TR]
elseif cl_method == 3
  [t1, t2, t3, t4, epochs, TR] = nnffbplm_train(tr_feature, tnet, tp, mx);
                     % [W1, b1, W2, b2, epochs, TR]
elseif cl_method == 4
  [t1, t2, t3] = nnlvq_train_t(tr_feature, tnet, tp, mx, pn); t4 = [];
else
  error('Wrong classifier switch');
end