function n = bin(y,x)
%function n = bin(y,x)
%Bin values of vector y into bin locations 
%specified in vector x, where values of x are 
%edges of the bins. Bin widths can be unequal.
%The range of y must be contained within the range of x.
%i.e. min(x) < min(y) and max(y) < max(x).
%BIN generates the number, n, of y values in each
%x bin. (note length(n) = lenghth(x)-1)
%BIN is similar to HIST but is vectorized (thus way faster)

%C. Davis WHOI 5/14/1998

x=sort(x(:)');
n=zeros(1,length(x)-1);
y=sort(y(:)');
xy=[x y];
[z i]=sort(xy);
j=find(diff(i)<0);
k=find(diff(i)>1);
n(i(k))=j-k;
