function []=resizecurt;
ah=get(gcbf,'children');
xs2=floor(get(ah(3),'value'))+1;
xs1=floor(get(ah(4),'value'))+1;
objh=get(ah(1),'children');
eval(['cd tmp; load curtdat' num2str(gcbf) '; cd ..']);
tpdindex=round(1:(length(x1data)-1)/(nx-1):length(x1data));%index array for towpath data
tpd1=tpdindex(xs1);if xs1>1,tpd1=tpdindex(xs1-1);end;if xs1>2,tpd1=tpdindex(xs1-2);end;
tpd2=tpdindex(xs2);if xs2<nx,tpd2=tpdindex(xs2-2);end;
if xs2>xs1,
  set(objh(1),'xdata',x1data(tpd1:tpd2),'ydata',y1data(tpd1:tpd2),'zdata',z1data(tpd1:tpd2));
  set(objh(2),'cdata',cdata(:,xs1:xs2),'xdata',xdata(:,xs1:xs2),'ydata',ydata(:,xs1:xs2),'zdata',zdata(:,xs1:xs2));
end
