function [y] = runave(x,m);
%function [y] = runave(x,m);
%
%fast computation of running average of m consecutive numbers in vector x 

n=length(x);
z = [0; cumsum(x)];
y = ( z(m+1:n+1) - z(1:n-m+1) ) / m;

