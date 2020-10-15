function y = fselect_prete(x, ax_mat, axind, groupind)

% group feature selection

% Created:       7/12/95,   Xiaoou Tang

gnum = length(groupind);
mx = cumsum(groupind);
mx = [0;mx(:)];

nx = cumsum(axind);
nx = [0;nx(:)];

for i = 1:gnum
  xx = x(:, mx(i)+1:mx(i+1));
  faxis = ax_mat(1:groupind(i),nx(i)+1:nx(i+1));
  y(:,nx(i)+1:nx(i+1)) = xx*faxis;
end

  
 