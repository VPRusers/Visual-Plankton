function [mship, neibcl, d] = member(w1, p, mx, len);

% 12/15/96, Created by Xiaoou Tang

dns = dist_t(w1, p');		% each col is dist of sample(col) to all neuron
dns = dns';			% eacn col is dist of neuron(col) to all sample
maxv = max(dns);		% for remove previous mins

[r,c] = size(dns);		% r, # samples, c, # of neurons 
clnum = length(mx);		% number of classes
d = zeros(len, c);
ind = zeros(len, c);
neib = zeros(len, c);
mship = zeros(clnum, c);

cl = geneids(mx);
cl = cl(:, ones(1,c));
for i = 1:len
  [d(i,:), ind(i,:)] = min(dns);
  indm= sparse(ind(i,:), [1:c], ones(c,1), r,c);
  neibcl(i,:) = cl(find(indm))';  
  dns(find(indm)) = maxv;
end

for i = 1:clnum
  mship(i,:) = sum(neibcl==i);
end
mship = mship/len;



