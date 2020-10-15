function [tr_data,te_data] = split_tetrblend(all_data, nc)

% extract a percentage of data for training

[nall, dim] = size(all_data);

nall = nall/nc;                 % all data size in one class
n = sqrt(nall);
tr = zeros(n);
tr(:,3:4:n) = tr(:,3:4:n)+1;
tr = tr(:);
te = ~tr;

ntr = sum(tr);     % training data size in one class
nte = nall-ntr;               % testing data size in one class
tr_data = zeros(ntr*nc,dim);
te_data = zeros(nte*nc,dim);

for i = 0:nc-1
   oneclass = all_data(i*nall+1:(i+1)*nall,:);
   tr_data(i*ntr+1:(i+1)*ntr,:) = oneclass(tr,:);
   te_data(i*nte+1:(i+1)*nte,:) = oneclass(te,:);
end
