function peri=bperi(cont)
% This is a function to calculate the bug perimeter in mm.
% Input: 
% cont: contour of the bug
% Output:
% peri: Perimeter of bug in mm.
% By Qiao Hu 02/01/00
%modified by CSD 09/14/01 for new camera w/ square pixels
if nargin <1, error('Not enough arguments.'); end   

%if cam ==4 
%   xmm=.0156;ymm=.0292;xymm=.0331;
%else
%   xmm=.0459;ymm=.0875; xymm=.0988;
%end 

x=cont(:,1);y=cont(:,2);
len=length(x);
x(len+1)=x(1); y(len+1)=y(1);
peri=0.; 
for i=1:len,
   if x(i)==x(i+1)
%      peri=peri+xmm;
      peri=peri+1;
   elseif y(i)==y(i+1)
%      peri=peri+ymm;
      peri=peri+1;
   else 
%      peri=peri+xymm;
      peri=peri+1.41421356237310;
   end
end

      