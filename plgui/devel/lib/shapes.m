function shapes(x,y,c,ax,ay)

%SHAPES   Plot using squares, triangles etc.
%         SHAPES(Y, C) plots vector Y.
%         SHAPES(X, Y, C) plots vector Y versus vector X.
%         SHAPES(X, Y, C, AX, AY) specifies lengths of sides of the
%          shape along X & Y axes.
%         C is any one of the following:
%         s - square;       d - diamond/rhombus    t - triangle
%         i - inverted triangle
%         l - left triangle       r - right triangle
%         +, * & x are also valid

% This program plots vectors using squares, triangles etc. for each point.
% I am using a Sun SPARCstation 1 running X11R4. Even though the
% shapes do not appear to be "ok" on the screen, then do print out
% pretty well on a Postscript printer (I'm using a Apple LaserWriter IINT/NTX).
% I'm not sure how they perform on other printers.
%
% This program is able to plot only one vector. I've written another
% program *plotshapes.m* which will soon follow which can be used as
% a front end to plot many vectors. I've
% deviated from the general format of plot, in that, unlike plot,
% plotshapes(y1,y2,y3...) plots vectors y1,y2,y3 ... along the ordinate.
%
% For Eg.
% >> shapes(1:10,1:10,'s')
% >> x=1:10; plotshapes(x,x+0.5,x+1,x+1.5,x+2,x+2.5,x+3,x+3.5,x+4)
%    % this gives all possible shapes (9)
%
global AX AY
npt = length(x);

if nargin < 3,
  c = y;
  y = x;
  x = 1:npt;
end

if nargin < 5,
%  scale = 50;
  scale = 50;      %**
%  ax = (max(x) - min(x)) / scale;
%  ay = (max(y) - min(y)) / scale;
  ax = AX/scale;      %**
  ay = AY/scale;      %**
end

if length(c) > 1, c = c(1); end           % keep only first letter

[ mx nx ] = size(x);
[ my, ny ] = size(y);

% make into row vectors
if nx == 1,     x = x.';        end
if ny == 1,     y = y.';        end

%increments
lx = ax * 2 / sqrt(3);
ly = ay * 2 / sqrt(3);

lx2 = lx/2;
ly2 = ly/2;
ax2 = ax/2; ax3 = ax/3; ax23 = 2*ax/3;
ay2 = ay/2; ay3 = ay/3; ay23 = 2*ay/3;
rx2 = ax/sqrt(2);
ry2 = ay/sqrt(2);

%plot

if     c == 't',               % triangle
  plot([(x-lx2); x; (x+lx2); (x-lx2)] , [(y-ay3);...
         (y+ay23); (y-ay3); (y-ay3)], 'r-' )
elseif c == 'i',               % inverted triangle
  plot([x; (x-lx2); (x+lx2); x] , [(y-ay23); (y+ay3); ...
        (y+ay3); (y-ay23)], 'r-')
elseif c ==  'l',              % left triangle
  plot([(x-ax23); (x+ax3); (x+ax3); (x-ax23)], [y; (y+ly2);...
         (y-ly2); y], 'r-')
elseif c == 'r',         % right triangle
  plot([(x+ax23); (x-ax3); (x-ax3); (x+ax23)], [y; (y-ly2);...
         (y+ly2); y], 'r-')
elseif c == 'd',         % diamond/rhombus
  plot([(x-rx2); x; (x+rx2); x; (x-rx2)], [y; (y+ry2); y; ...
        (y-ry2); y], 'r-')
elseif c == 's'          % square
  plot([(x-ax2); (x-ax2); (x+ax2); (x+ax2); (x-ax2)], ...
      [(y-ay2); (y+ay2); (y+ay2); (y-ay2); (y-ay2)], 'r-')
elseif c == '*'
  plot([(x-ax2); (x+ax2)], [(y-ay2); (y+ay2)], 'r-', ...
        [(x-ax2); (x+ax2)], ...
      [y; y], 'r-', [(x-ax2); (x+ax2)], [(y+ay2); (y-ay2)], 'r-')
elseif c == '+'
  plot([x; x], [(y+ay2); (y-ay2)], 'r-', [(x-ax2); (x+ax2)],...
         [y; y], 'r-')
elseif c == 'x'
    plot([(x-ax2); (x+ax2)], [(y-ay2); (y+ay2)], 'r-', ...
        [(x-ax2); (x+ax2)], [(y+ay2); (y-ay2)], 'r-')
end

end


