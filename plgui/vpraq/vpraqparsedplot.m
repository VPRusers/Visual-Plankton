function []=vpraqparsedplot

global HydroTimeDepthval HydroTimeval Flightval Courseplotval Planktonval Processed VPRlog CTDdat CreateDotPlotval SaveSensorDataval LoadBugDataval SaveBugDataval
global az el plotinit fps
global taxa htaxa htaxa1 basepathcruise name b b_column_headings classid nxgrd nygrd imdir cruise buginit replotval fn fhc lims
cr=setstr(13);
lf=setstr(10);
vprdata=0;
plotinit=1;
buginit=1;
SOGlobec=0;

load plotflag
basepathcruise=imdir(1:length(imdir)-8);

while (plotflag)
    
    if Processed,%load processed physical data
        eval(['load ' basepathcruise '\processed\sensordata\' fn]);
    elseif VPRlog,%load vprlog data
        eval(['fid=fopen(''' imdir fn ''')']);
        lineone=fgets(fid);fclose(fid);
        if lineone(5)==':',
            getprepdata_bobparse(imdir,cruise,fn);
        else
            getprepdata_newfish(imdir,cruise,fn);
        end
        if plotinit,
            PLplotsetup;
            waitfor(fhc);% wait until the data limits figure is closed
            limn=str2num(lims(:,4:end));
        end
        for j=4:9, b=b((b(:,j+1)>=limn(j,1)&b(:,j+1)<=limn(j,2)),:); end%crops rows in b that are outside limits
        [totkm,af,ar]=dist(b(:,2),b(:,3)); totkm=[0 totkm/1000];totkm=cumsum(totkm)';
        b=[b totkm];
        b_column_headings=str2mat(b_column_headings,'16 distance       cumulative distance traveled by ship during tow, in km');
        if SaveSensorDataval,%save processed data
            if exist([basepathcruise '\processed\sensordata'],'dir')~=7,
                dos(['mkdir ' basepathcruise '\processed\sensordata']);
            end
            fn=strrep(fn,'.','_');%replaces all '.' with '_' so fn will save as .mat file
            eval(['save ' basepathcruise '\processed\sensordata\' fn ' b b_column_headings lims']);
        end
    elseif CTDdat,
        readparse_ctddat_files(basepathcruise,fn);
        if plotinit,
            PLplotsetup;
            waitfor(fhc);% wait until the data limits figure is closed
            limn=str2num(lims(:,4:end));
        end
        for j=4:9, b=b((b(:,j+1)>=limn(j,1)&b(:,j+1)<=limn(j,2)),:); end%crops rows in b that are outside limits
        fpbr=fps(b(:,14));%frames per b row; need to correct for rows cropped during editing (in PLplotsetup)
        cnum=diff(b(:,14))-1;%number of rows cropped at each row of b
        cindx=find(cnum>0);%index where rows were cropped
        for j=1:length(cindx),%add up the total fps cropped per b time interval
            fpbr(cindx(j))=sum(fps(b(cindx(j),14):b(cindx(j),14)+cnum(cindx(j))));
        end
        b(:,13)=fpbr;%correct the 13th column of b: the frames per b row (i.e., the # video frames per time bin).
        if SaveSensorDataval,%save processed data
            if exist([basepathcruise '\processed\sensordata'],'dir')~=7,
                dos(['mkdir ' basepathcruise '\processed\sensordata']);
            end
            fn=strrep(fn,'.','_');%replaces all '.' with '_' so fn will save as .mat file
            eval(['save ' basepathcruise '\processed\sensordata\' fn ' b b_column_headings']);
        end
    end
    
    if plotinit==1,%set initial az, el
        plotinit=0;
        az=10;
        el=30;
        save azel az el;
    end
    colordef none
    
    [nxgrd,nygrd]=gridsize(b(:,4));
    if HydroTimeDepthval,
        pause(1);
        CreateDotPlotval=1;
        h=findobj('tag','plot salt');if isempty(h),figure('tag','plot salt'),h=findobj('tag','plot salt');else,figure(h),load azel;end;clf;
        if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,6)],16);else,curtain3(b,nxgrd,nygrd,2,az,el,h);end;title('\bf Salinity');set(h,'numbertitle','off','name','Salinity');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        pause(1);
        h=findobj('tag','plot dens');if isempty(h),figure('tag','plot dens'),h=findobj('tag','plot dens');else,figure(h),load azel;end;clf;
        if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,7)],16);else,curtain3(b,nxgrd,nygrd,3,az,el,h);end;title('\bf Density \rm(\sigma_t)');set(h,'numbertitle','off','name','Density');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        pause(1);
        h=findobj('tag','plot fluo');if isempty(h),figure('tag','plot fluo'),h=findobj('tag','plot fluo');else,figure(h),load azel;end;clf;
        if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,8)],16);else,curtain3(b,nxgrd,nygrd,4,az,el,h);end;title('\bf Fluorescence \rm(\mug chlorophyll a / liter)');set(h,'numbertitle','off','name','Fluorescence');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        pause(1);
        h=findobj('tag','plot obs');if isempty(h),figure('tag','plot obs'),h=findobj('tag','plot obs');else,figure(h),load azel;end;clf;
        if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,9)],16);else,curtain3(b,nxgrd,nygrd,5,az,el,h);end;title('\bf Optical Backscatter \rm(Formazin units)');set(h,'numbertitle','off','name','Optical Backscatter');
        set(h,'units','normalized','position',[.1 0 .8 .8])
%       no light sensor (PAR) on AutoVPR
%         pause(1);
%         h=findobj('tag','plot light');if isempty(h),figure('tag','plot light'),h=findobj('tag','plot light');else,figure(h),load azel;end;clf;
%         if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,10)],16);else,curtain3(b,nxgrd,nygrd,6,az,el,h);end;title('\bf PAR ');set(h,'numbertitle','off','name','Light');
%         set(h,'units','normalized','position',[.1 0 .8 .8])
        pause(1);
        h=findobj('tag','plot temp');if isempty(h),figure('tag','plot temp'),h=findobj('tag','plot temp');else,figure(h),load azel;end;clf;
        if CreateDotPlotval, xz_colordotplot([b(:,1),b(:,4),b(:,5)],16);else,curtain3(b,nxgrd,nygrd,1,az,el,h);end;title('\bf Temperature \rm(^oC)');set(h,'numbertitle','off','name','Temperature');
        set(h,'units','normalized','position',[.1 0 .8 .8]);
    end
    if HydroTimeval,
        pause(1);
        h=findobj('tag','plot env');if isempty(h),figure('tag','plot env'),h=findobj('tag','plot env');else,figure(h),end;clf;
        set(h,'numbertitle','off','name','Environmental Data');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        clf;
        vpraqplotctdftalt(b(:,1),b(:,5),b(:,6),b(:,7),b(:,8),b(:,9),b(:,15));
    end;
    if Flightval,
        pause(1);
        h=findobj('tag','plot flight');if isempty(h),figure('tag','plot flight'),h=findobj('tag','plot flight');else,figure(h),end;clf;
        set(h,'numbertitle','off','name','Flight Control Data');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        clf;
        vpraqplotsrpaz(b(:,1),b(:,4),b(:,11),b(:,12),b(:,13),b(:,14),b(:,15));
    end;
    if Courseplotval, 
        pause(1);
        h=findobj('tag','plot course');if isempty(h),figure('tag','plot course'),h=findobj('tag','plot course');else,figure(h),end;clf;
        set(h,'numbertitle','off','name','Courseplot');
        set(h,'units','normalized','position',[.1 0 .8 .8])
        clf;
        courseplot(b(:,1),b(:,2),b(:,3));

    end
    if Planktonval,
        pause(1);
        h=findobj('tag','plot bugs');if isempty(h),figure('tag','plot bugs'),h=findobj('tag','plot bugs');else,figure(h),load azel;end;clf;
        hbugs=h;
        clf;
        set(hbugs,'numbertitle','off','name','Taxon Plot');
        set(hbugs,'units','normalized','position',[.1 0 .8 .8]);
        realbugplot;
        if buginit==1,buginit=0;end;
    end
%     hcurrent=findobj('tag','plot fluo');if ~isempty(hcurrent),figure(hcurrent);end
    
    
    %ldt=length(dtime);figure(16);plot(dtime(ldt-600:ldt),-pr(ldt-600:ldt),'.-',dtime(ldt-600:ldt),-bz(ldt-600:ldt),'r.-');grid on;set(gcf,'position',[38 13 1096 116])
    
    % end     %If i
    
    if replotval==-1;
        plotflag=0;
        save plotflag plotflag;
    else
        pause(replotval) % pause for replotval seconds before repeating plotting sequence
    end
    load plotflag
    
end; %while
