function [salt] = salt_comp2(Cndt,Tmpt,Prss)

     
%from Seascan's deck.exe for the flying fish, used on Knorr172 to create
%vprlog files
% __inline double CalcSalt( double Cndt, double Tmpt, double Prss )
% {
% 
% // constants used in calculating salinity from conductivity temperature and pressure
% // Conductivity in mmho/cm  , Press in decibars, Temperature in deg C.
% 	double a1, a2, a3, b1, b2, b3, b4, c0, c1, c2, c3, c4 ;
% 	double e1, e2, e3, e4, e5, e6, d1, d2, d3, d4, d5, d6 ;
% 	double  k, q1, q2, q3, tz ;
     a1=0.0000207; a2=-6.37e-10; a3=3.989e-15 ;
	 b1=0.03426; b2=0.0004464; b3=0.4215; b4=-0.003107 ;
	 c0=0.6766097; c1=0.0200564; c2=1.104259e-04; c3=-6.9689e-07; c4=1.0031e-09 ;
	 d1=0.0005; d2=-0.0056; d3=-0.0066; d4=-0.0375; d5=6.360001e-02; d6=-0.0144 ;
     e1=8.000001e-03; e2=-0.1692; e3=25.3851; e4=14.0941; e5=-7.0261; e6=2.7081 ;
	 k=0.0162; q1=2.5; q2=1.5; q3=0.5; tz=15;
%     // salinity computation
% 	double r, al, rt, lrt, s, s1, s2 ;
             r=Cndt/42.914;
             al=(a1+(a2+a3*Prss)*Prss)*Prss;
             al=al/(1 + (b1 + b2*Tmpt)*Tmpt + b3*r + b4*Tmpt*r);
             rt=c0+(c1 + (c2+ (c3 + c4*Tmpt)*Tmpt)*Tmpt)*Tmpt;
             rt=r/(rt*(1+al));
			 lrt=log(rt);
             s=e1+e2*exp(q3*lrt)+e3*rt+e4*exp(q2*lrt)+e5*rt*rt+e6*exp(q1*lrt);
             s1=d1+d2*exp(q3*lrt)+d3*rt+d4*exp(q2*lrt)+d5*rt*rt+d6*exp(q1*lrt);
             salt=s+((Tmpt-tz)/(1+k*(Tmpt-tz)))*s1;
%    	return s2 ;
% }
% 
% /*	 Cndt=42.914;
% 	 Prss=0;
% 	 Tmpt=15.00; //For test only, result should be 35.000
% */
% 
