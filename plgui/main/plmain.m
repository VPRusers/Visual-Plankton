% Feature extraction main program

% 
% modified extensively to include user interface and new extraction/classification
% methods  C. Davis

% clear all
% input data base

h=gcbf;
if ~isempty(h)
    h1=findobj(h,'Tag','Checkbox Classification');
    h2=findobj(h,'Tag','Checkbox Feature Extraction');
    PASS_ID=2*get(h1,'Value')+get(h2,'Value');	
    h1=findobj(h,'Tag','EditText Cruise Name');
    cruise=get(h1,'String');
    h1=findobj(h,'Tag','EditText Classifier File');
    name=get(h1,'String');
    h1=findobj(h,'Tag','EditText Autoid Disc');
    autoidpath=get(h1,'String');
    h1=findobj(h,'Tag','EditText Disc Name');
    disc=get(h1,'String');
    h1=findobj(h,'Tag','EditText Julian Day#');
    day=get(h1,'String');
    h1=findobj(h,'Tag','EditText Start Hour');
    sthour=str2num(get(h1,'String'));
    h1=findobj(h,'Tag','EditText End Hour');
    endhour=str2num(get(h1,'String'));
    h1=findobj(h,'Tag','PopupMenu VPR#');
    tow=get(h1,'Value')-1;
    h1=findobj(h,'Tag','PopupMenu ClassifierType');
    cl_type=get(h1,'Value')-1;%1=dual, 2=COM-SVM, 3=SBF-NN
else    
    PASS_ID = input('Processing path, 1 for extr, 2 for classify, 3 for both: ');
    cruise = input('Cruise name (an9803): ', 's');%ch0697
    tow = input('Tow#: ' );			% ****
    disc = input('Disc name (start and end with a /, eg. /dark/data/): ', 's');
    autoidpath = input('Autoid Path (start and end with a /, eg. /dark/data/): ', 's');
    day =  input('Day# (use three charactors, eg. 001): ','s' )    % ****
    sthour = input('Start hour#: ');	% ****
    endhour = input('End hour#: ');		% ****
end              

% global parameters
global PASS_ID;
globvar('AREA_THRESH', 10);
globvar('GRA_LEN', 160);
globvar('CONT_LEN', 256);
globvar('GEO_LEN', 29);  
cl_dir = [disc,filesep, cruise,filesep,'clpar',filesep];  
%if PASS_ID == 1,  name = 'dumyfile'; end

if cl_type==1,
    fname = [cl_dir,name,'dual.mat'];
elseif cl_type==2,
    fname = [cl_dir,name,'svm.mat'];
else
    fname = [cl_dir,name,'nn.mat'];
end
clfid=name;

if ~exist(fname,'file')
    fprintf('No Parameter File.  Aborting.\n');
    return;
end

com = ['load ', fname]
eval(com);
taxas=char(taxas);
roidisc = disc; 
%autoidpath = disc; 
dir_autoid = [autoidpath,filesep, cruise,filesep,'autoid',filesep]
if ~exist([autoidpath,filesep,cruise],'dir'), mkdir(autoidpath,cruise); end
if ~exist(dir_autoid,'dir'),   
    mkdir([autoidpath,filesep,cruise],'autoid');
