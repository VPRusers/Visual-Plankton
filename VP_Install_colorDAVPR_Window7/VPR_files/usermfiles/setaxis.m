% setaxis.m
% set axis plot aspect ratio
       axis;
       lonmax=ans(2);
       lonmin=ans(1);
       latmax=ans(4);
       latmin=ans(3);
       weight=111*cos(pi*(latmax+latmin)*0.5/180);
       xc=(lonmax-lonmin)*weight;
       yc=(latmax-latmin)*111;
       relyx=yc/xc;
       set(gca,'PlotBoxAspectRatio',[1 relyx*1 1]);
       return

