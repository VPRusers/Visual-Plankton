function [] = readparse_ctddat_files(basepathcruise,fn)

%reads ctd.dat files for the selected vpr tow (fn in this case is the vpr#
%selected from the PLplot window).

global b b_column_headings fps

days=dir([basepathcruise, filesep,'rois',filesep,fn,filesep,'d*']);
dayarray=str2mat(days.name);
dayarray=dayarray([days.isdir]',:);
sd=size(dayarray,1);
%read the hourly ctd.dat files
a=[];fps=[];
for j=1:sd,
    hours=dir([basepathcruise, filesep,'rois',filesep,fn,filesep,deblank(dayarray(j,:)),filesep,'h*ctd.dat']);
    hourarray=str2mat(hours.name);
    sd2=size(hourarray,1);
    dayn=str2num(dayarray(j,2:4));
    for k=1:sd2,
        c=ctdread([basepathcruise, filesep,'rois',filesep,fn,filesep, ...
            deblank(dayarray(j,:)),filesep,hourarray(k,:)])';
        c=c(sum(c,2)~=0,:);%gets rid of rows with all zero entries
        seconds=floor(c(:,1)/1000);%only need 1-s data, so ignore milliseconds
        si=find(diff(seconds));%seconds index - 1, i.e., diff=1 at index before new second
        fps=[fps; si(1); diff(si)];%frames per second = lines per second in the ctd.dat file
        si=[1;si+1];%index of new second
        %compute mean values of sensor data for each second; variables in c array are:
        %Time (s & ms), Conductivity, Temperature, Pressure, Salinity, ChloroRef, ChloroSig, TurbRef, TurbSig, Altitude
        %(ignore time column, use seconds array, and ignore conductivity,
        %use salinity output by sensor)
        for n=1:(length(si)-1),
            a=[a; [dayn+seconds(si(n))/86400 mean(c(si(n):si(n+1),[3:5 7 9:10]))]];
        end
    end
end
a=[a [1:size(a,1)]'];%add a column for the row index, to keep track of rows deleted during editing/cropping

%Run stca (modified for new autovpr, input t, p, s to compute sigma-t
[p,t,theta,s,sigma]=stca_autovpr(a(:,2),a(:,3),a(:,4));% note this routine also sets p(p<0)=0;

p=-p;%make depth negative
npts=size(a,1);
b=[a(:,1) zeros(npts,2) p t s sigma a(:,5:6) zeros(npts,3) fps a(:,8) a(:,7)];
b_column_headings=str2mat('1  time           Decimal yearday in GMT starting with Jan 1 as day 0', ...
                          '2  latitude       From ship GPS, negative values are Western hemisphere',...
                          '3  longitude      Longitude (from ship GPS), negative values are Southern hemisphere',...
                          '4  depth          Depth of VPR in negative meters from VPR CTD',...
                          '5  temperature    Temperature of seawater in oC from VPR CTD',...
                          '6  salinity       Salinity (unitless~=PSU and o/oo) from VPR CTD',...
                          '7  density        Seawater density as Sigma-t, computed from t, s, and p',...
                          '8  fluorescence   raw units',...
                          '9  turbidity      Optical backscatter raw units',...
                          '10 PAR            Downwelling light from PAR sensor, micro Einsteins/cm2/sec',...
                          '11 Bottom Depth   in meters, from ship fathometer',...
                          '12 flow           from Flowmeter on VPR (needs in situ calibration)',...
                          '13 frames/row     video frames per b row (= frames per time interval)',...
                          '14 b row index    Index of original row numbers in b before editing',...
                          '15 altitude       from altimeter, meters off bottom, >99 is out of range');