end
a ='0';
stop = 0;               % hours end flag
for hour = sthour:endhour 
    if length(num2str(hour)) == 1
        a='0';
    else
        a = [];
    end   
    rois_dir =[disc, filesep,cruise,filesep,'rois',...
            filesep,'vpr', num2str(tow), filesep,'d', day, filesep,'h', a, num2str(hour),filesep]
    if hour < 23
        if length(num2str(hour+1)) == 1
            aa='0';
        else
            aa = [];
        end   
        rois_dirn =[disc, filesep,cruise,filesep,'rois',...
                filesep,'vpr', num2str(tow), filesep,'d', day, filesep,'h', aa, num2str(hour+1),filesep]
    else
        rois_dirn =[disc, filesep,cruise,filesep,'rois',...
                filesep,'vpr', num2str(tow), filesep,'d', num2str(str2num(day)+1), filesep,'h00',filesep]
    end
    tefeature_dir = [disc, filesep,cruise,filesep,'tefeature',...
            filesep,'vpr', num2str(tow), filesep,'d', day, filesep,'h', a, num2str(hour),filesep]
    if ~exist(tefeature_dir,'dir'), 
        dos(['mkdir ', tefeature_dir]);
    end   
    startnum = 1;
    %cont = 1;%for realtime or post processing of more than one hour
    cont = 0;%for post processing of one hour at a time
    idle_count=0;
    %OLD WAY  [s,imfilesn] = dos(['dir /B ', rois_dirn]);
    %OLD WAY  [s,imfiles] = dos(['dir /B ', rois_dir]);
    %imfilesn = dosdir(rois_dirn);
    imfiles = dosdir(rois_dir);
    if size(imfiles,1) > 0                % there is data in this hour
        if cl_type == 2 %added E. Chisholm May 2019 to avoid requirement of faxis_max (and other variables) when running svm model (does not include faxis_max)
            faxis_max = NaN;
            select_type = NaN;
            t1 = NaN; t2 = NaN; t3 = NaN; t4 = NaN;
            cl_method = NaN;
            %x_mean = NaN;, x_std = NaN; %causing issues in feature
            %normalization
            mship = NaN;
        end
        extractplbinchas2r(cl_dir,rois_dir,imfiles,tefeature_dir,faxis_max, select_type, ...
            t1, t2, t3, t4, cl_method, x_mean, x_std, taxas,dir_autoid, day, ...
            hour, clfid, mship, cl_type);
        numfile = length(find(imfiles==10)) % 10 is the <CR> character
        startnum = numfile+1;               % start file num for next round
        fprintf('Processed Tow %d Day %s Hour %d roi 1 to %d\n', ...
            tow, day, hour, numfile);  
    end
    while cont
        %OLD WAY    [s,imfilesn] = dos(['dir /B ', rois_dirn]);
        %OLD WAY    [s,imfiles] = dos(['dir /B ', rois_dir]);
        %imfilesn = dosdir(rois_dirn);
        imfiles = dosdir(rois_dir);
        numfile = length(find(imfiles==10))
        if numfile >= startnum              % if new image came in
            imfiles = nthafter(imfiles, startnum);    % files start from startnum
            startnum = numfile+1                      % start file num for next round
            extractplbinchas2r(cl_dir,rois_dir, imfiles, tefeature_dir,faxis_max, ...
                select_type,t1, t2, t3, t4, cl_method, x_mean, x_std, taxas,...
                dir_autoid, day, hour, clfid, mship, cl_type);
            idle_count = 0;
        else                                % no new data
            idle_count = idle_count+1
            pause(6)
            fprintf('Tow %d Day %s Hour %d going %d times, Processed image num %d \n',...
                tow, day, hour, idle_count, numfile);
            if idle_count == 10		fprintf('Assume NO new roi come in for tow %d day %s hour %d and hour %d \n',...
                    tow, day, hour, hour+1)
                fprintf('Processed image num %d of hour %d ', numfile, hour)
                cont = 0; stop = 1;
            end
        end                         % end if newfile
        %	stophdl  = findobj('Tag','ClassifyStop');
        %	if (stophdl)
        %		stopname = get(stophdl,'String');
        %		if (stopname == 'Restart')
        %			return;
        %		end
        %	end
        %if size(imfilesn,2) > 0     % next hour started
        if exist(rois_dirn,'dir')  % next hour exists
            cont = 0;             % this hour is done with incoming roi
            disp(['Roi comes in for the next hour, go there']);
        end
    end   % end while
    if stop % no more roi for next hour
        % don't stop    break
    end
end % end of for hour
