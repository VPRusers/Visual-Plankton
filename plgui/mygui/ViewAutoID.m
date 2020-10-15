function [] = ViewAutoID(action, varargin)
% displays the automatically classified rois for a selected taxon
% and, if desired, to manually re-sort to correct misidentified rois

if nargin<1,
    ViewAutoIDcontrol;
    PrepViewAutoID;
    GetAutoIDroiList;
    DisplayROIs;
else,
    feval(action,varargin{:});
end;

return;


function ViewAutoIDcontrol;

%Get information from calling window 
h=gcbf;
h1=findobj(h,'Tag','PopupMenu Taxon');
dummystring=get(h1,'String');v=get(h1,'value');
a=(2:size(dummystring,1))';
a=a(a~=v);
taxalist=dummystring(a,:);
taxon=deblank(dummystring(v,:));

redgreenblue=[0.2157 .6353 .6353]*1.2;

h0 = figure('Units','normalized', ...
	'Color',[redgreenblue]*1.1, ...
	'Colormap','default', ...
	'MenuBar','none', ...
	'Name','VPR   View AutoID Control', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[0.060 0.345 0.207 0.557], ...
	'Tag','VPR View AutoID Control', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'Position',[0.2264 0.8598 0.5236 0.0958], ...
    'Fontunits','normalized',...
    'Fontsize',0.3, ...
    'fontweight','normal', ...
    'String',['Move ' taxon ' to:'], ...
	'Style','text', ...
	'Tag','ViewAutoID Control Text', ...
    'TooltipString',['Click on a taxon in this list to change' char(10) 'the identification of the selected ROIs to that taxon']);

for j=1:size(taxalist,1),eval(['udata.' taxalist(j,:) '=[];']);end
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',1, ...
	'Position',[0.15    0.25    0.7    0.65], ...
    'Fontunits','normalized',...
    'Fontsize',0.05, ...
    'String',taxalist, ...
    'Callback','correctid', ...
    'Userdata',udata, ...
    'Min',1, ...
    'Max',size(taxalist,1), ...
    'Value',1, ...
	'Style','listbox', ...
	'Tag','ViewAutoID Control Taxa List', ...
    'TooltipString',['Click on a taxon in this list to mark' char(10) 'the selected ROIs for ID correction']);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'Position',[0.0896    0.0374    0.1934    0.0724], ...
    'Fontunits','normalized',...
    'Fontsize',0.4, ...
    'String','Cancel', ...
    'callback','close(gcbf);close(findobj(''tag'',''correctID_1''));', ...
	'Style','pushbutton', ...
	'Tag','ViewAutoID Control Text', ...
    'TooltipString','Quit without making changes (current window only)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'Position',[0.3255    0.0374    0.2877    0.0724], ...
    'Fontunits','normalized',...
    'Fontsize',0.4, ...
    'String','Next Hour', ...
    'callback','ViewAutoID WriteCorrectedID; ViewAutoID GetAutoIDroiList; ViewAutoID DisplayROIs', ...
	'Style','pushbutton', ...
	'Tag','ViewAutoID GetAutoIDroiList', ...
    'TooltipString','Make changes and view next hour');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'Position',[0.6557    0.0374    0.2406    0.0724], ...
    'Fontunits','normalized',...
    'Fontsize',0.4, ...
    'String','Continue', ...
    'callback','ViewAutoID WriteCorrectedID; ViewAutoID DisplayROIs', ...
	'Style','pushbutton', ...
	'Tag','ViewAutoID DisplayROIs', ...
    'TooltipString','Make changes and continue viewing this hour');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'Position',[0.0896 0.14 0.19 0.0724], ...
    'Fontunits','normalized',...
    'Fontsize',0.4, ...
    'String','Undo', ...
    'callback','ViewAutoID Undo', ...
	'Style','pushbutton', ...
	'Tag','ViewAutoID Undo', ...
    'TooltipString','Undo changes (current ROI window only)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.2, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.33 0.14 0.25 0.05], ...
	'String','Add Taxon', ...
	'Style','text', ...
	'Tag','StaticText Add Taxon', ...
	'TooltipString','Enter new taxon name and press Enter key to add to list');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'fontunits','normalized','fontsize',.7, ...
	'FontWeight','normal', ...
	'Position',[0.60 0.15 0.33 0.05], ...
    'Callback','ViewAutoID AddTaxon', ...
	'Style','edit', ...
	'Tag','EditText Add Taxon', ...
	'TooltipString','Enter new taxon name and press Enter key to add to list');



