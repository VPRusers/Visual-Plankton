function  plotsetup

global b tmin tmax salmin salmax densmin densmax flmin flmax obsmin obsmax maxdepth ltmin ltmax cm mmt mms mmd mmf mmo mml az el plotinit fn

if plotinit==1,%set initial az, el
    plotinit=0;
    az=10;
    el=30;
    save azel az el;
end

Plplotsetup;

maxdepth=69;


colordef none;
colormap(cmap4(1,30));
cm=colormap;

%Temperature range
tmin=0;
tmax=30;
mmt=[tmin:(tmax-tmin)/30:tmax];mmt=[mmt;mmt]';

%Salinity range
salmin=20;
salmax=40;
mms=[salmin:(salmax-salmin)/30:salmax];mms=[mms; mms]';

%Density Range
densmin=2;
densmax=37;
mmd=[densmin:(densmax-densmin)/30:densmax];mmd=[mmd; mmd]';

%Fluoresence Range
flmin=-20;
flmax=300;
mmf=[flmin:(flmax-flmin)/30:flmax];mmf=[mmf; mmf]';

%Attenuation Range
obsmin=-1.05;
obsmax=0;
mmo=[obsmin:(obsmax-obsmin)/30:obsmax];mmo=[mmo; mmo]';

%Light Range
ltmin=-25;
ltmax=1400;
mml=[ltmin:(ltmax-ltmin)/30:ltmax];mml=[mml; mml]';

%pass data matrix through min max limits
ii=find(b(:,4)>=-maxdepth & b(:,4)<=0);b=b(ii,:);
ii=find(b(:,5)>=tmin & b(:,5)<=tmax);b=b(ii,:);
ii=find(b(:,6)>=salmin & b(:,6)<=salmax);b=b(ii,:);
ii=find(b(:,7)>=densmin & b(:,7)<=densmax);b=b(ii,:);
ii=find(b(:,8)>=flmin & b(:,8)<=flmax);b=b(ii,:);
ii=find(b(:,9)>=obsmin & b(:,9)<=obsmax);b=b(ii,:);
ii=find(b(:,10)>=ltmin & b(:,10)<=ltmax);b=b(ii,:);

