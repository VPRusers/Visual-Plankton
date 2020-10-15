function extractplbin(cl_dir,rois_dir, imfiles, fea_dir,faxis_max, select_type, ...
    t1, t2, t3, t4, cl_method, x_mean, x_std, taxas,dir_autoid, day, hour, clfid, mship, cl_type)
% EXTRACTPL extract features from a list of image/template files.
% ***************************************************************************
% Inputs:
%    IMFILES, Input image file names
% Outputs:
%    FGEO, 	feature vector matix extracted from image lists, 
%    		each row is an observation.
% Usage:
% [fgeo, tpixels, tpixindex] = 
% 		extractpl(imfiles, templtfiles, dm, tps, nc,sigma)

% History:       
%	8/11/95	Xiaoou Tang	Created
%   1999-2005 modified by Q. Hu and C. Davis
% ***************************************************************************
taxas=char(taxas);
ifs = find(imfiles == 10); imnum = length(ifs);
global GRA_LEN GEO_LEN AREA_THRESH CONT_LEN COO_LEN PASS_ID
% PASS_ID;
%  fgra = zeros(imnum,GRA_LEN);
%  fgeo = zeros(imnum,GEO_LEN);
%  fdst = zeros(imnum,CONT_LEN/2);

a = '0';
small_flag = 0;
small_count = 0;
% if cl_type==1,%dual 
    types = str2mat('gra','dst','geo','coo');
% elseif cl_type==2,%COM-SVM
%     types = str2mat('coo');
% else%NN
%     types = str2mat('gra','dst','geo');
% end
machinetype = computer;
comd_str = ' !../sbin/pbin ';
if strcmp(machinetype(1:3), 'SGI');
    comd_str = ' !../sbin/pbinsgi ';
elseif strcmp(machinetype, 'SOL2');
    comd_str = ' !../sbin/pbin ';
elseif strcmp(machinetype, 'SUN4');
    comd_str = ' !../sbin/pbin ';
elseif strcmp(machinetype, 'PCWIN');
    comd_str = ['! ..',filesep,'sbin',filesep,'pbin_dos '];
else
    disp(['wrong type of operating system']);
end 
machinetype
%  load the classifier 
if cl_type==1,%DUAL
    dualclf =[cl_dir, clfid,'dual'];
    com = ['load ', dualclf];
    eval(com);
elseif cl_type==2,%SVM
    svmclf =[cl_dir, clfid,'svm']; 
    com = ['load ', svmclf];
    eval(com);
end

for j = 1:imnum, 			% foreach image and template file
    fprintf('********** Processing image number %d of %d ***********\r',j,imnum);
    imfile = deblank_ts([rois_dir, nthfile(imfiles, j)]); 
    if imfile(length(imfile)-4) == 'o';
        roiname = imfile;
    else
        roiname = [imfile,' '];
    end 
    if PASS_ID == 1 | PASS_ID == 3		% do extraction
        eval([comd_str, imfile])
        %		comd_str = ['-granul -outline ',imfile];
        %		plpmex(comd_str);
        [gra, cont] = readvector(rootname(basename(imfile)));
        fco = coocfeat(imfile);
        if length(cont) < AREA_THRESH                % if object too small, discard
            fea = zeros(1,2*GRA_LEN+CONT_LEN/2+GEO_LEN);
            disp(['object too small']); 
            small_count = small_count+1
            small_flag = 1;
        else
            fgra = gra;
            dist = cont_intp(cont, CONT_LEN);
            fdst = fds(dist)';
            [v1,v2,v3] = geofea(cont,2);         % ** add gray scale features
            fgeo = [v1 v2 v3(1:4)/v3(5) v3 ];
            
            fea = [fgra fdst fgeo fco'];
            feafile = [fea_dir, rootname(nthfile(imfiles, j)),'.dat'];
            
            fid = fopen(feafile,'w');
            fwrite(fid, fea, 'float');% load features
            fclose(fid);
            
            gra = fea(1:GRA_LEN); 
            dst = fea(GRA_LEN+1:GRA_LEN+CONT_LEN/4);
            geo = fea(GRA_LEN+CONT_LEN/2+1: GRA_LEN+CONT_LEN/2+GEO_LEN);
            geo = geo(12:20);
            meas = [fea(160+128+1:160+128+2),fea(160+128+25:160+128+29)];
            te_feature_all = [gra dst geo fco'];
        end 				% end of object too small
    else
        feafile = [fea_dir, rootname(nthfile(imfiles, j)),'.dat'];
        if exist(feafile, 'file') == 2   
            [te_feature_all, meas] = getfeaturereal(feafile, types);
        else
            small_flag = 1;
        end
    end					% end of PASS_ID if
    if (PASS_ID == 2 | PASS_ID == 3) & ~small_flag 	% classification
        if 1 % NORM_ON  ***
        %  disp(['  test feature normalization']); 
          te_feature_all = normalize(te_feature_all, x_mean, x_std);    
        end
        if cl_type==1,
            [aids, neuron] = clf_real(te_feature_all, faxis_max, select_type, ...
            t1, t2, t3, t4, cl_method, x_mean, x_std);
            taxastr = deblank(taxas(aids,:));            
            sample = te_feature_all(234:297);
            [Label, DecisionValue]= SVMClass(sample', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
            if Label ~=  aids, aids = -1; taxastr = 'unknown'; end
        elseif cl_type==2,
            sample = te_feature_all(234:297);
            [Label, DecisionValue]= SVMClass(sample', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
            taxastr = deblank(taxas(Label,:));
        else
            [aids, neuron] = clf_real(te_feature_all, faxis_max, select_type, ...
            t1, t2, t3, t4, cl_method, x_mean, x_std);
            taxastr = deblank(taxas(aids,:));
        end            

        if length(num2str(hour)) == 1
            a='0';
        else
            a = [];
        end    
        if ~exist([dir_autoid,taxastr],'dir'), 
            mkdir(dir_autoid,taxastr);
            mkdir([dir_autoid,taxastr],'aid');
            mkdir([dir_autoid,taxastr],'aidmea');
        end   
        
        if cl_type==1,
            clfidtype=[clfid 'dual'];
        elseif cl_type==2,
            clfidtype=[clfid 'svm'];
        elseif cl_type==3,
            clfidtype=[clfid 'nn'];
        end
        
        fil_nam = [dir_autoid, taxastr, filesep,'aid',filesep, clfidtype, 'aid.d', day, '.h', ...
                a, num2str(hour) ];
        fea_mea = [dir_autoid,taxastr, filesep,'aidmea',filesep, clfidtype, 'aid.mea.d', day,'.h',...
                a, num2str(hour)];
        fid_nam = fopen(fil_nam, 'a');
        fid_mea = fopen(fea_mea, 'a');
        fprintf(fid_nam, '%s\n', roiname);         % **
%         fprintf(fid_mea, '%10.2f', meas, mship(:, neuron));
        fprintf(fid_mea, '%10.2f', meas);
        fprintf(fid_mea, '\n'); 
        fclose(fid_nam);
        fclose(fid_mea);
    end				% end of PASS_ID 
    small_flag = 0; 					% reset small flag
end




