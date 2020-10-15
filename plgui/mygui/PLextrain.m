function PLextrain

global hrow prec hmmrois

%finds selected folders and numbers of trrois from the PLtrain window, 
%then looks to see if extridsize.m has already been run on these trrois, 
%then runs extridsize as needed;
%then modifies the setpar file, and 
%finally runs realtrain.m

ytext=get(findobj(gcbf,'tag','ytext'),'string');
xtext=str2mat(flipud(get(findobj(gcbf,'tag','xtext'),'string')));
row=[];
tows=[];
oldtow='';
discmat='';
cruisemat='';
for j=1:size(ytext,1)-2,
    if get(findobj(gcbf,'tag',['hradio' num2str(j)]),'value')==1,
        row=[row; j];
    end;
end
rowdata=[];
used=str2num(get(hrow(size(ytext,1)),'string'));
for j=1:length(row),
    rowstring=deblank(ytext(row(j),:));
    lrs=length(rowstring);
    hour=rowstring(lrs-1:lrs);
    day=rowstring(lrs-6:lrs-4);
    fsl=findstr(rowstring,filesep);%filesep locations, i.e. in windows it's the backslashes 
    lfsl=length(fsl);
    tow=rowstring(fsl(lfsl-2)+4:fsl(lfsl-1)-1);
    cruise=rowstring(fsl(lfsl-4)+1:fsl(lfsl-3)-1);
    basepath=rowstring(1:fsl(lfsl-4)-1);
    rowdata=str2num(get(hrow(row(j)),'string'));
    taxaindex=find((used>0)&rowdata>0);
    taxa=xtext(taxaindex,:);
    numrois=rowdata(taxaindex);
    nrois=[];
    for k=1:size(taxa,1),
        path1=[basepath filesep cruise filesep 'idsize'];
        if isempty(dir(path1)), 
            extridsize(basepath,cruise,str2num(tow),day,str2num(hour));
        end;
        path2=[path1 filesep 'hid.v' tow '.'];
        feapath=[basepath filesep cruise filesep 'feature' filesep 'vpr' tow];
        if isempty(dir([path2 '*'])),
           extridsize(basepath,cruise,str2num(tow),day,str2num(hour));
        end;
        path3=[path2 deblank(taxa(k,:))];
        if isempty(dir(path3)),
%           eval(['delete ' path2 '*']);
%           eval(['delete ' feapath filesep '*']);
           extridsize(basepath,cruise,str2num(tow),day,str2num(hour));
        end
        [err roinames]=dos(['findstr ' rowstring(1:fsl(lfsl-1)) ' ' path3]);
        if isempty(roinames), 
%           eval(['delete ' path2 '*']);
%           eval(['delete ' feapath filesep '*']);
           extridsize(basepath,cruise,str2num(tow),day,str2num(hour));
        end;
        [err roinames]=dos(['findstr ' rowstring ' ' path3]);
        if isempty(roinames),
           extridsize(basepath,cruise,str2num(tow),day,str2num(hour));
           [err roinames]=dos(['findstr ' rowstring ' ' path3]);
        end
        nrois(k)=length(findstr(roinames,char(10)));
        if j==1 & k==1, disp(char(13));end;
        disp([num2str(nrois(k)) ' ' rowstring ' were found in' char(13) blanks(length(num2str(nrois(k)))+1) path3]);
    end;
    rowdata=zeros(size(rowdata));
    rowdata(taxaindex)=nrois;
    set(hrow(row(j)),'string',num2str(rowdata,prec),'foregroundcolor','b');
    if j==1,
       total=rowdata;
    else
       total=total+rowdata;
    end
    if ~strcmp(tow,oldtow),
       oldtow=tow;
       dindx=strmatch(basepath,discmat);
       cindx=strmatch(cruise,cruisemat(dindx));
       if isempty(cindx),
          discmat=strvcat(discmat,basepath);
          cruisemat=strvcat(cruisemat,cruise);
          tindx=size(discmat,1);
          tows=[tows; tindx str2num(tow)];
       else
          tindx=dindx(cindx);
          tows=[tows; tindx str2num(tow)];
       end
    end;
end;
set(hrow(length(hrow)-1),'string',num2str(total,prec),'foregroundcolor','b');
mmrois=str2num(get(hmmrois,'string'));
used=(total>=mmrois(1)).*total;
used(used>mmrois(2))=mmrois(2);
set(hrow(length(hrow)),'string',num2str(used,prec),'foregroundcolor','b');
ytext=ytext(1:size(ytext,1)-2,:);
ytext=str2mat(ytext,'Total Processed','Processed Used for Training');
set(findobj(gcbf,'tag','ytext'),'string',ytext);
taxaindex=find(used>0);
taxas=xtext(taxaindex,:);
classifiername=get(findobj(gcbf,'tag','classifierID'),'string');
domtr=[];
for j=1:size(tows,1),
   domtr=[domtr used(taxaindex)./total(taxaindex)];
end;
TNET=floor(sum(used)/4);if mod(TNET,2), TNET=TNET+1;end

realtrain(classifiername,tows,cruisemat,discmat,taxas,domtr,TNET);

close(gcbf);

redgreenblue=[0.2157 .6353 .6353]*1.2;%let's make it lighter for this figure
h0 = figure('Units','normalized', ...
	'Color',[redgreenblue], ...
	'MenuBar','none', ...
	'Name','VPR:  Training the Computer', ...
	'NumberTitle','off', ...
   'Position',[.3    .5    0.4    0.2], ...
	'ToolBar','none');
uicontrol('style','pushbutton','units','normalized','position',[.3 .1 .4 .3], ...
   'string','OK','backgroundcolor',redgreenblue, ...
   'callback','close(gcbf)','fontsize',12,'fontweight','bold');
uicontrol('style','text','units','normalized','position',[.1 .5 .8 .4], ...
   'string',['Training Completed Successfully.' char(13) ...
      '(Training accuracy is shown in Matlab command window.)'], ...
   'backgroundcolor',redgreenblue,'fontsize',12,'fontweight','bold');

