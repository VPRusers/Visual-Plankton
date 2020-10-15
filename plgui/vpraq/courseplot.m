function [] = courseplot(dtime,pcodelat,pcodelon)

global cruise

if strcmp(cruise(1:3),'ast'),
    load ccbcoast.dat
    x=ccbcoast(:,1); y=ccbcoast(:,2);
    plot(x,y,'linewidth',2);
    set(gca,'linewidth',2);
    hold on;
    axis([-70.7 -70 41.7 42.2]);
end

%lon=pcodelon;lat=pcodelat;
%dlon=max(lon)-min(lon);dlat=max(lat)-min(lat);
%axis([min(lon)-0.1*dlon max(lon)+0.1*dlon min(lat)-0.1*dlat max(lat)+0.1*dlat]);

set(gca,'position',[.2 .1 .7 .8]);
%set(gca,'xdir','reverse','box','on');
%set(gca,'ytick',[42 42.5]);
%set(gca,'xtick',[70 70.5 71]);
%set(gca,'yticklabel',['42' setstr(176) '00' setstr(180); '42' setstr(176) '30' setstr(180)]);
%set(gca,'xticklabel',['70' setstr(176) '00' setstr(180);'70' setstr(176) '30' setstr(180);'71' setstr(176) '00' setstr(180)]);
set(gca,'tickdir','out')

plot(pcodelon,pcodelat,'w+','markersize',2);
axis tight;
hold on;

ax=axis;
axrat=1/cos(mean(ax(3:4))*pi/180);
set(gca,'dataaspectratio',[1 1/axrat 1]);

hours=floor((dtime-floor(dtime))*24);
ihours=find(diff(hours)~= 0);
plot(pcodelon(ihours+1),pcodelat(ihours+1),'b.','markersize',5);
text(pcodelon(ihours+1),pcodelat(ihours+1),[num2str(hours(ihours+1)) blanks(length(ihours))'],'horizontalalignment','right','fontsize',10,'color','g');

plot(pcodelon(length(pcodelon)),pcodelat(length(pcodelat)),'y.','markersize',20);

title(['Ship Track']);
set(get(gca,'title'),'fontsize',12);
%axis equal;
