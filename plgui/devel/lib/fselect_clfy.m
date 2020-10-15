function [class] = fselect_clfy(fv,cl_method,select_type,faxis)
% FSELECT_CLFY,  feature selection and classification forward pass function 
% 
% Inputs:
%     fv, input feature vector
%     CL_METHOD, classification method
%     SELECT_TYPE, feature selection type
%     FAXIS, feature axis projection matrix for feature selection
%     Classification parameters are presumed globally defined for now.
% Inputs:
%     CLASS, resulting classification

% History:       
%	3/17/95, X. Tang	Created.
%***************************************************************************
te_data = fselect_te(fv, faxis, select_type);

if cl_method == 1
  global W_POS W_INV MEANS DIM NC
  class = clfier_nm(te_data, W_POS, W_INV, MEANS, DIM, NC) ; 
elseif (cl_method == 2 | cl_method == 5),
  global BPW1 BPB1 BPW2 BPB2
  class = clfier_nnff(te_data', BPW1, BPB1, BPW2, BPB2);  
elseif cl_method == 3
  global LVQW1 LVQW2
  class = clfier_nnlvq(te_data', LVQW1, LVQW2);  
elseif cl_method == 4
  global USCClass USCW USCB
  class = clfier_nnusc(te_data, USCW, USCB);  
else
  error(['Unrecognized cl_method = ' num2str(cl_method)]);
end
