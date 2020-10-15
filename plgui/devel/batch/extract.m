function [cof,mat,mat90,mat45,mat135] = extract(parafile)
% Extract feature vectors according to the parameter file parafile.

if nargin < 1,
  parafile = input('parameter file name: ','s');
end;
eval(parafile) 				% runs given parameter setup m-file

global DM ST NC BINNUM FEA_TYPE IMFILES
global NBSIZE DESLEV

load(IMFILES)            % the feature matrix name is 'xall'

if FEA_TYPE == 1
   [cof,mat,mat90,mat45,mat135] = fextract_co(xall, DM, ST, NC, BINNUM);
elseif FEA_TYPE == 2
   [cof mat] = fextract_run(xall, DM, ST, NC, BINNUM);
elseif FEA_TYPE == 3
   [cof mat] = fextract_freq(xall, DM, ST, NC);
elseif FEA_TYPE == 4
   [cof mat] = fextract_eg(xall, DM, ST, NC, BINNUM, NBSIZE);
elseif FEA_TYPE == 5
   [cof mat] = fextract_dc(xall, DM, ST, NC, BINNUM, NBSIZE);
elseif FEA_TYPE == 6
   [cof mat] = fextract_gd(xall, DM, ST, NC, BINNUM);
elseif FEA_TYPE == 7
   mat = fextract_sp1(xall, DM, ST, NC);
   cof = [];
elseif FEA_TYPE == 8
   mlev = DESLEV;
%  [cof mat] = fextract_wl(xall, DM, ST, NC, BINNUM, DESLEV);
   setwb('OBJTYP','wpt2','DATSIZ',[DM,DM],'DESLEV',mlev,'MAXLEV',mlev)
   cof = fextract_wl(xall, DM, ST, NC, BINNUM, mlev);
   mat = [];
elseif FEA_TYPE == 9
   [cof mat] = fextract_gran(xall, DM, ST, NC);
end

