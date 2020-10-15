function [sigma] = sigma_t_comp(salt,t,p);
%[sigma] = sigma_t_comp(salt,t,p);
%computes sigma_t (density)
t5=t;
sr=sqrt(abs(salt));
r1=((6.536332e-09*t5-1.120083e-06).*t5+1.001685e-04).*t5.^3;
r1= r1+(-9.09529e-03*t5+6.793952e-02).*t5-28.263737;
tmp =((5.3875e-09*t5-8.2467e-07).*t5+7.6438e-05);
r2=(tmp.*t5-0.0040899).*t5+0.824493;
r3=(-1.6546e-06*t5+1.0227e-04).*t5-5.72466e-03;
sig=(4.8314e-04*salt+r3.*sr+r2).*salt+r1;
v350p=1.0/1028.1063;
sigma = sig + 28.106331; %{dr350}
