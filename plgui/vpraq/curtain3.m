function [] = curtain3(b,nx,ny,vn,az,el,figh);
%function [] = curtain3(b,nx,ny,vn,az,el,figh);
%curtain plot of vprdata
%requires input of data (b), grid size (nx, ny), and variable number
%i.e., 1=temp, 2=salt, 3=sigm, 4=fluo, 5=atte, 6=light

creategrid(nx,ny,vn,b);

vs1=str2mat('temp','salt','sigm','fluo','obs','light');
vs = deblank(vs1(vn,:));
vs2=str2mat('Temperature','Salinity','Density','Fluorescence','OBS','Light');
titlevar=deblank(vs2(vn,:));

eval(['cd tmp; load ' vs '.grd; cd ..']);
cd tmp; load press; cd ..

%set(figh,'paperorientation','landscape');
%set(figh,'paperposition',[.5 .5 10. 7.5]);
colormap(cmap4(1,30));


%the following converts the zeros in the data matrix to NaN for blanking

eval([vs '(find(' vs '==-999))=NaN*ones(size(' vs '(find(' vs '==-999))));']);

ibs=1:length(press);
zmin=min(press(ibs,2));
zmax=max(press(ibs,2));
z1=zmin:(zmax-zmin)/(ny-1):zmax;
totkm=press(ibs,1);

%ratotkm=runave(totkm,20);%use runave if lat lon data is noisy
%shipdist=min(ratotkm):(max(ratotkm)-min(ratotkm))/(nx-1):max(ratotkm);
%ix=interp1(ratotkm,1:length(ratotkm),shipdist);%gets i evenly spaced in x
shipdist=min(totkm):(max(totkm)-min(totkm))/(nx-1):max(totkm);
ix=interp1(totkm,1:length(totkm),shipdist);%gets i evenly spaced in x

lon=b(ibs,3);lat=b(ibs,2);

i=nx;j=ny;x=[];y=[];z=[];
x1=lon(round(ix))';
y1=lat(round(ix))';
z1=z1';
for k=1:j;x=[x;x1];y=[y;y1];end;
for k=1:i;z=[z z1];end;


eval(['surf(x,y,z,' vs ');shading interp;']);
view(az,el);
%view(30,80);
ah=gca;
hold on;

towpathhandle=plot3(lon,lat,press(:,2),'w','visible','off');%towyo path

set(gca,'position',[.2 .1 .7 .8]);
axis equal;
asprat=get(gca,'dataaspectratio');
%set(gca,'dataaspectratio',[1 1 500]);
set(gca,'dataaspectratio',[asprat(1:2) asprat(3)*1000]);

axis manual;
axis tight;
%axis normal;
axis vis3d;
hold off;

eval(['mm=[min(min(' vs '(~isnan(' vs '))));max(max(' vs '(~isnan(' vs '))))];']);
if isempty(mm),
    mm=[0 1];
    xlabel('NO DATA','fontsize',14,'color',[1 .8 0]);
end
mm2=[(mm(1):(mm(2)-mm(1))/10:mm(2))',(mm(1):(mm(2)-mm(1))/10:mm(2))']; 
caxis(mm');

%side flag--
axes('position',[0.885 0.67 0.02 0.17])
pcolor(mm2)
set(gca,'fontname','times')
set(gca,'yticklabel','','xticklabel','');
text(2.0,11.5,num2str(round(mm(2)*100)/100),'fontname','times','fontsize',14)
text(2.0,.4,num2str(round(mm(1)*100)/100),'fontname','times','fontsize',14)
set(gca,'position',[0.885 0.75 0.02 0.17])


h=get(figh,'children');
axes(h(2))
objh=get(h(2),'children');
x1data=get(objh(1),'xdata');
y1data=get(objh(1),'ydata');
z1data=get(objh(1),'zdata');
cdata=get(objh(2),'cdata');
xdata=get(objh(2),'xdata');
ydata=get(objh(2),'ydata');
zdata=get(objh(2),'zdata');
eval(['save tmp/curtdat' num2str(figh) ' xdata ydata zdata cdata x1data y1data z1data nx']);

uicontrol('Style','slider','Min',0,'Max',nx-1,'units','normalized','position',[0.0292308 0.0322034 0.153846 0.0338983],'callback','resizecurt');
uicontrol('Style','slider','Min',0,'Max',nx-1,'units','normalized','position',[0.0292308 0.0661017 0.153846 0.0338983],'value',nx-1,'callback','resizecurt');
%uicontrol('Style','slider','Min',0,'Max',nx);
uicontrol('Style','togglebutton','units','normalized','position',[0.0523077 0.00508475 0.115385 0.0254237],'value',0,'string','toggle towpath','callback','toggletowpath');
axes(ah);%makes current axes the curtain plot so that vpraqparsedplot puts the title in the right place.
%mver=version;if strcmp(mver(1),'5'),clickmove;set(figh,'doublebuffer','off');end
%clickmove;set(figh,'doublebuffer','off');
cameratoolbar('show');
cameratoolbar('setmode','orbit');
