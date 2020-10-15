function [ax] = axissnug(p,h)
%function [ax] = axissnug(p,h)
%Make axis limits p percent greater than data limits
%   e.g. default p=[5 5 5] makes the axis limits 5% larger than
%        the data limits in all directions.
%If p is a scalar (e.g. p=5), that percentage is applied
%        in all dimensions
%First 'axis tight' is used, then axis limits are made 
%   p percent larger
%Operates on current axis or axis specified by handle h.
%example: ax=axissnug([5 10 7],h) makes the axes 

if nargin<2,
    h=gca;
end

if nargin<1,
    p=[5 5 5];
end

if length(p)==1,
    p=[p p p];
end

f=p/100;

axis(h,'tight');
ax=axis(h);

dax=diff(ax);
if length(dax)==3,%2D plot
    ax=[ax(1)-dax(1)*f(1) ax(2)+dax(1)*f(1) ax(3)-dax(3)*f(2) ax(4)+dax(3)*f(2)];
elseif length(dax)==5,%3D plot
    ax=[ax(1)-dax(1)*f(1) ax(2)+dax(1)*f(1) ax(3)-dax(3)*f(2) ax(4)+dax(3)*f(2) ax(5)-dax(5)*f(3) ax(6)+dax(5)*f(3)];
end
axis(h,ax);
