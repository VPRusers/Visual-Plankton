
From shi@bnlpo.das.bnl.gov Fri Jan 12 13:38 EST 1996
From: "Yan Shi" <shi@bnlpo.das.bnl.gov>
Date: Fri, 12 Jan 1996 13:41:35 -0500
To: carin@plankton.whoi.edu
Subject: globec_tidal.m file
Mime-Version: 1.0

Hi Carin,

Here is the globec_tidal.m file. The difference between this file and the
original file is the data input part. It is unclear to me if you have the data
you need. Anyways I will try to find the data and email it to you.

Good luck

Yan

******************************************************************
 clear
% Script file to extract the tidal and steady current fields
% from a ship-board ADCP survey of a given region.
%
% for details see: Candela et al., 1992, "Separation of tidal and ..."
%                  JGR, 97 C1, 769-788.
%
% for MATLAB 4.0,      Julio Candela, VII/1993. (WHOI).
%

% if metros=1, no scaling is used
% prt = 1, for hardcopy plots.
% prtps = 1, for saving plots in postscript files.
% vel = 1, to fit vertically averaged velocity instead of transport.
% nf = # of tidal constituents to consider. You can use up to 2 (M2 and S2)
%      or 4 (M2,S2,K1 and O1), however you'll have to augment arrays "vu, fan"
%      with the proper numbers for these diurnal constituents using program
%      gphase.f
% pm = polynomial degree for steady part.
% pt = polynomial degree for each tidal constituent to consider.
% icontran = 1, to draw contours of tidal ellipse components instead of axes.

 metros=0;
 prt=0;
 prtps=0;
 vel=1;
 nf=1; pm = 2; pt=[2,0]; nt(1:4)=zeros(1,4); %
 icontran=0;
 orient landscape;
%
% phase of the tidal potential analysed constituents w.r.t. the
% Greenwich meridian. vu = vu /(2*pi),
% include also amplitude modulation fan,
% Use the fortran program "gphase.f" to calculate these numbers
% for a different time reference. If you use the numbers given below
% your data should have as time reference 0h , 0d, Jan, 1991.
%
% (M2,S2) for time reference (0,0,1,93) [i.e., (h,d,m,y) UT]
%         and for xlat = 41.

 vu = [-.4383293, -.000327218];% vu = [0,0] % for no Greewich phase correction.
 fan = [1. , 1.];

%***************************************************************************
% Change here to set the scales, min and max values, and load in the data

% constants
% define scales and labels for plots

if vel,
 scale= 10; stext='50 cm/s'; svec=.5;
 seli= 6; stexeli='1.0 m/s'; sveli=.5;
 sscale= 30; sstext='20 cm/s'; ssvec=.2;
else

 scale= .04; stext='50 m^2/s'; svec=50.;
 seli= .04; stexeli='100 m^2/s'; sveli=50.;
 sscale= .2; sstext='20 m^2/s'; ssvec=20.;
end

% scales
% xymax = longitude and latitude range of plots.
% xloref = reference longitude.
% ylaref = reference latitude.
% xloesc = length in 1.e-6 m of a minute in longitude at the mean latitude
%          of the surveyed area.
% ylaesc = length in 1.e-6 m of a minute in latitude at ...

  xmin=-71;xmax=-64.5;ymin=39.5;ymax=43.2;
  xtickmark=[-71 -70 -69 -68 -67 -66 -65];
  ytickmark=[40 41 42 43];

  xymax=[xmin xmax ymin ymax];
  xloref = xmin ; ylaref = ymin;

% load ADCP measured transports

t=[];x=[];y=[];h=[];u=[];v=[];

%% load data
%
% data file should consist of the columns [t,x,y,u,v,h];
% where:
% t = time (in hours) of ADCP averaged observation according to the time
%     reference chosen.
% x = scaled x coordinate in 1.e-6 meters from "xloref".
% y = scaled y coordinate in 1.e-6 meters from "ylaref".
% u = East component of observed transport in [m^2/s].
% v = North component of transport in [m^2/s].
% h = local water depth recorded by ADCP and averaged the same as the current
%     profiles to obtain u and v.


