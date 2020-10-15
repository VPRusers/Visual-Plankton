nameold=name;
name=[name 'biomass'];
eval(['cd tmp; load ' name '.grd; cd ..']);
eval([name '(find(' name '==-999))=NaN*ones(size(' name '(find(' name '==-999))));']);
eval([name '(find(' name '<0))=zeros(size(' name '(find(' name '<0))));']);
figure(20);
colormap(cmap4(1,30));
cm=colormap;

eval(['surf(x,y,z,' name ');shading interp;']);
view(-176,73);
hold on;
plot3(lon,lat,press(:,2),'w');%towyo path
set(gca,'position',[.2 .1 .7 .8]);
title(['\bf' titlename ' \rm \mugC/liter']);
asprat=get(gca,'dataaspectratio');
axis vis3d;
set(gca,'dataaspectratio',[asprat(1:2) asprat(3)*2]);
view3d rot;

eval(['mm=[min(min(' name '(~isnan(' name '))));max(max(' name '(~isnan(' name '))))];']);
mm2=[(mm(1):(mm(2)-mm(1))/10:mm(2))',(mm(1):(mm(2)-mm(1))/10:mm(2))']; 
caxis(mm');

name=nameold;

%side flag--
axes('position',[0.885 0.67 0.02 0.17])
pcolor(mm2)
set(gca,'fontname','times')
set(gca,'yticklabel','','xticklabel','');
text(2.0,11.5,num2str(round(mm(2)*100)/100),'fontname','times','fontsize',14)
text(2.0,.4,num2str(round(mm(1)*100)/100),'fontname','times','fontsize',14)
set(gca,'position',[0.885 0.75 0.02 0.17])

h=get(gcf,'children');axes(h(2));
objh=get(h(2),'children');
cdata=get(objh(2),'cdata');
xdata=get(objh(2),'xdata');
ydata=get(objh(2),'ydata');
zdata=get(objh(2),'zdata');
eval(['save tmp/curtdat' num2str(gcf) ' xdata ydata zdata cdata']);

uicontrol('Style','slider','Min',0,'Max',nxgrd-1,'position',[20 20 100 20],'callback','resizebugcurt');
uicontrol('Style','slider','Min',0,'Max',nxgrd-1,'position',[20 40 100 20],'value',nxgrd-1,'callback','resizebugcurt');

