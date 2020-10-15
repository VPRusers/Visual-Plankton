function [w1,w2, correct] = trainlvq_t(w1,w2,p,t,tp,pn)
%TRAINLVQ Train LVQ network.
%	
%	[W1,W2] = TRAINLVQ(W1,W2,P,T,TP)
%	  W1 - S1xR weight matrix for competitive layer.
%	  B1 - S1x1 bias vector for competitive layer.
%	  W2 - S2xS1 weight matrix for linear layer.
%	  P  - RxQ matrix of input vectors.
%	  T  - S2xQ matrix of target (single-value) vectors.
%	  TP - Training parameters (optional).
%	Returns:
%	  W1  - New competitive layer weights.
%	  W2  - Unchanged linear layer weights.
%	
%	[W1,B1,W2] = TRAINLVQ(W1,W2,P,C,TP)
%	  C - 1xQ vector of target class numbers.
%	Returns weights and biases as above.
%	
%	Training parameters are:
%	  TP(1) - Presentations between updating display, default = 25.
%	  TP(2) - Maximum number of presentations, default = 100.
%	  TP(3) - Learning rate, default = 0.01.
%	  TP(4) - Bias time constant, default = 0.99;
%	Missing parameters and NaN's are replaced with defaults.

% 1/25/96 Xiaoou Tang

if nargin < 4, error('Not enough arguments.'); end

% TRAINING PARAMETERS
if nargin == 4, 
  tp = []; pn = 1;
end
tp = nndef_t(tp,[25 100 0.01 0.99]);
df = tp(1);
max_pres = tp(2);
lr = tp(3);
bias_time_constant = tp(4);
inv_bias_time_constant = 1-tp(4);

[r,q] = size(p);
[s,q] = size(t);
[s2,s1] = size(w2);

% BIASES
z1 = ones(s1,pn)*(1/s);
b1 = exp(1-log(z1));

% TARGETS --> INPUT VECTOR CLASSES
if s == 1
  pc = t;
  s = max(pc);
  t = sparse(t,[1:q],ones(1,q),s,q,q);
else
  [dum, pc] = max(t);
end

% TARGETS -> LAYER 1 TARGETS
t1 = w2'*t;

% WEIGHTS -> NEURON CLASSES
[dum, w1c] = max(w2);

q_ones = ones(q,1);

% PLOTTING
% newplot;
message = sprintf('TRAINC: %%g/%g epochs.\n',max_pres);
fprintf(message,0)
% if q > 200
%   ind = round([0.005:.005:1]*q);
%   plotvec_t(p(:,ind),pc(ind),'+')
% else
%   plotvec_t(p,pc,'+')
% %size(p)
% %size(pc)
% end
% hold on
% if r == 1
%   W1 = zeros(s,floor(max_pres/df)+1);
%   Wind = 1;
%   W1(:,Wind) = w1;
%   h = plotvec_t(w1',w1c,'o');
%   alabel_t('P','Cycles','LVQ: 0 Cycles')
% else
%   ax = axis;
%       if size(w1,1) > 100
%         ind = round([0.01:.01:1]*size(w1,1));
%         h = plotvec_t(w1(ind,:)',w1c(:,ind),'o');
%       else
%         h = plotvec_t(w1',w1c,'o');
%       end
%   axis(ax);
%   alabel_t('P(1),W1(1)','P(2),W1(2)','LVQ: 0 cycles')
% end
% drawnow
%dlr = lr; % for decaying learning rate
k = 1;
for i=1:max_pres

  % PRESENTATION PHASE
%  lr = lr-i*lr/(max_pres+1);
%  dlr = dlr/i;
  j = fix(rand(1,pn)*q)+1;
  P = p(:,j);
  T = t1(:,j);
%T
  n1 = -dist_t(w1,P);
  a1a = compet_t(n1);
  a1b = compet_t(n1 + T*1e5,b1);
  a1 = a1a | a1b; % avoid train twice on one input
%foo1 = z1(T);
%save foo T z1 a1b  foo1
 z1(find(T)) = z1(find(T))*bias_time_constant + a1b(find(T))*inv_bias_time_constant;
  b1 = exp(1-log(z1));

  % LEARNING PHASE
  [dw, dwind] = learnlvq_t(w1,P,a1,T,lr);
  w1(dwind,:) = w1(dwind,:) + dw;    % if the same value appear twice in
                                     % dwind, only the last one is updated
                                 % so if two samples near one neuron, take one
  % CLASSIFICATION
  if rem(i,df) == 0
     avec = simulvq_t(p,w1,w2);
    [class, col_dum] = find(avec);
    correct(k) = sum(class'==pc)*100/length(class);
    disp(['classification accuracy: ', num2str(correct(k))]);
    k = k+1;
  end
%   % PLOTTING
% if rem(i,df) == 0
%     fprintf(message,i)
%     delete(h)
%     if r == 1
%         Wind = Wind + 1;
%         W1(:,Wind) = w1;
%         h1 = plot(W1(:,1:Wind),df*fliplr(0:(Wind-1)),'w');
%         h2 = plotvec_t(w1',w1c,'o');
%         h = [h1 h2];
%         set(gca,'ylim',[0 (Wind-1)*df])
%     else
%         if size(w1,1) > 100
%             ind = round([0.01:.01:1]*size(w1,1));
%             h = plotvec_t(w1(ind,:)',w1c(:,ind),'o');
%         else
%             h = plotvec_t(w1',w1c,'o');
%         end
%         axis(ax);
%     end
%     title(sprintf('LVQ: %g cycles',i))
%     drawnow
% end
end

% PLOTTING
% if rem(i,df) ~= 0
%   fprintf(message,i)
%   delete(h)
%   if r == 1
%     plot(W1(:,1:Wind),df*fliplr(0:(Wind-1)),'w');
% 	plotvec_t(w1',w1c,'o');
%     set(gca,'ylim',[0 (Wind-1)*df])
%   else
%     h = plotvec_t(w1',w1c,'o');
%     axis(ax);
%   end
%   title(sprintf('LVQ: %g cycles',i))
%   drawnow
% end
