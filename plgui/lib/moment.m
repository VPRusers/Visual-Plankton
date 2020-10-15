function [t]= moment(p,binnum,N)

% moment preserving

gray = [0:binnum-1];
m1 = sum(gray.*p)
m2 = sum(gray.*gray.*p)
m3 = sum(gray.*gray.*gray.*p)

c0 = (m1*m3-m2*m2)/(m2-m1*m1)
c1 = (m1*m2-m3*m3)/(m2-m1*m1)

z = (sqrt(c1*c1-4*c0)-c1)/2

t = (z-m1)/sqrt(c1*c1-4*c0)

