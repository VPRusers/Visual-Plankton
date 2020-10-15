function hh = plotvec_t(x,c,m)
%PLOTVEC Plot vectors with different colors.
%	
%	PLOTVEC(X,C,M)
%	  X - Matrix of (column) vectors.
%	  C - Row vector of color coordinate.
%	  M - Marker, default = '+'.
%	Plots each ith vector in M with a marker M using the
%	  ith value in C as the color coordinate.
%	
%	PLOTVEC(M)
%	Plots each ith vector in M with marker '+' using the
%	  index i as the color coordinate.
%	
%	EXAMPLE: x = [0 1; -1 2];
%	         c = [1 2];
%	         plotvec(x,c)

% 2/9/96, Xiaoou Tang

if nargin < 1,error('Not enough input arguments.'); end

% VECTORS
[xr,xc] = size(x);
if xr < 2
  x = [x; zeros(2-xr,xc)];
  xr = 2;
end
xr = 2;  % **

% COLORS
if nargin == 1
  c = [0:(xc-1)]/(xc-1);
end
%colormap(cool)
colormap('default')
map = colormap;
[mapr,mapc] = size(map);
mapr = mapr-1;
cc = map(round((c-min(c))*(mapr-1)/max(c))+1,:);

% MARKER
if nargin < 3
  m = '+';
end

hold on
H = zeros(1,xc);
minx = nnminr(x);
maxx = nnmaxr(x);
difx = maxx-minx;
minx = minx-difx*0.05;
maxx = maxx+difx*0.05;

% 2-D PLOTTING
if xr == 2
  for i=1:xc
    h = plot(x(1,i),x(2,i),m);
	set(h,'color',cc(i,:))
	H(i) = h;
  end
  plot([minx(1) maxx(1)],[minx(2) maxx(2)],'w.');
%  for i=1:xc
%    h2 = plot([minx(1)+difx(1)*i/(xc+1)],[minx(2)+difx(2)/(3*xc)],'w.');
%	set(h2,'color',cc(i,:))
%  end  
% 3-D PLOTTING
else
  for i=1:xc
    h = plot3(x(1,i),x(2,i),x(3,i),m);
	set(h,'color',cc(i,:))
	H(i) = h;
  end
  plot3([minx(1) maxx(1)],[minx(2) maxx(2)],[minx(3) maxx(3)],'x');
end

set(gca,'box','on')
hold off
if nargout == 1, hh = H; end

