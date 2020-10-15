function [] = realbugplot;


global taxa htaxa htaxa1 basepathcruise name b classid nxgrd nygrd imdir cruise buginit az el replotval fn CreateDotPlotval LoadBugDataval SaveBugDataval

p=b(:,4);
dtime=b(:,1);
lat=b(:,2);
lon=b(:,3);

fn2=fn;findx=find(fn2=='.');if ~isempty(findx),fn2=fn2(1:findx-1);end%remove file extension

basepathcruise=imdir(1:length(imdir)-8);
% basepathcruise=imdir(1:length(imdir)-13);
%cruise='shunyo';
%disc='c:/data';
eval(['load ' basepathcruise '\clpar\' classid '.mat']);
taxa=sortrows(taxas);
if strcmp(classid(end-3:end),'dual'), %if dual, check for confusion matrix
    if exist([basepathcruise '\clpar\' classid 'conf.mat']),
        eval(['load ' basepathcruise '\clpar\' classid 'conf.mat']);
        for j=1:size(conf,2),
            conf(:,j)=conf(:,j)/sum(conf(:,j))*100;
        end
        corr_fact_vec=(diag(conf)'./sum(conf'))./(diag(conf)'./sum(conf));
        %the correction factor vector is the probability of false alarm divided by the probability of detection
        %obtained from the confusion matrix built from the training rois.  The
        %confusion matrix is first normalized to 100 rois per taxon (column).
    else%if dual but no confusion matrix
        corr_fact_vec=1;
    end
else%if single classifier (nn or svm) don't do correction
    corr_fact_vec=1;
end
[image_volume, mm2pp]=compute_image_volume;

units='(number per liter)';

colormap('jet');
cm=colormap;
fh=gcf;
%set(gcf,'inverthardcopy','off');
%set(gcf,'paperorientation','landscape');
%set(gcf,'paperposition',[.5 .5 10. 7.5]);

if buginit==1;
    h=gcbf; 
    if ~isempty(h)
        h1=findobj(h,'Tag','PopupMenu SelectInitialTaxon');
        taxonindex=get(h1,'value')-1;
    end
    name=deblank(taxa(taxonindex,:));
    titlename=deblank(taxa(taxonindex,:));
    titlename(titlename=='_')=' ';%gets rid of _ so tex doesnt do a subscript
    %tdir=[basepathcruise,'\manualid\',name,'\'];
    tdir=[basepathcruise,'\autoid\',name,'\'];
    %   tdir=[disc,'/',cruise,'/autoid/',name,'/'];
    htaxa1=uimenu(fh,'label','Taxon           ');
else
    htaxa1=uimenu(fh,'label',name);
    titlename=name;
    titlename(titlename=='_')=' ';
    %tdir=[basepathcruise,'\manualid\',name,'\'];
    tdir=[basepathcruise,'\autoid\',name,'\'];
end; %if buginit
if corr_fact_vec==1,
    correction_factor=1;
else
    correction_factor=corr_fact_vec(findrow(char(name),char(taxa)));
end

htaxa=zeros(size(taxa,1),1);
for j=1:size(taxa,1),
    htaxa(j)=uimenu(htaxa1,'label',taxa(j,:),...
        'callback',...
        [['global taxa htaxa htaxa1 basepathcruise name b classid nxgrd nygrd imdir cruise buginit az el replotval CreateDotPlotval LoadBugDataval SaveBugDataval; taxon=deblank(taxa(' num2str(j) ',:)); set(htaxa1,''label'',taxon);']...
            [' tdir=[basepathcruise ''\autoid\'' taxon ''\'']; name=taxon;']...
            [' if replotval==-1, figure(gcbf); clf; buginit=0; realbugplot;end;']]);
end;


if LoadBugDataval,%load processed bug data
    
    eval(['load ' basepathcruise '\processed\bugs\binned\' name '\'  name '_' fn2 '_' classid]);
    if exist('bugsb'),aidmea=1;else,aidmea=0;end
    
else
    
    jtmin=min(dtime);
    jtmax=max(dtime);
    
    %classid='ast0003_c4v8'
    %classid='shunyo_vpr1'
    bugtime=[];
    bugarea=[];
    tday=[];
    
    a=dir([tdir 'aid\',classid,'*']);
    m=str2mat(a.name);
    tdirtmp=[];
    for j=1:size(m,1);
        tdirtmp=[tdirtmp;[tdir 'aid\']];
    end
    m=[tdirtmp m];
    len=size(m,2);

%     [s,m]=dos(['ls ' tdir 'aid/',classid,'*']);
%     len=min(find(m==10));len;
%     m=reshape(m,len,length(find(m==setstr(10))))';%matrix of hourly aid filenames
    ftime=str2num(m(:,(len-6):(len-4)))+str2num(m(:,(len-1):(len)))/24;
    if strcmp(cruise,'hydrographer_presbitero'),
        ftime=ftime+4/24;
    end
    i=find(ftime>=jtmin-1/24 & ftime<=jtmax);
    
    aidmea=exist([tdir 'aidmea\']);
    if aidmea,
%         [s,mb]=dos(['ls ' tdir 'aidmea/',classid,'*']);
%         lenb=min(find(mb==10));
%         mb=reshape(mb,lenb,length(find(mb==setstr(10))))';%matrix of hourly aidmea filenames
%         mb=mb(:,1:end-1);%gets rid of return character in last column
    a=dir([tdir 'aidmea\',classid,'*']);
    mb=str2mat(a.name);
    tdirtmp=[];
    for j=1:size(mb,1);
        tdirtmp=[tdirtmp;[tdir 'aidmea\']];
    end
    mb=[tdirtmp mb];
    end
    
    
    %loop for reading aid files
    firsttime=1;
    for j=1:length(i);
        if aidmea,
            eval(['atmp=load(''' mb(i(j),:) ''');'])
            eval(['bugarea1=atmp; clear atmp']);
        end
        [s,f]=dos(['type ' m(i(j),:)]);
        if isempty(f),continue,end
        k=find(f==setstr(10));
        ik=find(diff(diff(k))~=0);
        if isempty(ik);%if filenames dont change in #of chars 
            %(eg. dont cross over 100000000)
            k=k(1)-1;
            f=reshape(f(find(f~=setstr(10))),k,length(find(f==setstr(10))))';
            msindx=find(f(1,:)=='.');%# dots in string bounding ms time.
            ms1=msindx(1)+1;ms2=ms1+7;
            tday=str2num(f(:,ms1:ms2))/1000/60/60/24;
            %The following adds 1 ms between multiple rois on an image. 
            %Older autoid results only had ms and not roi #, so 1st checks # characters
            if (msindx(2)-msindx(1))==11,
                tday=tday+str2num(f(:,ms2+1:ms2+2))/86400000;
            end
            if firsttime,
                vprindx=strfind(f(1,:),'vpr');%these three lines find the starting vpr tow #
                firsttime=0;
                if ~isempty(vprindx),
                    slashindx=findstr(f(1,:),'\');
                    if isempty(slashindx),
                        slashindx=findstr(f(1,:),'/');
                    end
                    vprtowstr=f(1,(vprindx+3:slashindx(find(slashindx==vprindx-1)+1)-1));
                else
                    vprtowstr='0';
                end
            end
        else %ie there is a shift in # chars, assume shift across 100000000
            k1=k(1)-1;
            k2=k(ik+2)-1-k(ik+1);
            f1=f(1:k(ik+1));
            f2=f(k(ik+1)+1:length(f));
            f1=reshape(f1(find(f1~=setstr(10))),k1,length(find(f1==setstr(10))))';
            f2=reshape(f2(find(f2~=setstr(10))),k2,length(find(f2==setstr(10))))';
            tday=str2num(f1(:,(k1-14):(k1-7)))/1000/60/60/24;%>10000/0000 lists first
            tday=[tday;str2num(f2(:,(k2-15):(k2-7)))/1000/60/60/24];
        end;
        bugtmp=tday+str2num(m(i(j),(len-6):(len-4)));
        if str2num(m(i(j),(len-1):(len)))<23,
            bugtmp(find(tday>=1))=bugtmp(find(tday>=1))-1;%if time> 1 day
        end;
        bugtime=[bugtime;bugtmp];
        if aidmea, bugarea=[bugarea;bugarea1(:,2)];end
    end;
    
    ibt=find(bugtime>jtmin&bugtime<jtmax);
    bugtime=bugtime(ibt);
    
    if aidmea,
        bugarea=bugarea(ibt)*mm2pp;%convert from units of pixels to mm2
        bugradius=sqrt(bugarea/pi);
        bugvolume=bugarea.*bugradius*4/3; % equivalent spherical volume in cubic millimeters.
        %We can roughly approximate micrograms of carbon by dividing above by 1000 to get cubic 
        %centimeters = milliliters = grams of water at STD ~= grams of plankton since 
        %density of plankton is near unity for the wet mass conversion.
        %then multiply by 10^6 to get microliters or micrograms wet weight
        %then carbon estimated as 10% of wet weight since dry weight about 30% of wet 
        %weight and carbon is about 30% of dry weight
        %so multiply above by 100.
        bugcarbonmass=bugvolume*100;
    end
    
    clear bugs;bugs=[];
    [bugs indx]=histc(bugtime,dtime,1);
    
    if aidmea,
        bugsb=zeros(size(bugs));
        if length(bugcarbonmass)~=length(indx);
            mlen=min([length(bugcarbonmass) length(indx)]);
            bugcarbonmass=bugcarbonmass(1:mlen);
            indx=indx(1:mlen);
        end
        for k=1:length(indx),
            bugsb(indx(k))=sum(bugcarbonmass(indx==indx(k)));
        end
        bugsb(isnan(bugsb))=0;
        bugsb=bugsb./(b(:,13)*image_volume/1000)*correction_factor; % carbon biomass per liter
    end
    
    bugs(isnan(bugs))=0;
    bugs=bugs./(b(:,13)*image_volume/1000)*correction_factor; % number of individuals per liter; b(:,13) is # images per time bin, 
    
end%if LoadBugDataval: i.e., if load processed bug data

if SaveBugDataval,%if save processed bug data
    
    bugtime_all=interp1(b(:,1),b(:,2:10),bugtime);%interpolate b to bugtime
    if aidmea,
        bugtime_all=[bugtime,bugtime_all,bugradius];
    else
        bugtime_all=[bugtime,bugtime_all];%add 1st column = bugtime
    end
    
    col_headings='1=bugtime  2=lat  3=lon  4=press  5=temp  6=salt  7=sigma  8=fluo  9=atte  10=light  11=bug_radius';
    if exist([basepathcruise '\processed\bugs\individuals\' name],'dir')~=7,
        dos(['mkdir ' basepathcruise '\processed\bugs\individuals\' name]);
    end
    if exist([basepathcruise '\processed\bugs\binned\' name],'dir')~=7,
        dos(['mkdir ' basepathcruise '\processed\bugs\binned\' name]);
    end
    eval(['save ' basepathcruise '\processed\bugs\individuals\' name '\'  name '_all_' fn2 '_' classid ' bugtime_all col_headings']);
    if aidmea,
        eval(['save ' basepathcruise '\processed\bugs\binned\' name '\'  name '_' fn2 '_' classid ' dtime bugs bugsb']);
    else
        eval(['save ' basepathcruise '\processed\bugs\binned\' name '\'  name '_' fn2 '_' classid ' dtime bugs']);
    end
end

if CreateDotPlotval,%if dot plot
    xz_colordotplot([b(:,1),b(:,4),bugs],16,minmax(bugs'),'o','filled');
else
    
    %prepare data set for gridding
    [totkm,af,ar]=dist(lat,lon);
    totkm=[0 totkm/1000];
    totkm=cumsum(totkm)';  
    tmp1=[totkm p bugs];
    eval(['save tmp/' name '.dat tmp1 -ascii']);
    nx=nxgrd;ny=nygrd;
    cd tmp
    dos(['c:\cygwin\bin\bash -c "c:/cygwin/bin/sh ./mgridders ' name '.dat ' name '.grd ' num2str(nx) ' ' num2str(ny) '"']);
    cd ..
    
    if aidmea,
        tmp1=[totkm p bugsb];
        eval(['save tmp/' name 'biomass.dat tmp1 -ascii']);
        nx=nxgrd;ny=nygrd;
        cd tmp
        dos(['c:\cygwin\bin\bash -c "c:/cygwin/bin/sh ./mgridders ' name 'biomass.dat ' name 'biomass.grd ' num2str(nx) ' ' num2str(ny) '"']);
        cd ..
    end
    
    eval(['cd tmp; load ' name '.grd; cd ..']);
    
    %the following converts the zeros in the data matrix to NaN for blanking
    
    eval([name '(find(' name '==-999))=NaN*ones(size(' name '(find(' name '==-999))));']);
    eval([name '(find(' name '<0))=zeros(size(' name '(find(' name '<0))));']);
    
    zmin=min(p);
    zmax=max(p);
    z1=zmin:(zmax-zmin)/(ny-1):zmax;
    
%     ratotkm=runave(totkm,300);%use runave if lat lon data is noisy
%     shipdist=min(ratotkm):(max(ratotkm)-min(ratotkm))/(nx-1):max(ratotkm);
%     ix=interp1(ratotkm,1:length(ratotkm),shipdist);%gets i evenly spaced in x
    shipdist=min(totkm):(max(totkm)-min(totkm))/(nx-1):max(totkm);
    % Added by Qiao Hu 08/10/2004 
%     idx=find(diff(totkm)~=0);
%     totkm=totkm([1;idx+1]);
    % End of added by Qiao Hu
    ix=interp1(totkm,1:length(totkm),shipdist);%gets i evenly spaced in x
    
    i=nx;j=ny;x=[];y=[];z=[];
    x1=lon(round(ix))';
    y1=lat(round(ix))';
    z1=z1';
    for k=1:j;x=[x;x1];y=[y;y1];end;
    for k=1:i;z=[z z1];end;
    
    eval(['surf(x,y,z,' name ');shading interp;']);
    %fh=gcf;
    %view(-20,80);
    if isempty(az),az=10;el=70;end
    view(az,el);
    ah=gca;
    %view(-15,80);
    hold on;
    
    towpathhandle=plot3(lon,lat,p,'w','visible','off');%towyo path
    
    %axis([70.19 70.26 42.02  42.06 -50 0])
    %axis([70.15 70.25 42 42.1 -50 0]);
    %dlon=max(lon)-min(lon);dlat=max(lat)-min(lat);
    %axis([min(lon)-0.05*dlon max(lon)+0.05*dlon min(lat)-0.05*dlat max(lat)+0.05*dlat -60 0]);
    %axis([min(-lon) max(-lon) min(lat) max(lat) -100 0]);
    %axis([lonaxmin lonaxmax lataxmin lataxmax maxd 0]);
    
    
    set(gca,'position',[.2 .1 .7 .8]);
    axis equal;
    asprat=get(gca,'dataaspectratio');
    set(gca,'dataaspectratio',[asprat(1:2) asprat(3)*1000]);
    axis manual;
    axis tight;
    axis vis3d;
    
    title(['\bf' titlename ' \rm' units]);
    hold off;
    
    eval(['mm=[min(min(' name '(~isnan(' name '))));max(max(' name '(~isnan(' name '))))];']);
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
    
    h=get(gcf,'children');axes(h(2));
    objh=get(h(2),'children');
    x1data=get(objh(1),'xdata');
    y1data=get(objh(1),'ydata');
    z1data=get(objh(1),'zdata');
    cdata=get(objh(2),'cdata');
    xdata=get(objh(2),'xdata');
    ydata=get(objh(2),'ydata');
    zdata=get(objh(2),'zdata');
    eval(['save tmp/curtdat' num2str(gcf) ' xdata ydata zdata cdata x1data y1data z1data nx']);
    
    uicontrol('Style','slider','Min',0,'Max',nxgrd-1,'units','normalized','position',[0.0292308 0.0322034 0.153846 0.0338983],'callback','resizebugcurt');
    uicontrol('Style','slider','Min',0,'Max',nxgrd-1,'units','normalized','position',[0.0292308 0.0661017 0.153846 0.0338983],'value',nxgrd-1,'callback','resizebugcurt');
    uicontrol('Style','togglebutton','units','normalized','position',[0.0523077 0.00508475 0.115385 0.0254237],'value',0,'string','toggle towpath','callback','toggletowpath');
    
    axes(ah);%makes curtain plot the current axes
    
    clickmove;set(gcf,'doublebuffer','off');
    %plotbugbiomass;
    
    
end










