function [E1, E2, th] = princ_moment(a,c,b)

% a is the second moment around horiz. axis, c is around vertical, b = -2*mxy2
% E1 minor moment, E2 major moment, th direction of major axis 

%	8/16/95	Xiaoou Tang	Created
%  02/15/00 Rewrited by Qiao Hu.  
% ***************************************************************************

   mid = sqrt(b^2+(a-c)^2);
if mid == 0
  E1 = a; E2 = c; th = 0;
  return
end
%   as = b/mid;
%   ac = (a-c)/mid; 
%   E1 = (a+c)/2-(a-c)*ac/2-b*as/2;  	% minimum principal moment
%   E2 = (a+c)/2+(a-c)*ac/2+b*as/2;   	% maximum principal moment
   E1 = (a+c-mid)/2;		% minimum principal moment 
   E2 = (a+c+mid)/2;    % maximum principal moment 
   if a>c 
      th=atan2(a-c+mid,b);
   else
      th=atan2(b,c-a+mid);
   end   
%   if as>=0 
%      if ac>=0
%         th = asin(as)/2;
%      else
%         th = acos(ac)/2;        	% in second quarter
%      end
%   else
%      if ac>=0
%         th = (2*pi+asin(as))/2;  	% in third quarter
%      else
%         th = (pi+abs(asin(ac)))/2;  	% in fourth quarter
%      end 
%   end
   th = th*180/pi;
