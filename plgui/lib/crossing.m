function [x1,y1,x2,y2, dist] = crossing(k, mx, my, cont);

% computer the crossing points of a line with a contour

THRESH = 1.5;
x = cont(:,1); y = cont(:,2);
dist = (y-k*x-my+k*mx)/sqrt(1+k*k);
[dum, ind] = min(abs(dist));
x1 = x(ind); y1 = y(ind);

indall = find(abs(dist)<THRESH);
len = length(indall);
wid1 = (x1(ones(len,1))-x(indall)).^2 + (y1(ones(len,1))-y(indall)).^2;
[dum,ind] = max(wid1);
x2 = x(indall(ind));
y2 = y(indall(ind));
