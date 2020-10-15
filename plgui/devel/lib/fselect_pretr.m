function [y, ax_mat, axind] = ...
                             fselect_pretr(x, groupind, c1, c2)
% group feature selection

% Created:       7/11/95,   Xiaoou Tang

[rx,cx] = size(x);
gnum = length(groupind);
mx = cumsum(groupind);
mx = [0;mx(:)];

axind = zeros(1,gnum);
for i = 1:gnum
  axind(i) = min(c1, floor(groupind(i)/c2)); 
end
ax_mat = zeros(max(groupind), sum(axind));
nx = cumsum(axind);
nx = [0;nx(:)];
y = zeros(rx, sum(axind));

for i = 1:gnum
  xx = x(:, mx(i)+1:mx(i+1));
  [evec_mat, evalue_x] = eigen(xx);
  [sdist, sdist_ind] = sort(evalue_x);
  sdist = flipud(sdist(:));                % largest first
  sdist_ind = flipud(sdist_ind(:));
  sdist_ind = sdist_ind(1:axind(i));      % only use the first FLEN features

  faxis = evec_mat(:, sdist_ind);
  
  y(:,nx(i)+1:nx(i+1)) = xx*faxis;
  
  ax_mat(1:groupind(i),nx(i)+1:nx(i+1)) = faxis;  
end


