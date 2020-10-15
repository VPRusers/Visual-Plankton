function [s2,sigma] = salt_comp(co,t,p)

%compute salinity from conductivity, temperature, and pressure     
r=co/42.914;
aL=(0.0000207).*p+(-6.37e-10)*p.^2 + (3.989e-15)*p.^3;
aL=aL./(1 + (0.03426).*t + (0.0004464).*t.^2 + (0.4215).*r + (-0.003107).*t.*r);
rt=(0.6766097)+(0.0200564).*t + (1.104259e-04).*t.^2 + (-6.968901e-07)*t.^3 + (1.0031e-09)*t.^4;
rt=r./(rt.*(1+aL));
s=(8.000001e-03)+(0.1692).*exp((0.5).*log(rt))+(25.3851).*rt+(14.0941).*exp((1.5).*log(rt))+(-7.0261).*rt.*rt+(2.7081).*exp((2.5).*log(rt));
s1=(0.0005)+(0.0056).*exp((0.5).*log(rt))+(0.0066).*rt+(0.0375).*exp((1.5).*log(rt))+(6.360001e-02).*rt.*rt+(0.0144).*exp((2.5).*log(rt));
salt=s+((t-15)./(1+(0.0162)*(t-15))).*s1; %salt = salinity

%compute potential temperature (theta) from temperature, salinity, and pressure

pr=zeros(size(p));
salin = salt;
p(p<0)=0;
po=p;
t5=t;

%adbat(po,t5,salin);%{procedure to compute "ad temp grad",atg}
s5=salin-35.0;
atg=((-2.1687E-16.*t5+1.8676E-14).*t5-4.6206E-13).*po;
tt1=(2.7759E-12.*t5-1.1351E-10).*s5;
tp=-5.4481E-14.*t5+8.732999E-12;
atg=(atg+(tt1+(tp.*t5-6.7795E-10).*t5+1.8741E-08)).*po;
atg=atg+(-4.2393E-08.*t5+1.8932E-06).*s5;
atg=atg+((6.6228E-10.*t5-6.836E-08).*t5+8.5258E-06).*t5+3.5803E-05;
%{ calculate local potential temp at pr=0.0}
h=pr-po;xk=h.*atg;t5=t5+0.5*xk;
q=xk;po=po+0.5*h;
%adbat(po,t5,salin);
atg=((-2.1687E-16*t5+1.8676E-14).*t5-4.6206E-13).*po;
tt1=(2.7759E-12*t5-1.1351E-10).*s5;
tp=-5.4481E-14*t5+8.732999E-12;
atg=(atg+(tt1+(tp.*t5-6.7795E-10).*t5+1.8741E-08)).*po;
atg=atg+(-4.2393E-08*t5+1.8932E-06).*s5;
atg=atg+((6.6228E-10*t5-6.836E-08).*t5+8.5258E-06).*t5+3.5803E-05;
xk=h.*atg;
t5=t5+0.29289322*(xk-q);q=0.58578644*xk+0.121320344*q;
%adbat(po,t5,salin);
atg=((-2.1687E-16*t5+1.8676E-14).*t5-4.6206E-13).*po;
tt1=(2.7759E-12*t5-1.1351E-10).*s5;
tp=-5.4481E-14*t5+8.732999E-12;
atg=(atg+(tt1+(tp.*t5-6.7795E-10).*t5+1.8741E-08)).*po;
atg=atg+(-4.2393E-08*t5+1.8932E-06).*s5;
atg=atg+((6.6228E-10*t5-6.836E-08).*t5+8.5258E-06).*t5+3.5803E-05;
xk=h.*atg;
t5=t5+1.707106781*(xk-q);q=3.414213562*xk-4.121320344*q;po=po+0.5*h;
% adbat(po,t5,salin);
atg=((-2.1687E-16*t5+1.8676E-14).*t5-4.6206E-13).*po;
tt1=(2.7759E-12*t5-1.1351E-10).*s5;
tp=-5.4481E-14*t5+8.732999E-12;
atg=(atg+(tt1+(tp.*t5-6.7795E-10).*t5+1.8741E-08)).*po;
atg=atg+(-4.2393E-08*t5+1.8932E-06).*s5;
atg=atg+((6.6228E-10*t5-6.836E-08).*t5+8.5258E-06).*t5+3.5803E-05;
xk=h.*atg;
theta=t5+(xk-2*q)/6;

%compute potential density (sigma theta) from theta 
sr=sqrt(abs(salin));
t5=theta;
r1=((6.536332e-09*t5-1.120083e-06).*t5+1.001685e-04).*t5.^3;
r1= r1+(-9.09529e-03*t5+6.793952e-02).*t5-28.263737;
tmp =((5.3875e-09*t5-8.2467e-07).*t5+7.6438e-05);
r2=(tmp.*t5-0.0040899).*t5+0.824493;
r3=(-1.6546e-06*t5+1.0227e-04).*t5-5.72466e-03;
sig=(4.8314e-04*salin+r3.*sr+r2).*salin+r1;
v350p=1.0/1028.1063;sva=-sig*v350p./(1028.1063+sig);
sigma = sig + 28.106331; %{dr350}
