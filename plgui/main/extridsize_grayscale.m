function extridsize(disc,cruise,tow,day,hour)

% 11/11/96 X. Tang -- 
%clear all
% Add co-occurrence matrix by Qiao Hu 10/13/04

% input data base 
% input data base 
%h=gcbf;
global PASS_ID;

if nargin>0,
    sthour=hour;
    endhour=hour;
    PASS_ID=1; 
else 
  cruise = input('Cruise name: ', 's');
  tow = input('Tow#: ' );         
  disc = input('Disc name (start and end with a /, eg. /dark/data/): ', 's');
  day = input('Day# (use three charactors, eg. 001): ','s' );
  sthour = input('Start hour#: ');
  endhour = input('End hour#: ');
  PASS_ID = input('Processing path, input 1 if feature file has not been computed, input 2 if already computed : ');
end

machinetype = computer;
if strcmp(machinetype(1:3), 'SGI');
  comd_str = ' !../sbin/pbinsgi ';
elseif strcmp(machinetype, 'SOL2');
  comd_str = ' !../sbin/pbin ';
elseif strcmp(machinetype, 'PCWIN');
  comd_str = ['!..' filesep 'sbin' filesep 'pbin_dos '];
else
  disp(['wrong type of operating system']);
end 

types = str2mat('gra','dst','geo','coo');
% global parameters
globvar('AREA_THRESH', 10);
globvar('GRA_LEN', 160);
globvar('CONT_LEN', 256);
globvar('GEO_LEN', 29);  
globvar('COO_LEN', 64);
global AREA_THRESH GRA_LEN CONT_LEN GEO_LEN COO_LEN;
small_count = [];
dir_trfea = [disc,filesep, cruise, filesep,'feature',...
      filesep,'vpr',num2str(tow), filesep];
if ~exist(dir_trfea,'dir'), dos(['mkdir ',dir_trfea]);end
dir_idsize = [disc,filesep, cruise, filesep,'idsize',filesep];
if ~exist(dir_idsize,'dir'), dos(['mkdir ',dir_idsize]);end
for hour = sthour:endhour 		% hour loop
  featow = tow; 				% ****
  tefea_dir = [disc,filesep, cruise,filesep,'tefeature',...
        filesep,'vpr', num2str(featow), filesep,'d', day, filesep,'h',num2str(hour,'%02d'),filesep];
  if ~exist(tefea_dir,'dir') dos(['mkdir ',tefea_dir]); end
  trrois_dir =[disc,filesep, cruise,filesep,'trrois',...
             filesep,'vpr', num2str(tow), filesep,'d', day, filesep,'h',num2str(hour,'%02d'),filesep];
  
  [s,taxafiles] = dos(['dir /B /ON ', trrois_dir, '*.']);
%  taxafiles = dosdir(trrois_dir);
  pathtest=['The system cannot find the path specified.'];
%	if (pathtest == taxafiles(1:length(pathtest)))
%		fprintf('NO Rois to Process.  Done.\n');
%		break;
%	end
  for taxa = 1:length(find(taxafiles==10))	% taxa loop
    taxastr = nthfile(taxafiles, taxa);
%    taxastr = taxastr(1:length(taxastr)-1)
    trrois_dir=[disc, filesep,cruise,filesep,'trrois',filesep,'vpr',num2str(tow),...
	 filesep,'d', day, filesep,'h',num2str(hour,'%02d'), filesep, taxastr, filesep];
