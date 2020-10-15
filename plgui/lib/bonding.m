function [x1,y1,x2,y2, dist] = bonding(k, mx, my, cont);

% computer the bonding points of a contour on one direction

x = cont(:,1); y = cont(:,2);
dist = (y-k*x-my+k*mx)/sqrt(1+k*k);
[dum, ind1] = min(dist);
[dum, ind2] = max(dist);
x1 = x(ind1); y1 = y(ind1);
x2 = x(ind2); y2 = y(ind2);
