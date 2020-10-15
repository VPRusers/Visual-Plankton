function [class, neuroncl] =clfier_batch_fast(x, t1, t2, t3, t4, mx, cl_method)

%

%History: 
%   created: 12/27/95	Xiaoou Tang

[xr, xc] = size(x);
class = zeros(xr,1);

if cl_method == 1
   class = clfier_nm_fast(x, t1, t2, t3, t4, mx);
elseif cl_method == 2 | cl_method == 3
   x = x';
   for i = 1:xr
%     class(i) = clfier_nnff(x(:,i), t1, t2, t3, t4);
   end
elseif cl_method == 4
  [class, neuroncl] = clfier_nnlvq_f(x, t1, t2);
else
   disp('not implimented yet')
end




 

