function [] = vpraqplotsrpaz(dtime,pr,bz,flow,roll,pitch,alt)
%vpraqplotsrpaz.m  plots vpr along-path and vertical speeds, roll, piteh, altimetry, and bottom depth (from ship).
%figure(3); clf;
%orient tall;

ww=0.35;wh=0.28;
axes('position',[0.1,0.7,ww,wh]); % along-path speed (knots): 
                                  % the calibration factor was approximated
                                  % from ship thru water speed on en292 

%plot(dtime,flow,'.');
plot(dtime,flow);
ylabel('Flow Rate');
set(gca,'xticklabel','');

vvel=runave(diff(pr),10)*.023;
axes('position',[0.1,0.4,ww,wh]); % vvel
%plot(dtime(1:length(vvel)),vvel,'.');
plot(dtime(1:length(vvel)),vvel);
ylabel('Vertical velocity');
set(gca,'xticklabel','');
axissnug;

axes('position',[0.1,0.1,ww,wh]);  % roll
% plot(dtime,roll,'.');
plot(dtime,roll);
xlabel('Yearday');
ylabel('Roll');
axissnug;

axes('position',[0.55,0.7,ww,wh]);  % pitch
%plot(dtime,pitch,'.');
plot(dtime,pitch);
ylabel('Pitch');
set(gca,'xticklabel','');
axissnug;

axes('position',[0.55,0.4,ww,wh]);  % altimeter (m)
%plot(dtime,alt,'.');
plot(dtime,alt);
ylabel('Altimeter');
set(gca,'xticklabel','');
axissnug;


axes('position',[0.55,0.1,ww,wh]);  % bottom depth (m)
%plot(dtime,bz,'.');
if median(bz)>0,
    bz=-bz;
end
plot(dtime,bz);
xlabel('Yearday');
ylabel('Bottom Depth (m)');
hold on;
plot(dtime,pr,'w.','markersize',3);
axissnug;






