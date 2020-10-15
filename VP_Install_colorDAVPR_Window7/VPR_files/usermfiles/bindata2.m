function [nxb] = bindata2(x,y);
%[nxb] = bindata2(x,y)
%nonvectorized binning of vector x into bins specified by the vector y;
%the bins can be of unequal size
%outputs nxb, the number of x values that fall within in each bin
%the elements of y should correspond to the beginning
%value of each bin except for the last element which should be
%the end value of the last bin;
%this routine is similar to hist and appears to be slower.

nxb=[];
for j=1:length(y)-1;
   nxb(j)=sum(x>=y(j) & x<y(j+1));
end;
xb=y;

