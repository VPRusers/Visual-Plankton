function [nxb,xb] = bindata(x,y);
%[nxb,xb] = bindata2(x,y)
%vectorized binning of vector x into y bins if y is a scalar
%or into equal-sized bins specified by y if y is a vector
%gives nxb, the number of x values that fall within in each bin
%and xb, the x bins
%if y is a vector, its elements should correspond to the beginning
%value of each bin except for the last element which should be
%the end value of the last bin;
%this routine is way faster than hist but is for equal size bins

%CSD WHOI - 12/9/1997


colflag=0;
if (size(x,1)>size(x,2)), x=x'; colflag=1;end;

if length(y)==1,
  n=y;
  xmin=min(x);xmax=max(x);
  xb=xmin:(xmax-xmin)/n:xmax;
  xb=xb(1:n);
  x=x-xmin;
  x=(x/max(x)*(n-1))+1;
else
  n=length(y)-1;
  xb=y(1:n);
  x=((x-min(y))/(max(y)-min(y))*n)+1;
end

x=floor(x);

nxb=zeros(1,n);
sx=sort(x);
dsx=[diff(sx) 1];
i=find(dsx);
nsx=diff([0 i]);
nxb(sx(i))=nsx;

if colflag==1, nxb=nxb'; xb=xb;end;