function PrepViewAutoID
h=findobj('Tag','VPR View AutoID'); 
if ~isempty(h)
    h1=findobj(h,'Tag','PopupMenu Display');
    dummystring=get(h1,'String');v=get(h1,'value');
    rowcol=deblank(dummystring(v,:));
    imrow=str2num(rowcol(1:findstr('x',rowcol)-1));
    imcol=imrow;
    h1=findobj(h,'Tag','PopupMenu ROI Drive');
    dummystring=get(h1,'String');v=get(h1,'value');
    disc=deblank(dummystring(v,:));
    h1=findobj(h,'Tag','PopupMenu ROI Folder');
    dummystring=get(h1,'String');v=get(h1,'value');
    folder=deblank(dummystring(v,:));
    roibasepath=[disc folder];
    h1=findobj(h,'Tag','PopupMenu AutoID Drive');
    dummystring=get(h1,'String');v=get(h1,'value');
    disc=deblank(dummystring(v,:));
    h1=findobj(h,'Tag','PopupMenu AutoID Folder');
    dummystring=get(h1,'String');v=get(h1,'value');
    folder=deblank(dummystring(v,:));
    autoidbasepath=[disc folder];
    h1=findobj(h,'Tag','PopupMenu Cruise');
    dummystring=get(h1,'String');v=get(h1,'value');
    cruise=deblank(dummystring(v,:));
    h1=findobj(h,'Tag','PopupMenu Classifier');
    dummystring=get(h1,'String');v=get(h1,'value');
    classifier=deblank(dummystring(v,:));
    clfid=classifier;
    h1=findobj(h,'Tag','PopupMenu Taxon');
    dummystring=get(h1,'String');v=get(h1,'value');
    taxon=deblank(dummystring(v,:));
    h1=findobj(h,'Tag','PopupMenu Yearday');
    dummystring=get(h1,'String');v=get(h1,'value');
    day=deblank(dummystring(v,:));
    h1=findobj(h,'Tag','PopupMenu Hour');
    start_file=get(h1,'value');
    hours=get(h1,'string');
    start_hour=deblank(hours(start_file,:));%only removes trailing blanks
    if start_hour(1)==' ',start_hour(1)='0';end%replace leading blank w/ 0
        
    autoid_dir = [autoidbasepath,filesep cruise,filesep,'autoid',filesep];
    taxa_dir=[autoid_dir,taxon,filesep];
    CL_THRESH = 0;
    aid_dir = [taxa_dir,'aid',filesep,clfid, 'aid.d', day, '.h*'];
    aid_files=dosdir3(aid_dir);
    aindx=find(aid_files==10);
    numfile = length(aindx);
    for k=1:numfile, 
        if str2num(aid_files(aindx(k)-2:aindx(k)-1))==str2num(start_hour),
            start_file=k;
        end,
    end
    num = imcol*imrow;
    imfiles=[];
    idx=[];
    mea=[];

    h1=findobj('tag','ViewAutoID GetAutoIDroiList');
    set(h1,'userdata',{start_file-1; numfile;taxa_dir;aid_files;autoidbasepath;cruise;0;num;imfiles;imcol;imrow;taxon;idx;mea;roibasepath});
    
    p1=3*pi/2;p3=2*pi;p2=(p3-p1)/256;
    map=[(p1:p2:p3)', (p1:p2:p3)', (p1:p2:p3)'];
    map=cos(map).^4;
    h=findobj('tag','correctID_1');
    if isempty(h),
        h=figure('tag','correctID_1','NumberTitle','off','name',['VPR ViewAutoID ' taxon],'units','normalized','position',[0.2871 0.1758 0.6934 0.6823]);
        colormap(map);brighten(0.8);
    else,
        figure(h,'units','normalized','position',[0.2871    0.1758    0.6934    0.6823]);
    end
    
end


function GetAutoIDroiList;

h1=findobj('tag','ViewAutoID GetAutoIDroiList');
dumvar=get(h1,'userdata');
j=dumvar{1}+1;
numfile=dumvar{2};
taxa_dir=dumvar{3};
aid_files=dumvar{4};
taxon=dumvar{12};
if j<=numfile,
    aidfile = nthfile(aid_files,j);
    d=dir([taxa_dir,'aid',filesep,aidfile]);
    if d.bytes~=0,%aidfile has data
        aidmeafile=[aidfile(1:length(aidfile)-9) '.mea' aidfile(length(aidfile)-8:length(aidfile))];
        imfiles = loadname([taxa_dir,'aid',filesep,aidfile]);
        mea = loadname([taxa_dir,'aidmea',filesep,aidmeafile]);
        dumvar{1}=j;
        set(h1,'userdata',{dumvar{1}; numfile;taxa_dir;aid_files;dumvar{5}; ...
                dumvar{6};0;dumvar{8};imfiles;dumvar{10};dumvar{11};dumvar{12};[];mea;dumvar{15}});
    else%aidfile is empty, probably due to removal during correction
        dumvar{1}=j;
        set(h1,'userdata',{dumvar{1}; numfile;taxa_dir;aid_files;dumvar{5}; ...
                dumvar{6};0;dumvar{8};[];dumvar{10};dumvar{11};dumvar{12};[];[];dumvar{15}});
    end
end
h=findobj('tag','correctID_1');
set(h,'name',['VPR ViewAutoID ' taxon '  ' aidfile]);


function DisplayROIs

h1=findobj('tag','ViewAutoID GetAutoIDroiList');
dumvar=get(h1,'userdata');
if isempty(dumvar{9}),
    h=findobj('tag','correctID_1');
    figure(h);clf;
    axis([0 2 0 2]);axis off;
    text(.5,1,'No ROIS in this hour','fontsize',14);
    return,
end
roidisc=dumvar{15};
cruise=dumvar{6};
d=dumvar{7}+1;
num=dumvar{8};
imfiles=dumvar{9};
imcol=dumvar{10};
imrow=dumvar{11};
taxon=dumvar{12};
imnum = size(imfiles,1);
if d <= ceil(imnum/num);
    domain = [(1+(d-1)*num):min(d*num,imnum)];
    h=findobj('tag','correctID_1');
    figure(h);clf;
    uicontrol(h,'units','normalized','style','togglebutton', ...
        'position',[0.45 0.05 0.15 0.07],'string','IrfanView','tag','IrfanView');
    supervisbin3(imfiles, domain, 1,roidisc,cruise,imcol,imrow,taxon);
    dumvar{7}=d;
    set(h1,'userdata',dumvar);
end;



function Undo

h1=findobj('Tag','PopupMenu Taxon');
dummystring=get(h1,'String');v=get(h1,'value');
a=(2:size(dummystring,1))';
a=a(a~=v);
taxalist=dummystring(a,:);
for j=1:size(taxalist,1),eval(['udata.' taxalist(j,:) '=[];']);end

h1=findobj('Tag','ViewAutoID Control Taxa List');
set(h1,'userdata',udata);

h1=findobj('tag','ViewAutoID GetAutoIDroiList');
dumvar=get(h1,'userdata');
dumvar{7}=dumvar{7}-1;
set(h1,'userdata',dumvar);
ViewAutoID DisplayROIs

function AddTaxon

taxon=deblank(get(gcbo,'string'));
h1=findobj('Tag','ViewAutoID Control Taxa List');
taxalist=get(h1,'string');
taxalist=str2mat(taxalist,taxon);
set(h1,'string',taxalist);
udata=get(h1,'userdata');
eval(['udata.' taxon '=[];']);
set(h1,'userdata',udata);
h2=findobj('Tag','PopupMenu Taxon');
taxalist2=get(h2,'String');
taxalist2=str2mat(taxalist2,taxon);
set(h2,'string',taxalist2);


function WriteCorrectedID

h1=findobj('tag','ViewAutoID GetAutoIDroiList');
dumvar=get(h1,'userdata');
j=dumvar{1};
aid_files=dumvar{4};
autoidbasepath=dumvar{5};
cruise=dumvar{6};
autoidpath=[autoidbasepath '\' cruise '\autoid\'];
aidfile=nthfile(aid_files,j);
aidmeafile=[aidfile(1:length(aidfile)-9) '.mea' aidfile(length(aidfile)-8:length(aidfile))];
imfiles=dumvar{9};
taxa_dir=dumvar{3};
taxon=dumvar{12};
idx=dumvar{13};
mea=dumvar{14};
write_flag=0;

h2=findobj('Tag','ViewAutoID Control Taxa List');
udata=get(h2,'userdata');
names=fieldnames(udata);

for j=1:length(names),
    eval(['roinames2mv=udata.' names{j} ';'])
    eval(['udata.' names{j} '=[];']);
    if ~isempty(roinames2mv),
        write_flag=1;
        idx2=[];
        for k=1:size(roinames2mv,1),
            idx1=strmatch(roinames2mv(k,:),imfiles);
            idx=[idx;idx1];
            idx2=[idx2;idx1];
        end
        taxa2_dir=[autoidpath names{j} '\aid\'];
        taxa2mea_dir=[autoidpath names{j} '\aidmea\'];
        if isempty(dir(taxa2_dir)),
            dos(['mkdir ' taxa2_dir]);
        end
        if isempty(dir(taxa2mea_dir)),
            dos(['mkdir ' taxa2mea_dir]);
        end
        imfiles2=[];
        if ~isempty(dir([taxa2_dir aidfile])),
            d=dir([taxa2_dir aidfile]);
            if d.bytes~=0;
                imfiles2 = loadname([taxa2_dir,aidfile]);
            end
        end
        mea2=[];
        if ~isempty(dir([taxa2mea_dir aidmeafile])),
            d=dir([taxa2_dir aidfile]);
            if d.bytes~=0;
                mea2 = loadname([taxa2mea_dir,aidmeafile]);
            end
        end
        imfiles2=[imfiles2;imfiles(idx2,:)];
        mea2=[mea2;mea(idx2,:)];
        fid=fopen([taxa2_dir aidfile],'w');
        fprintf(fid,'%c',imfiles2');
        fclose(fid);
        fid=fopen([taxa2mea_dir aidmeafile],'w');
        fprintf(fid,'%c',mea2');
        fclose(fid);
   end
end

if  write_flag==1,
    set(h2,'userdata',udata);
    idx
    dumvar{13}=idx;
    set(h1,'userdata',dumvar);
    
    n=ones(size(imfiles,1),1);
    n(idx)=0;
    imfiles_out=imfiles(logical(n),:);
    mea_out=mea(logical(n),:);
    
    fid=fopen([taxa_dir 'aid\' aidfile],'w');
    %eval(['fid=fopen(''' taxon '.h14'',''w'');']);
    fprintf(fid,'%c',imfiles_out');
    fclose(fid);
    
    fid=fopen([taxa_dir 'aidmea\' aidmeafile],'w');
    %eval(['fid=fopen(''' taxon '.mea.h14'',''w'');']);
    fprintf(fid,'%c',mea_out');
    fclose(fid);
end
