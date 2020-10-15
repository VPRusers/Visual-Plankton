function [dw, dwind] = learnlvq_t(w,p,a,t,lr)
%LEARNLVQ Learning vector quantization rule.
%	
%	LEARNLVQ(W,P,A,T,LR)
%	  W  - SxR weight matrix.
%	  P  - Rx1 input vector.
%	  A  - Sx1 0/1 output vector.
%	  T  - Sx1 0/1 target vector
%	  LR - Learning rate.
%	Returns a weight change matrix.
%	
%	See also NNLEARN, LVQ, SIMLVQ, INITLVQ, TRAINLVQ.

% 1/25/96, Xiaoou Tang 

if nargin < 4,error('Not enough arguments.'); end

[S,R] = size(w);
x = t(find(a))*2 - 1;   % t is [1 0 0;   a is actual output
			% 1 0 0;   one and only one '1' on each col.
			% 0 1 0;  
			% 0 0 1;  
			% 0 0 1;  
[dwind, pind] = find(a);  % dwind is index for which row of w to update
			  % pind is col ind for p.
dw = lr*(p(:,pind)'-w(dwind,:)).*x(:,ones(1,R));

