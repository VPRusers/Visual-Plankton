function []=vpraqplotctdftlt(dtime,t,s2,sigma,fluo,obs,light);
%vpraqplotctdftlt  Plots vpr ctdftl vs time in 6 panels


ww=0.35;wh=0.28;
axes('position',[0.1,0.7,ww,wh]); %Temperature 
% plot(dtime,t,'.');
plot(dtime,t);
ylabel('Temperature');
%set(gca,'xticklabel','','ylim',[tmin tmax]);
set(gca,'xticklabel','');
hold on;
axissnug;

axes('position',[0.1,0.4,ww,wh]); %Salinity
% plot(dtime,s2,'.');
plot(dtime,s2);
ylabel('Salinity');
%set(gca,'xticklabel','','ylim',[salmin salmax]);
set(gca,'xticklabel','');
hold on;
axissnug;

axes('position',[0.1,0.1,ww,wh]);  %Density
% plot(dtime,sigma,'.');
plot(dtime,sigma);
xlabel('Time (Yearday)');
ylabel('Density');
%set(gca,'ylim',[densmin densmax]);
hold on;
axissnug;

axes('position',[0.55,0.7,ww,wh]);  %Fluorescence
% plot(dtime,fluo,'.');
plot(dtime,fluo);
ylabel('Fluorescence');
set(gca,'xticklabel','');
hold on;
axissnug;

axes('position',[0.55,0.4,ww,wh]);  %Attenuation
% plot(dtime,obs,'.');
plot(dtime,obs);
ylabel('OBS');
set(gca,'xticklabel','');
hold on;
axissnug;

axes('position',[0.55,0.1,ww,wh]);  %Light
% plot(dtime,light,'.');
plot(dtime,light);
xlabel('Time (Yearday)');
ylabel('Light');
hold on;
axissnug;

