function d = potlinedist(x1, y1, k, mx, my)

% point (x1, y1) to line (k, mx, my) distance, k is the tan(th).
% negative if point below line

% 1/10/97 X. Tang

d = (y1-k*x1-my+k*mx)/sqrt(1+k*k);