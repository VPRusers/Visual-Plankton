function [Ufit, Vfit, t_need]=adcp_predict(absu,absv,adcptime,Now);
% feed this routine the ADCP data you have and project from last
% time in adcp to Now

% Select some times to include
%tmin = 125.575; % make it 'now -3 days' or all ADCP check time
%tmax = inf;
tmin = min(adcptime);
tmax = max(adcptime);

% build array of times needed
dt = mean(diff(adcptime));
t_need = [max(adcptime):dt:Now];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now do some detiding using the following model
%
% | u_1 |  | sin(wt_1) cos(wt_1) 1 |
% | u_2 |  | sin(wt_2) cos(wt_2) 1 |
% | u_3 |  | sin(wt_3) cos(wt_3) 1 |  | a |
% |  .  |  |     .         .     . |  | b |
% |  .  |  |     .         .     . |  | M |
% |  .  |  |     .         .     . |  
% |     |  |                       |  

% set some tidal frequencies (roughly)
M2 = 0.140519e-3;
S2 = 0.14544e-3;
N2 = 0.137880e-3;
O1 = 0.675977e-4;
K1 = 0.729212e-4;

% set up the tidal model as a mean plus a single harmonic 
if(1)	% M2, S2, O1, K1, mean
  X = [sin(86400*M2*adcptime') cos(86400*M2*adcptime') ...
		sin(86400*S2*adcptime') cos(86400*S2*adcptime') ...
		sin(86400*O1*adcptime') cos(86400*O1*adcptime') ...
		sin(86400*K1*adcptime') cos(86400*K1*adcptime') ...
					ones(size(adcptime'))];
else	% M2 & mean only
  X = [sin(86400*M2*adcptime') cos(86400*M2*adcptime') ones(size(adcptime'))];
end

Bu = regress(absu',X);
Bv = regress(absv',X);
%Bu = regress(UTRANS(keep)',X(keep,:));
%Bv = regress(VTRANS(keep)',X(keep,:));
Unew = [X*Bu]';
Vnew = [X*Bv]';

% replace DAYS w/ 'times needed'
X = [sin(86400*M2*(t_need)') cos(86400*M2*t_need') ...
     sin(86400*S2*t_need') cos(86400*S2*t_need') ...
     sin(86400*O1*t_need') cos(86400*O1*t_need') ...
     sin(86400*K1*t_need') cos(86400*K1*t_need') ...
     ones(size(t_need'))];

Ufit = [X*Bu]';
Vfit = [X*Bv]';

t_need(1)=[];
Ufit(1)=[];
Vfit(1)=[];


