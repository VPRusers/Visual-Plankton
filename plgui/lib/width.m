function [dc1,dc2,dc3,db1,db2] = width(cont)

% db1 long bounding, db2 short bounding
% for computing all width measure directly from contour.

% 1/10/97, Xiaoou Tang

case1 = 2; debug = 0;
if case1 == 1
  area = sum(sum(cont));                  % area 
  [y,x] = find(cont);
elseif case1 == 2
  area = size(cont,1);
  x = cont(:,1);
  y = cont(:,2);
end
 
m00 = area; m10 = sum(x); m01 = sum(y);
mx = m10/area;                          % col number of the center       
my = m01/area;                          % row number of the center
xx = x.*x; yy = y.*y; 
m20 = sum(xx);                          % second vertical moment        
m02 = sum(yy);                          % second horiz moment
m11 = sum(x.*y);
u00 = m00; u20 = m20-mx*m10; u02 = m02-my*m01;
u11 = m11 - my*m10; 

[e1,e2,th] = princ_moment(u02,u20, -2*u11);
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
if debug
  plot(x, y, 'm'); hold on
  x = [min(x)-10: max(x)+10];
  axis([min(x)-10, max(x)+10,min(y), max(y)]) ;
  y = k*x+ my - k*mx; plot(x,y,'r'); 		% max principle axis	
  plot(xcl1, ycl1, 'ro'); plot(xcr1, ycr1, 'wo');		
  plot(xbl1, ybl1, 'go'); plot(xbr1, ybr1, 'go');
  y = k*x+ ybl1 - k*xbl1; plot(x,y); 
  y = k*x+ ybr1 - k*xbr1; plot(x,y); 
  y = k*x+ y3 - k*x3; plot(x,y); 
  y = k*x+ y4 - k*x4; plot(x,y); 		% crossing 2, 3 in midway
  plot(xcl2,ycl2,'ro',xcr2,ycr2,'wo',xcl3,ycl3,'ro',xcr3,ycr3,'wo');
end
% vertical
k = tan((th+90)*pi/180+eps);
[xbl2,ybl2,xbr2,ybr2, dist] = bonding(k, mx, my, cont);	% short bonding
db2 = abs(potlinedist(xbl2, ybl2, k, xbr2, ybr2));
if debug
  y = k*x+ my - k*mx; plot(x,y,'b'); 		% min principle axis
  plot(xbl2, ybl2, 'go'); plot(xbr2, ybr2, 'go');
  y = k*x+ ybl2 - k*xbl2; plot(x,y); 
  y = k*x+ ybr2 - k*xbr2; plot(x,y); hold off; axis('equal')
end