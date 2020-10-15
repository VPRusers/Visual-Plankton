function realtrain(tname,tows,cruise,discmat,taxas,domtr,TNET)

% Main program for training
% For real time application

%clear all
globvar('MACHINE',2);
setfile='PLsetpar';
if nargin<7,
  setfile = input('Parameter file name: ', 's'); 
  tname = input('Save trained classifier to file: ','s');
end

eval(setfile);
disc	= deblank(discmat(size(discmat,1),:)); 
ncruise	= deblank(cruise(size(cruise,1),:));
cl_dir	= [disc,filesep,ncruise,filesep,'clpar',filesep];
if ~exist(cl_dir,'dir'), dos(['mkdir ',cl_dir]); end

trainingfigure=figure;

segtrainbin(cl_dir, tname, tows, cruise,...
	discmat, taxas, combind, taxas_orig, types, type_len,domaintr, flen, select_type, TNET, TP, PN, cl_method, mslen);

% if COMBINE
%   taxas= taxacomb;
% end

close(trainingfigure);