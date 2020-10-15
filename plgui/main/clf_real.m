function [aids, neuron] = clf_real(te_feature_all, faxis_max, select_type, ...
	t1, t2, t3, t4, cl_method, x_mean, x_std, groupind, ax_mat, axind,...
	x_mean2, x_std2)

% Main function for classification

% 11/13/96 X. Tang

if exist('groupind')
  disp(['  testing group KLT selection']);      
  te_feature_all = fselect_prete(te_feature_all, ax_mat, axind, groupind);
  if exist('x_mean2')
    disp(['second testing feature normalization']);
    te_feature_all = normalize(te_feature_all, x_mean2, x_std2);
  end
end
te_feature = fselect_te(te_feature_all(1:233), faxis_max, select_type);

% Classification
temx = 1;  % ***
[aids, neuron] = ...
		clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);



