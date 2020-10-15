function [yi]=interpc(x,y,xn)

% function [yi]=interpc(x,y,xi)

x=x(:);
y=y(:);
xn=xn(:);


y1=[y;ones(size(xn))*NaN];
[x1,i]=sort([x;xn]);
y1=y1(i);
outind=find(isnan(y1));

if any(diff(xn)<0)
	error('index not monotonic')
elseif (isnan(y1(1))) | (isnan(y1(length(y1))))
	error('index out of range')
end

lx=length(x);

sl=diff(y)./diff(x);
in=y(1:lx-1)-sl.*x(1:lx-1);
sl(lx,1)=sl(lx-1);
in(lx,1)=in(lx-1);

a=cumsum(~isnan(y1));
y1=sl(a).*x1+in(a);
yi=y1(outind);
