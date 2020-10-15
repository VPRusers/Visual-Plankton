function [tr_data, te_data] = split_tetr(all_data, percent, nc)

% extract a percentage of data for training

[nall, dim] = size(all_data);

nall1 = nall/nc;                 % all data size in one class   
ntr1 = round(nall1*percent);     % training data size in one class
nte1 = nall1-ntr1;               % testing data size in one class
tr_data = zeros(ntr1*nc,dim);
te_data = zeros(nte1*nc,dim);

for i = 0:nc-1
   tr_data(i*ntr1+1:(i+1)*ntr1,:) = all_data(i*nall1+1:i*nall1+ntr1,:);
   te_data(i*nte1+1:(i+1)*nte1,:) = all_data((i+1)*nall1-nte1+1:(i+1)*nall1,:);
end
