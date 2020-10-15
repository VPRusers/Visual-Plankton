function [w1,w2] = initlvq(p,s1,t)
%INITLVQ Inititialize LVQ network.
%	
%	[W1,W2] = INITLVQ(P,S1,T)
%	  P  - RxQ matrix of input vectors.
%	  S1 - Size of the competitive hidden layer.
%	  T  - S2xQ matrix of target vectors.
%	Returns:
%	  W1 - S1xR weight matrix for competitive layer.
%	  W2 - S2xS1 weight matrix for linear layer.
%	
%	IMPORTANT: Each ith row of P must contain expected
%	  min and max values for the ith input.
%	
%	EXAMPLE: P = [-1 2 3 2 -2 1 0; 2 -1 1 -3 1 -2 2];
%	         T = [0 0 0 1 1 1 1; 1 1 1 0 0 0 0];
%	         [W1,W2] = initlvq(P,7,T)
%	         p = [1; -1];
%	         a = simulvq(p,W1,W2)
%	
%	See also NNINIT, LVQ, SIMULVQ, TRAINLVQ.

% 12/30/95, Xiaoou Tang

if nargin < 3,error('Not enough input arguments'),end

[r,q] = size(p);
if (q < 2), error('First argument has less than 2 columns.'),end
[s2,q] = size(t);

% CLASSES -> TARGETS
if (s2 == 1)
  t = ind2vec_t(t);
  [s2,q] = size(t);
end

% LAYER 1
mx = full(sum(t'))
[covs, dum2,means,dim] = cov_mean_extr(p',mx);

% LAYER 2
perc = mx'/q;                  % q is the number of smples, perc is PDF
ind = round(cumsum(perc)*s1);  % s1 is the number of hidden neurons

start_ind = 1;
class_ind = zeros(1,s1);
for i=1:s2
  stop_ind = ind(i);
  class_ind(start_ind:stop_ind) = i*ones(1,stop_ind-start_ind+1);
  meani = means(i,:);
  covi = covs(i,:);
  covi = diag(reshape(covi,dim,dim))';
  r_num = stop_ind - start_ind +1;
  w1(start_ind:stop_ind, :) = meani(ones(r_num,1),:) + ...
                             randn(r_num, dim).*sqrt(covi(ones(r_num,1),:)/10);
    start_ind = stop_ind+1;
end
w2 = ind2vec_t(class_ind);
