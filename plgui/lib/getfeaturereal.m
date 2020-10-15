function [feature,meas] = getfeaturereal(imfile, types)
% EXTRACTPL extract features from a list of image/template files.
% ***************************************************************************

%	8/11/95	Xiaoou Tang	Created
% ***************************************************************************

  global GRA_LEN GEO_LEN AREA_THRESH CONT_LEN COO_LEN 
feature = [];
GEO_LEN =29;
CONT_LEN =256;
  fid = fopen(imfile);
  fea = fread(fid,'float')';
  fclose(fid);
  gra = fea(1:GRA_LEN); 
  dst = fea(GRA_LEN+1:GRA_LEN+CONT_LEN/4);
  geo = fea(GRA_LEN+CONT_LEN/2+1: GRA_LEN+CONT_LEN/2+GEO_LEN);
  coo = fea(GRA_LEN+CONT_LEN/2+GEO_LEN+1:end);
  geo = geo(12:20);
  meas = [fea(160+128+1:160+128+2),fea(160+128+25:160+128+29)];
  for i = 1: size(types,1)
    com = ['feature = [feature ',types(i,:),'];'];
    eval(com)
  end

%v1 = [peri area euler mx my u20 u02 u11 E1 E2 th]; 11
%v2 = [p1 p2 p3 p4 p5 p6 p7 E sf]; 12:20  
%v3 = [dc1,dc2,dc3,db1,db2]; db1 is short bond, 21:29
% use 12:24



