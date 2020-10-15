function [tr_feature_max,faxis_max, ax_mat, axind, x_mean2, x_std2] = ...
   selectfea(tr_feature_all, mx, flen, select_type, groupind, c1, c2)

%11/13/96, Created by Xiaoou Tang

%size(tr_feature_all)

NO_SELECT = 0;
if NO_SELECT 
   disp('skip feature selection step')                    
   tr_feature_max = tr_feature_all; faxis_max = [];
else
   disp('feature selection:');
   disp(['  select_type is: ',num2str(select_type)])
   if exist('groupind')
     disp('  group KLT selection:')
     [tr_feature_all,ax_mat,axind] =...
			fselect_pretr(tr_feature_all,groupind,c1,c2);
     x_mean2=[]; x_std2=[];
     if nargout == 6
       disp(['second training feature normalization']); 
       [tr_feature_all, x_mean2, x_std2] = normalize(tr_feature_all);
     end
   end
   [tr_feature_max,faxis_max,dist,dist_ind,evec_mat,evalue_x] =...
                   fselect_tr(tr_feature_all,mx,flen,select_type);
end

%scatter(tr_feature_max, inthist(CLASSIDS), 8);
