% to look at the automatic classified rois, one taxa at a time

global MACHINE WIN_WID WIN_HEIGHT IMCOL IMROW
MACHINE = 2  %input('Which machine is this (1 for ITI151, 2 for NT): ');
WIN_WID = 800;
WIN_HEIGHT =600;
IMCOL = input('Col num: ');
IMROW = input('Row num: ');
clfid = input('classifier ID: ','s'); % c4

disc = input('Base Path for rois (e.g., c:\\data): ', 's');	% ****
autodisc=input('Auto ID Disc name: ', 's');	% ****
%disc =  '/files1/home/xtang/plankton/testimg/';  %****
roidisc = disc;			% '/slick/files2/home/bugs/'; %****

cruise = input('Cruise name: ','s');	% 292;	% ****
day = input('Day# (use three charactors, eg. 001): ', 's');	% 13;	% ****
%hour = input('hour: ');
autoid_dir = [autodisc,filesep cruise,filesep,'autoid',filesep]

taxa = input('taxa name: ','s'); 
%taxa = 'DIAT_CENTR';
%taxa = 'DIATOM_ROD';
taxa_dir=[autoid_dir,taxa,filesep];
CL_THRESH = 0;

a='0';
aid_dir = [taxa_dir,'aid',filesep,clfid, 'aid.d', day, '.h*'] % a(2-length(num2str(hour))), num2str(hour)]
aidmea_dir = [taxa_dir,'aidmea',filesep,clfid, 'aid.mea.d', day, '.h*'] % a(2-length(num2str(hour))), num2str(hour)]
%[dum aid_files] = unix(['dir ', aid_dir]); 
%[dum aidmea_files] = unix(['dir ', aidmea_dir]); 
aid_files=dosdir3(aid_dir);
aidmea_files=dosdir3(aidmea_dir);
disp([aid_files]);
start_file = input('Starting file number: ');
numfile = length(find(aid_files==10));
NUM = IMCOL*IMROW;
if numfile > 0
  sw = 1;			% set switch for continue options
  for i = start_file:numfile
    if sw ~= 3
      aid_f = nthfile(aid_files,i)
      aidmea_f = nthfile(aidmea_files,i)
      load([taxa_dir,'aidmea',filesep,aidmea_f]);
      com = ['meas = ', clfid, 'aid;']
      eval(com);
      imfiles = loadname([taxa_dir,'aid',filesep,aid_f])
%      imfiles = imfiles(meas(:,13)+meas(:,15) >= CL_THRESH,:);
%      meas = meas(meas(:,13)+meas(:,15) >= CL_THRESH,:);
      imnum = size(imfiles,1)
      for d = 1:ceil(imnum/NUM)
d
        domain = [(1+(d-1)*NUM):min(d*NUM,imnum)];
        fig = figure(1);clf
        %set(fig,'Position',[0 40 WIN_WID WIN_HEIGHT],'units','pixels');
        [xwid, ywid, imrow, imcol, btnarea, d_imfile]= supervisbin2(imfiles, domain, 1,disc,cruise);
        sw = input('Continue (1), Next hour (2), Stop (3): ');  % 2,3 doesn't
        if sw==2|sw==3, 
	  break; 
	end;
      end
    else
      break;
    end
  end
else
  disp(['No result in ',aid_dir]);
end