CruiseID=input('Cruise name:','s');
eval(['load ' CruiseID '_uv']);
eval(['load ' CruiseID '_xy']);
cruise=upper(eval('CruiseID'));
n=length(uv(1,:));
uvel=uv(:,1:2:n);
vvel=uv(:,2:2:n);
ndepth=length(z);
dz0=z(2:ndepth)-z(1:ndepth-1);
inan=find(isnan(uvel) | abs(uvel) > 0.4 | abs(vvel) > 0.35);
uvel(inan)=0*ones(size(inan));
vvel(inan)=0*ones(size(inan));
for it=1:n/2
 iz=find(uvel(:,it)~=0);
 izz=find(uvel(:,it)==0);
 dz(iz,it)=dz0(iz);
 dz(izz,it)=0*ones(size(izz));
 htemp(it)=sum(dz(:,it));
end
htemp=htemp';
utemp=diag(uvel'*dz);
vtemp=diag(vvel'*dz);
xgtemp=xyt(1,:)'-360;
ygtemp=xyt(2,:)';
ttemp=xyt(3,:)'*24;
igd=find(ygtemp~=0 & htemp > 0);
h=htemp(igd);
u=utemp(igd);
v=vtemp(igd);
xg=xgtemp(igd);
yg=ygtemp(igd);
t=ttemp(igd);

title1=['ADCP data from GLOBEC ' cruise]

% End of change here
%****************************************************************************

% Here data from other surveys and/or current meter moored observations can be
% added, however all data has to have the same time origen.

if vel, u=u./h; v=v./h; end

  lat=yg; lon=xg;
ilat=find(~isnan(lon));
alat=mean(lat(ilat));
f=cos(pi*alat/180);

v2h=(ymax-ymin)/(xmax-xmin)/f;
if(v2h <= 0.75)
  position = [0.15 0.12 0.70 0.9334*v2h];
else
  position = [0.15 0.12 0.5346/v2h 0.7128];
end

ylaesc = .111052 ; xloesc = ylaesc*f ;
x=(xg-xloref.*ones(size(xg))).*xloesc;
y=(yg-ylaref.*ones(size(yg))).*ylaesc;
% lat = (y./ylaesc) + ylaref.*ones(size(y));
% convert to geographical coordinates for plotting
% xg = (x./xloesc) + xloref.*ones(size(x));
% yg = (y./ylaesc) + ylaref.*ones(size(y));

 ntran=length(t);

% plot data locations
% georbat is a script file that plots coastlines and bathymetric contours
% of the surveyed area and holds the screen.

 figure (1); georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
 plot(xg,yg,'w.'),title(title1)
 xlabel('Longitude'), ylabel('Latitude'),grid
 hold off; pause(3)
   if prt, orient landscape,  print, end
   if prtps, print data_location -dps, end

% plot raw data vectors
 figure(2), georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
 xlabel('Longitude')
 ylabel('Latitude')
 if vel,title(['Observed vertically averaged hourly current vectors']),
 else,
 title(['Observed 10 min average transport vectors']), end
 hold off,
x1=(xmax-xloref.*ones(size(xg))).*xloesc;
x2=(xmin-xloref.*ones(size(xg))).*xloesc;
dx=abs(x2-x1);
dx=dx(1);
y1=(ymax-ylaref.*ones(size(yg))).*ylaesc;
y2=(ymin-ylaref.*ones(size(yg))).*ylaesc;
dy=abs(y2-y1);
dy=dy(1);
axh=axes('xlim',[0 dx],'ylim',[0 dy], ...
'position',position,'Visible','off');
 hold on
 pltvec4(x,y,u,v,scale,[0 1 0 1],'g-')
 scavec4(0.8*dx,0.2*dy,svec,stext,scale,[0 1 0 1],dx,dy)
 hold off
 pause(3)
 if prt, orient landscape,  print, end
 if prtps, print raw_uv -dps, end

% Construct model matrix elements

 Mm = matpold(x,y,pm,0);  [mm,nm]=size(Mm);

   for k=1:nf
      s = ['Mt',num2str(k)];
      eval([s,'= matpold(x,y,pt(k),0);']);
      ss = ['size(',s,')']; [mt(k),nt(k)]=eval(ss);
   end

%
% construct matrix chosing the number (nf)
% of tidal frequencies (f) (in cyc/h) to include in the analysis.
% freq = [m2=.08051140, s2=.08333333, k1=.04178075, o1=.03873085]
%
 freq = [.08051140 .08333333 .04178075 .03873085];
 Tt = zeros(ntran,nf);

 for k=1:nf, w(k) = 2*pi*freq(k);
  eval(['tt',num2str(k),'c=cos(w(k).*t);']);
  eval(['tt',num2str(k),'s=sin(w(k).*t);']);

  eval(['t',num2str(k),'c=tt',num2str(k),'c(:,ones(1,nt(',num2str(k),')));']);
  eval(['t',num2str(k),'s=tt',num2str(k),'s(:,ones(1,nt(',num2str(k),')));']);

  eval(['z',num2str(k),'=zeros(size(Mt',num2str(k),'));']);

% convert frequency to rad/sec
 w(k) = w(k)/3600;
 end

% Construct model matrix

 zm = zeros(size(Mm));

% u part

 a = [Mm;zm];
for k=1:nf
 eval(['tema=[Mt',num2str(k),'.*t',num2str(k),'c,Mt',num2str(k), ...
'.*t',num2str(k),'s;z',num2str(k),',z',num2str(k),'];']);
 a = [a,tema];
end

% v part

tema = [zm;Mm]; a = [a,tema];
for k=1:nf
 eval(['tema=[z',num2str(k),',z',num2str(k),';Mt',num2str(k), ...
'.*t',num2str(k),'c,Mt',num2str(k),'.*t',num2str(k),'s];']);
 a = [a,tema];
end


[ma,na]=size(a),
ia=find(isnan(a));
a(ia)=0*ones(size(ia));

% construct right hand side vector b

   b = [ u; v];

% solve system and plot results

 tol = 0.; [c,C,bm,cor,X,r,cond] = solsys(a,b,tol);cor
 res = b - bm;
 figure(6), clf
 plot(b,bm,'o'); grid; title('b vs. bm'); pause(3)

% define indexes for coefficients
%
% Code contributed by Lyn Harris

mum=1:nm;                                        % Steady coefficients.
mvm=mum+na/2.;

mut1c=(1:nt(1)) + mum(nm);                       % Tidal coefficients.
mut1s=(1:nt(1)) + mut1c(nt(1));
mvt1c=(1:nt(1)) + mvm(nm);
mvt1s=(1:nt(1)) + mvt1c(nt(1));

if nf > 1
  mut2c=(1:nt(2)) + mut1s(nt(1));
  mut2s=(1:nt(2)) + mut2c(nt(2));
  mvt2c=(1:nt(2)) + mvt1s(nt(1));
  mvt2s=(1:nt(2)) + mvt2c(nt(2));
  if nf > 2
    mut3c=(1:nt(3)) + mut2s(nt(2));
    mut3s=(1:nt(3)) + mut3c(nt(3));
    mvt3c=(1:nt(3)) + mvt2s(nt(2));
    mvt3s=(1:nt(3)) + mvt3c(nt(3));
    if nf > 3
      mut4c=(1:nt(4)) + mut3s(nt(3));
      mut4s=(1:nt(4)) + mut4c(nt(4));
      mvt4c=(1:nt(4)) + mvt3s(nt(3));
      mvt4s=(1:nt(4)) + mvt4c(nt(4));
    end
  end
end

% save coefficients for detiding each cruise separetly

cut = [c(mut1c);c(mut1s)]; cvt = [c(mvt1c);c(mvt1s)];
if nf==2,
cut =[cut;c(mut2c);c(mut2s)]; cvt = [cvt;c(mvt2c);c(mvt2s)];end
if nf==3,
cut =[cut;c(mut3c);c(mut3s)]; cvt = [cvt;c(mvt3c);c(mvt3s)];end
if nf==4,
cut =[cut;c(mut4c);c(mut4s)]; cvt = [cvt;c(mvt4c);c(mvt4s)];end

save ctotal cut cvt
%

% plot transport cotidal charts

 vpha=0:30:360;  vori=-360:10:360;
 if vel, vtscam=-.5:.1:.5; vtscan=0:.2:2.; else
         vtscam=-30:5:30; vtscan=0:5:50;, end
 ntc=0;
 ires=.02; xa=0:ires:1; ya=xa;
 xag = (xa./xloesc) + xloref.*ones(size(xa));
 yag = (ya./ylaesc) + ylaref.*ones(size(ya));
if metros, xa=1.e6.*xa; ya=1.e6.*ya; end
 [xx,yy]=meshgrid(xa,ya); mm=length(xx(:));
 zz=zeros(size(xx));

% blanking polygon
% poligono.mat contains the coordinates (geographical) of the vertices
% [xpoly,ypoly] of a poligon enclosing the ADCP observation points for
% ploting purposes. It can be generated from a MATLAB window having a plot
% of the surveyed area with the comand: "[xpoly,ypoly]=ginput" ; chosing the
% vertices with the mouse and then saving them: "save poligono xpoly ypoly"

 ires=.02; xel=0:ires:1; yel=xel;
if metros, xel=1.e6.*xel; yel=1.e6.*yel; end
 [xxe,yye]=meshgrid(xel,yel); mme=length(xxe(:));
 zze=zeros(size(xxe));
load poligono_globec
%xpoly=(xpoly-xloref.*ones(size(xpoly))).*xloesc;
%ypoly=(ypoly-ylaref.*ones(size(ypoly))).*ylaesc;
if metros, xpoly=1.e6.*xpoly; ypoly=1.e6.*ypoly; end
Bnan = inside(xxe,yye,xpoly,ypoly);
 xelg = (xxe(:)./xloesc) + xloref.*ones(size(xxe(:)));
 yelg = (yye(:)./ylaesc) + ylaref.*ones(size(yye(:)));

for k=1:nf;

 DA=matpold(xx(:),yy(:),pt(k),0);
 DE=matpold(xxe(:),yye(:),pt(k),0);

% tidal ellipse chart

 mutc = eval(['mut',num2str(k),'c']); muts = eval(['mut',num2str(k),'s']);
 mvtc = eval(['mvt',num2str(k),'c']); mvts = eval(['mvt',num2str(k),'s']);
 ut = DA*real(c(mutc))+ i.*DA*real(c(muts));
 vt = DA*real(c(mvtc))+ i.*DA*real(c(mvts));
 wp = .5.*(abs(ut).*exp(-i.*angle(ut)) + i.*abs(vt).*exp(-i.*angle(vt)));
 wm = .5.*(abs(ut).*exp(i.*angle(ut)) + i.*abs(vt).*exp(i.*angle(vt)));
 awp = abs(wp) / fan(k);
 awm = abs(wm) / fan(k);
 gwp = (-angle(wp)./(2*pi)) + vu(k).*ones(size(wp)); gwp=degree4(gwp);
 gwm = (angle(wm)./(2*pi)) + vu(k).*ones(size(wm));  gwm=degree4(gwm);
 ngwm = find(gwm < gwp);
 if ~isempty(ngwm), gwm(ngwm)=gwm(ngwm)+360;end

% plot phase of ellispe first

 zz(:) = .5.*(gwm+gwp)+180.;
 figure(3), georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
 cs=contour(xag,yag,zz,vpha); clabel(cs); %; clabel(cs,'manual');
 title(['Phase of ellipse (UT) frequency ',num2str(freq(k)),' (cyc/h)']),
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
 hold off; pause (3)
 if prt, orient landscape,  print, end
 if prtps, print phase -dps, end

if icontran,
 zz(:) = awp + awm;
 figure(4), georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
 cs=contour(xag,yag,zz,vtscan); clabel(cs);
if vel, title(['Semi-major axis (vertically averaged current m/s) ', ...
num2str(freq(k)),' (cyc/h)']),
else, title(['Semi-major axis (transport m^2/s) ',num2str(freq(k)),'
(cyc/h)']), end
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
 hold off; pause(3)
if prt, orient landscape,  print, end
if prtps, print major_axis -dps, end

 zz(:) = awp - awm;
 figure(5), georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
  cs=contour(xag,yag,zz,vtscam); clabel(cs);
if vel, title(['Semi-minor axis (vertically averaged current m/s) ', ...
num2str(freq(k)),' (cyc/h)']),
else,title(['Semi-minor axis (transport m^2/s) ',num2str(freq(k)),'
(cyc/h)']),end
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
 hold off, pause(3)
if prt, orient landscape,  print, end
if prtps, print minor_axis -dps, end

 zz(:) = .5.*(gwm-gwp);
 figure(6), georbat;
 set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
 set(gca,'xtick',xtickmark)
 set(gca,'ytick',ytickmark)
 cs=contour(xag,yag,zz,vori);  clabel(cs); hold on,
 title(['Orientation of ellipse (w.r.t. east) frequency ', ...
num2str(freq(k)),' (cyc/h)']),
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
 hold off, pause(3)
if prt, orient landscape,  print, end
if prtps, print ellipse_oren -dps , end

else

% plot tidal ellipse axis at specified points (xp,yp)

 ut = DE*real(c(mutc))+ i.*DE*real(c(muts));
 vt = DE*real(c(mvtc))+ i.*DE*real(c(mvts));
 wp = .5.*(abs(ut).*exp(-i.*angle(ut)) + i.*abs(vt).*exp(-i.*angle(vt)));
 wm = .5.*(abs(ut).*exp(i.*angle(ut)) + i.*abs(vt).*exp(i.*angle(vt)));
 awp = abs(wp) / fan(k);
 awm = abs(wm) / fan(k);
 gwp = (-angle(wp)./(2*pi)) + vu(k).*ones(size(wp)); gwp=degree4(gwp);
 gwm = (angle(wm)./(2*pi)) + vu(k).*ones(size(wm));  gwm=degree4(gwm);
 ngwm = find(gwm < gwp);
 if ~isempty(ngwm), gwm(ngwm)=gwm(ngwm)+360;end
 orip = .5.*(gwm-gwp);

figure(4), georbat;
%
if vel,
 title(['Vertically average tidal current ellipse constituent
',num2str(freq(k)),' (cyc/h)']),
else
 title(['Tidal transport ellipse constituent ',num2str(freq(k)),' (cyc/h)']),
end
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
  set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
  set(gca,'xtick',xtickmark)
  set(gca,'ytick',ytickmark)
 hold off;
 axh=axes('xlim',[0 dx],'ylim',[0 dy], ...
'position',position,'Visible','off');
 hold on
 pltpax4(xxe(:).*Bnan(:),yye(:),(awp+awm),awp-awm,seli,[0 1 0 1],orip,'r');
 scapax4(.8*dx,.2*dy,sveli,stexeli,seli,[0 1 0 1],'r')
 hold off, pause(3)
 if prt, orient landscape,  print, end
 if prtps, print ellipse -dps, end
end
end

% plot steady field

steady=1;
if steady

 DE=matpold(xxe(:),yye(:),pm,0);
 u0 = DE*c(mum); v0 = DE*c(mvm);
 figure(7), clf; georbat;
if vel, title(['Steady vertically averaged currents']), else
title(['Steady transports']), end
  xlabel([cruise,', pm=',num2str(pm), ...
' pt(',num2str(pt(1)),',',num2str(pt(2)),'), #data = ',num2str(ntran)])
 ylabel(['corr= ',num2str(cor)])
  set(gca,'xlim',[xmin xmax],'ylim',[ymin ymax],'position',position)
  set(gca,'xtick',xtickmark)
  set(gca,'ytick',ytickmark)
  hold off,
 axh=axes('xlim',[0 dx],'ylim',[0 dy], ...
'position',position,'Visible','off');
 hold on
 pltvec4(xxe(:).*Bnan(:),yye(:),u0,v0,sscale,[0 1 0 1],'g-')
 scavec4(.8*dx,0.2*dy,ssvec,sstext,sscale,[0 1 0 1],dx,dy)
 hold off
 pause(1)
 if prt, orient landscape,  print, end
 if prtps, print steady_trans -dps, end
end


