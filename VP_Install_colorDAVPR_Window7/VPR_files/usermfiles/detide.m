function [ut,vt] = detide(x,y,t)
%
% function [ut,vt] = detide(x,y,t)
%
% function to calculate an approximation to the barotropic 
% (depth average) tidal currents over Georges Bank.
%
% Input:
% x = longitude in decimal degrees (W negative).
% y = latitude in decimal degrees.
% t = GMT (UTC) time in hours from 00:00 /1/1/94 
%     (previous times to this date must be negative.)
%
% Output:
% ut = east component of tidal current at (x,y,t) (m/s).
% vt = north component of tidal current at (x,y,t) (m/s).
%
% To avoid exceding the area were the detiding can be performed the
% routine will returned a NaN value for (ut,vt) if tidal currents are
% requested for a location outside its validity area.
%
% if you have questions contact:
% Julio Candela at WHOI
% tel (508) 548-1400 x2907
% e-mail julio@mar.whoi.edu

% four tidal constituent are included, i.e., M2, S2, N2 and K1.
% the analysis is based on a polynomial interpolation of the tidal 
% ellipse parameters for this four constituents based on shipboard ADCP 
% data from the Globec cruises in Georges Bank during 1994 and 1995.
% Improvements are expected as more data becomes available and 
% is incorporated into the analysis.
%
% this routine can be obtained through anonymous ftp to
% mar.whoi.edu or 128.128.28.124 
% in directory /globec/detide
% You should copy all files in the directory for the function to work.
%
%  Example values are:
%
%  for: 
%  x = -67.87 (degrees)
%  y = 40.83  (degrees)
%  t = 9948.0 (i.e., 00:00/20/02/95 GMT (UTC)) (hours)
% 
%  (ut,vt) = (-0.1544,-0.3178) (m/s)
%
%                                                      JC XII/95.
%

% load coefficients from analysis [cut,cvt,nf,pt].
  load ctotal

% make sure x,y & t are column vectors
x = x(:); y = y(:); t = t(:); 

    for k=1:nf
      s = ['Mt',num2str(k)];
      eval([s,'= matpold(x,y,pt(k),0);']);
      ss = ['size(',s,')']; [mt(k),nt(k)]=eval(ss); 
   end

%
% construct matrix chosing the number (nf)
% of tidal frequencies (f) (in cyc/h) to include in the analysis.
% freq = [m2=.08051140, s2=.08333333, n2=0.07899925, k1=.04178075, o1=.03873085]
%
 freq = [.08051140 .08333333 0.07899925 .04178075 .03873085];
 tidnam = ['M2';'S2';'N2';'K1';'O1'];

 for k=1:nf, w(k) = 2*pi*freq(k); 
  eval(['tt',num2str(k),'c=cos(w(k).*t);']);
  eval(['tt',num2str(k),'s=sin(w(k).*t);']);

  eval(['tt',num2str(k),'c=tt',num2str(k),'c(:,ones(1,nt(',num2str(k),')));']);
  eval(['tt',num2str(k),'s=tt',num2str(k),'s(:,ones(1,nt(',num2str(k),')));']);

 end

% Construct model matrix
% u part

 au = [];
for k=1:nf
 eval(['tema=[Mt',num2str(k),'.*tt',num2str(k),'c,Mt',num2str(k), ...
'.*tt',num2str(k),'s];']);
 au = [au,tema];
end

% v part
 av = au;

[ma,na]=size(au);

 ut = au*cut; 
 vt = av*cvt;

% blanking polygon

load poligono
Bnan = inside(x,y,xpoly,ypoly);

ut = ut.*Bnan; vt = vt.*Bnan;
