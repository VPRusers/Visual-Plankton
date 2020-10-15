function plotshapes(x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,...
x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,...
x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36)

%PLOTSHAPES Plots many vectors using squares, triangles etc.
%           PLOTSHAPES(Y1,Y2,Y3 ...) plots vectors Y1, Y2 as alternate
%             default shapes "s,d,t,i,l,r"
%           PLOTSHAPES(Y1,C1, Y2,C2 ..) - plots Y1,Y2 .. as shapes C1,C2 ..
%           PLOTSHAPES(X1,Y1,C1, ... ) - plots X1 v/s Y1 as C1 etc.
%           C is any one of the following:
%           s - square;       d - diamond/rhombus    t - triangle
%           i - inverted triangle
%           l - left triangle       r - right triangle
%           +, * & x are also valid options
%           SEE ALSO: PLOT, SHAPES

if nargin == 2, x03 = []; end
if nargin == 1, x02 = []; x03 = []; end

%axis('square') %**

scale = 15;           % scale for length of shape sides  %**
%scale = 50;           % scale for length of shape sides
if isstr(x03),
  minx = min(x01); maxx = max(x01); miny = min(x02); maxy = max(x02);
  for i = 1:3:nargin,
    eval(sprintf('minx = min(min(x%02.0f), minx);', i))
    eval(sprintf('maxx = max(max(x%02.0f), maxx);', i))
    eval(sprintf('miny = min(min(x%02.0f), miny);', i+1))
    eval(sprintf('maxy = max(max(x%02.0f), maxy);', i+1))
  end
  ax = (maxx - minx)/scale; ay = (maxy - miny)/scale;
%  axis([minx-ax*5 maxx+ax*5 miny-ay*5 maxy+ay*5]);  % **
%  plot(0)               % show axes
  hold on
  for i = 1:3:nargin,
%    eval(sprintf('shapes(x%02.0f,x%02.0f,x%02.0f,ax,ay);', i, i+1, i+2));
    eval(sprintf('shapes(x%02.0f,x%02.0f,x%02.0f);', i, i+1, i+2)); %**
  end
elseif isstr(x02)
  minx = 0; maxx = length(x01); miny = min(x01); maxy = max(x01);
  for i = 1:2:nargin,
    eval(sprintf('maxx = max(length(x%02.0f), maxx);', i))
    eval(sprintf('miny = min(min(x%02.0f), miny);', i))
    eval(sprintf('maxy = max(max(x%02.0f), maxy);', i))
  end
  ax = (maxx - minx)/scale; ay = (maxy - miny)/scale;
  axis([minx maxx+ax*5 miny-ay*5 maxy+ay*5]);
  plot(0)               % show axes
  hold on
  for i = 1:2:nargin,
    eval(sprintf('shapes(1:length(x%02.0f),x%02.0f,x%02.0f,ax,ay);',...
         i, i, i+1));
  end
else
  c = 'sdtilr+*x'; cn = length(c);
  minx = 0; maxx = length(x01); miny = min(x01); maxy = max(x01);
  for i = 1:nargin,
    eval(sprintf('maxx = max(length(x%02.0f), maxx);', i))
    eval(sprintf('miny = min(min(x%02.0f), miny);', i))
    eval(sprintf('maxy = max(max(x%02.0f), maxy);', i))
  end
  ax = (maxx - minx)/scale; ay = (maxy - miny)/scale;
  axis([minx maxx+ax*5 miny-ay*5 maxy+ay*5]);
  plot(0)               % show axes
  hold on
  for i = 1:nargin,
    eval(sprintf('shapes(1:length(x%02.0f),x%02.0f,c(%02.0f),ax,ay);',...
         i, i, rem(i,cn)+1));
  end
end
axis('normal'); axis;
hold off


