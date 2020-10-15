function ids = geneids(mx);

% 12/1/96, X. Tang

mx = mx(:);
m = length(mx);
ids = zeros(sum(mx),1);
smx = [0; cumsum(mx)];

for i = 1:m
  ids(smx(i)+1:smx(i+1)) = ones(mx(i),1)*i;
end

  