function [tr,te,tr_mx,te_mx] = split(all, percent, mx)
% extract training data from testing data

% 4/18/96, X. Tang

if min(size(all)) == 1
   all = all(:);
end
nc = length(mx);
tr_mx = round(mx*percent);
tr_mx(6) = round(mx(6)*percent);

te_mx = mx - tr_mx;

smx = cumsum(mx)
smx = [0;smx(:)];
str_mx = cumsum(tr_mx)
str_mx = [0;str_mx(:)];
ste_mx = cumsum(te_mx)
ste_mx = [0;ste_mx(:)];

for i = 1:nc
  tr(str_mx(i)+1:str_mx(i+1),:) = all(smx(i)+1 : smx(i)+tr_mx(i), :);
  te(ste_mx(i)+1:ste_mx(i+1),:) = all(smx(i)+tr_mx(i)+1 : smx(i+1), :);  
end
   