%OLD WAY    [s,imfiles] = dos(['dir /B ', trrois_dir])    
	imfiles = dosdir(trrois_dir);
    if size(imfiles,1) > 0                % there is data in this taxa and hour
      fil_nam = [dir_idsize, 'hid.v', num2str(tow), '.', taxastr]
      fea_mea = [dir_idsize, 'hid.v'  num2str(tow), '.mea.',taxastr];
      fea_gra = [dir_trfea, 'fea.gra.',taxastr];
      fea_dst = [dir_trfea, 'fea.dst.',taxastr];
      fea_geo = [dir_trfea, 'fea.geo.',taxastr];
      fea_coo = [dir_trfea, 'fea.coo.',taxastr];
      

      fid_nam = fopen(fil_nam, 'a');
      fid_mea = fopen(fea_mea, 'a');
      fid_gra = fopen(fea_gra, 'a');
      fid_dst = fopen(fea_dst, 'a');
      fid_geo = fopen(fea_geo, 'a');
      fid_coo = fopen(fea_coo, 'a');
    
      imnum = length(find(imfiles==10)) 
      for i = 1:imnum, 
        fprintf('******* Processing image number %d of %d ********\r',i,imnum);
        imfile = deblank_ts([trrois_dir, nthfile(imfiles, i)]); 
        if PASS_ID == 1
            eval([comd_str, imfile])
            % eval([comd_str,imfile]);
            %  comd_str = ['-granul -outline ',imfile];
            %  comd_str = ['-granul -outline -bmoments ',imfile];
            %  plpmex(comd_str);
            [gra, cont] = readvector(rootname(basename(imfile)));
            fco = coocfeat(imfile);
            if length(cont) < AREA_THRESH         % if object too small, discard
                disp(['object too small']); small_count = small_count+1
                small_flag = 1;
            else
                fgra =gra;
                %    fbgr = bgr;
                
                dist = cont_intp(cont, CONT_LEN);
                fdst = fds(dist)';
                %            geofile=[rootname(basename(imfile)),'.bmoments.txt'];
                [v1,v2,v3] = geofea(cont,2);         % ** add gray scale features
                %            [v1,v2,v3,v4] = readgeofea(geofile,cont,2);         % ** add gray scale features
                fgeo = [v1 v2 v3(1:4)/v3(5) v3]; % v4 ];
                fmea = [fgeo(1:2) fgeo(25:29)];
                small_flag = 0;
            end					% end if size
        elseif PASS_ID == 2
            feafile = [tefea_dir, rootname(nthfile(imfiles, i)),'.dat'];
            if exist(feafile, 'file') == 2
                fid = fopen(feafile);
                fea = fread(fid,'float')';
                fclose(fid);
                fgra = fea(1:GRA_LEN);
                fdst = fea(GRA_LEN+1:GRA_LEN+CONT_LEN/2);
                fgeo = fea(GRA_LEN+CONT_LEN/2+1: GRA_LEN+CONT_LEN/2+GEO_LEN);
                fmea = [fea(GRA_LEN+CONT_LEN/2+1:GRA_LEN+CONT_LEN/2+2), ...
                    fea(GRA_LEN+CONT_LEN/2+25:GRA_LEN+CONT_LEN/2+GEO_LEN)];
                fco = fea(GRA_LEN+CONT_LEN/2+GEO_LEN+1:GRA_LEN+CONT_LEN/2+GEO_LEN+COO_LEN);
                small_flag = 0;
            else
                small_flag = 1;
            end
        end				% PASS_ID end
        if ~small_flag
          fprintf(fid_nam, '%s\n', imfile);
          fprintf(fid_mea, '%9.4f %9.4f %9.4f %9.4f %9.4f %9.4f %9.4f\n', ...
                        fmea);
          fwrite(fid_gra, fgra, 'float');
          fwrite(fid_dst, fdst, 'float');
          fwrite(fid_geo, fgeo, 'float');
          fwrite(fid_coo, fco, 'float');
        end					% end if small_flag
      end					% end imnum
      fclose(fid_nam);				
      fclose(fid_mea);
      fclose(fid_gra);
      fclose(fid_dst);
      fclose(fid_geo);
      fclose(fid_coo);
      fprintf('Processed Tow %d Day %s Hour %d roi 1 to %d\n', ...
               tow, day, hour, imnum);  
    else
      fprintf('There is no %s data in Tow %d Day %s Hour %d\n', ...
               taxastr, tow, day, hour);  
    end					% end if there is this taxa data in hour
  end					% end of taxa loop
end					% end of hour loop

