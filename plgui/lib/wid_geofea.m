function [dc1,dc2,dc3,db2,db1] = wid_geofea(th, mx, my, cont)

% db1 long bounding, db2 short bounding
% for computing all width measure inside geofea.m

% 1/10/97, Xiaoou Tang
k = tan(th*pi/180+eps);
[xcl1,ycl1,xcr1,ycr1, dist] = crossing(k, mx, my, cont);% crossing 1 
[xbl1,ybl1,xbr1,ybr1, dist] = bonding(k, mx, my, cont);	% long bonding
x3 = (xbl1+mx)/2; y3 = (ybl1+my)/2; x4 = (xbr1+mx)/2; y4 = (ybr1+my)/2;
[xcl2,ycl2,xcr2,ycr2, dist] = crossing(k, x3, y3, cont);
[xcl3,ycl3,xcr3,ycr3, dist] = crossing(k, x4, y4, cont);%crossing 2, 3 in mid
dc1 = pointdist(xcl1,ycl1,xcr1,ycr1);
dc2 = pointdist(xcl2,ycl2,xcr2,ycr2);
dc3 = pointdist(xcl3,ycl3,xcr3,ycr3);
db1 = abs(potlinedist(xbl1, ybl1, k, xbr1, ybr1));

debug = 0;
if debug
  figure(3);clf; %subplot(221);
  x = cont(:,1); y = cont(:,2);
  h1 = plot(x, y, 'm'); hold on
  set(h1, 'linewidth',2)
  x = [min(x)-10: max(x)+10];
  axis([min(x)-10, max(x)+10,min(y), max(y)]) ;
  y = k*x+ my - k*mx; plot(x,y,'b'); 		% max principle axis	
  plot(xcl1, ycl1, 'bo'); plot(xcr1, ycr1, 'bo');		
  plot(xbl1, ybl1, 'bo'); plot(xbr1, ybr1, 'bo');
  y = k*x+ ybl1 - k*xbl1; plot(x,y,'g'); 
  y = k*x+ ybr1 - k*xbr1; plot(x,y,'g'); 
  y = k*x+ y3 - k*x3; plot(x,y,'g'); 
  y = k*x+ y4 - k*x4; plot(x,y,'g'); 		% crossing 2, 3 in midway
  plot(xcl2,ycl2,'ro',xcr2,ycr2,'yo',xcl3,ycl3,'ro',xcr3,ycr3,'yo');
  axis equal
end

% vertical
k = tan((th+90)*pi/180+eps);
[xbl2,ybl2,xbr2,ybr2, dist] = bonding(k, mx, my, cont);	% short bonding
db2 = abs(potlinedist(xbl2, ybl2, k, xbr2, ybr2));

if debug
  y = k*x+ my - k*mx; plot(x,y,'y'); 		% min principle axis
  plot(xbl2, ybl2, 'go'); plot(xbr2, ybr2, 'go');
  y = k*x+ ybl2 - k*xbl2; plot(x,y,'g'); 
  y = k*x+ ybr2 - k*xbr2; plot(x,y,'g'); hold off; % axis('equal')
%  title('Geometrical measures: area,perimeter,width,length,short-bound, top-wi%dth, bot-width');
  title('Geometrical Measurements');
  pause;
end

