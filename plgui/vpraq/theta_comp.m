function [theta] = theta_comp(salt,t,p);
%computes theta (potential temperature)

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
