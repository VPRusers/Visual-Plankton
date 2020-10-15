function [p,t,theta,s2,sigma]=stca(t,p,s2)
%  function to compute temp, potential temperature, salinity, potential density,
%  fluorescence, and attenuation.   
%  Modified for Matlab by CSD, 1/17/95.
%  modified to accept the 6-digit data from the 16 bit system
%  modified to accept vector input CSD 1/11/97
%  modified to for FSI or SeaBird FastCat conductivity input on new VPR
%  CSD 6/6/2003
%  this software is proprietary and licensed by the Woods Hole Oceanographic Institution
%  modified for digital autovpr, inputs are temperature, pressure, salinity, CSD 4/26/06 


%%{constants used in calculating salinity from conductivity and other constants}
a1=0.0000207;a2=-6.37e-10;a3=3.989e-15;by=0.03426;
bz=0.0004464;bu=0.4215;bw=-0.003107;c0=0.6766097;cy=42.914;
cz=0.0200564;cw=1.104259e-04;c3=-6.968901e-07;c4=1.0031e-09;
e1=8.000001e-03;e2=-0.1692;e3=25.3851;e4=14.0941;e5=-7.0261;
e6=2.7081;d1=0.0005;d2=-0.0056;d3=-0.0066;d4=-0.0375;
d5=6.360001e-02;d6=-0.0144;k=0.0162;q1=2.5;q2=1.5;q3=0.5;q4=15;
la=100;lb=5800;ld=7000;le=20;lg=10;lh=40;li=5;lj=500;
trac = 4.73;zoffset = -0.001;five=5;

% %{salinity computation}
%r=co/42.914;
%al=a1.*p+a2*p.^2 + a3*p.^3;
%al=al./(1 + by.*t + bz.*t.^2 + bu.*r + bw.*t.*r);
%rt=c0+cz.*t + cw.*t.^2 + c3*t.^3 + c4*t.^4;
%rt=r./(rt.*(1+al));
%s=e1+e2.*exp(q3.*log(rt))+e3.*rt+e4.*exp(q2.*log(rt))+e5.*rt.*rt+e6.*exp(q1.*log(rt));
%s1=d1+d2.*exp(q3.*log(rt))+d3.*rt+d4.*exp(q2.*log(rt))+d5.*rt.*rt+d6.*exp(q1.*log(rt));
%s2=s+((t-q4)./(1+k*(t-q4))).*s1; %s2 = salinity
%s2=co;

% %{compute potential temperature, potential density, and delta potemp (dtheta)}
pr=zeros(size(p));
salin = s2;
p(p<0)=0*p(p<0);
temp=t;
%         pottemp(salin,temp,p,pr);  % %{outputs theta}
%procedure pottemp(salin,temp,p,pr:real);
%%{to compute local potential temperature at pr
%    units:     pressure         p0      decibars
%               temperature      t5      deg c
%               salinity         salin   (pss-78)
%               reference prs    pr      decibars
%               potential tmp.   theta   deg c
%check value: theta = 36.89073 c,s=40, t5=40 deg c, p0=10000 decibars
%             pr = 0 decibars}
po=p;t5=temp;
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
xk=h.*atg;theta=t5+(xk-2*q)/6;
temp=theta;po=pr;%{writeln('theta = ',theta);}

%procedure sigmacal(salin,theta,pr:real);  % %{outputs sigma-theta = sigma}
%{compute sigma p or sigma theta given press,temp or pot temp, sal
%   specific volume anomaly (steric anomaly) based on 1980 equation of
%   state for seawater and 1978 practical salinity scale
%  units:
%        pressure        po     decibars
%        temperature     t5     deg celsius (ipts-68)
%        salinity        salin  (pss-78)
%        spec. vol ano.  svan   1.0e-8 m**3/kg
%        density ano.    sigma  kg/m**3]}

%{  check value: svan = 981.30210 e-8 m**3/kg for s=40 (pss-78)
%     t = 40 deg c, po = 10000 decibars.
%    check value: sigma = 59.82037 kg/m**3 for s=40 (pss-78)
%     t = 40 deg c, po = 10000 decibars.
%    convert pressure to bars and take square root salinity}
pbar=pr/10;sr=sqrt(abs(salin));t5=theta;
%{  pure water density at atmospheric pressure}
r1=((6.536332e-09*t5-1.120083e-06).*t5+1.001685e-04).*t5.^3;
r1= r1+(-9.09529e-03*t5+6.793952e-02).*t5-28.263737;
%{  seawater density atm pressure; coefficiencts involving salinity}
tmp =((5.3875e-09*t5-8.2467e-07).*t5+7.6438e-05);
r2=(tmp.*t5-0.0040899).*t5+0.824493;
%{r2=(((5.3875e-09*t5-8.2467e-07).*t5+7.6438e-05)*t5-0.0040899)*t5+0.824493;}
r3=(-1.6546e-06*t5+1.0227e-04).*t5-5.72466e-03;
r4=4.8314e-04;
%{  international one-atmosphere equation of state of seawater}
sig=(r4*salin+r3.*sr+r2).*salin+r1;
%{  specific volume at atmosperic pressure}
v350p=1.0/1028.1063;sva=-sig*v350p./(1028.1063+sig);
sigma = sig + 28.106331; %{dr350}
%{ sg=28.106331-(sva/(v350p*(v350p+sva)));}
%{  scale specific vol. anomaly to normally reported units}
svan=sva*1e+08;
if pbar ~= 0.0,
    %    procedure pterms;
    %   %{ new high pressure equation of state for seawater}
    %   %{compute pressure terms}
    ee1=(9.1697e-10*t5+2.0816e-08).*t5-9.934799e-07;
    bbw=(5.2787e-08*t5-6.12293e-06).*t5+3.47718e-05;b0=bbw+ee1*salin;dd1=1.91075e-04;
    c11=(-1.6078e-06*t5-1.0981e-05).*t5+0.0022838;
    aw=((-5.77905e-07*t5+1.16092e-04).*t5+1.43713e-03).*t5-0.1194975;
    a0=(dd1*sr+c11).*salin+aw;
    b1=(-5.3009e-04*t5+0.016483).*t5+0.07944;
    aa1=((-6.167e-05*t5+0.0109987).*t5-0.603459).*t5+54.6746;
    tmp=((-5.155288e-05*t5+1.360477e-02).*t5-2.327105);
    kw=(tmp.*t5+148.4206).*t5-1930.06;
    ko=(b1.*sr+aa1).*salin+kw;
    %    %{ evaluate pressure polynomial
    %        k equals the secant bulk modulus of seawater
    %        dk= k(s,t,p)-k(35,0,p)
    %        k35=k(35,0,p)}
    dk=(b0.*pbar+a0).*pbar+ko;
    k35=(5.03217e-05*pbar+3.359406).*pbar+21582.27;gam=pbar./k35;pk=1-gam;
    sva=sva.*pk+(v350p+sva).*pbar.*dk./(k35.*(k35+dk));
    %    %{scale specific vol. anomaly to normally reported units}
    svan=sva*1.0e+08;v350p=v350p.*pk;
    %    %{compute density anomaly with respect to 1000.0 kg/m**3
    %     1) dr350: density anomaly at 35, 0 deg. c and  0 decibars
    %     2) dr35p: density anomaly 35, 0, pressure variation
    %     3) dvan:  density anomaly variations involving specific vol. anomaly
    %     check value: sigma = 59.82037 kg/m**3 for s=40, t=40 c, po= 10000 decibars}
    dr35p=gam./v350p;dvan=sva./(v350p.*(v350p+sva));sigma=28.106331+dr35p-dvan;
end;

return;
