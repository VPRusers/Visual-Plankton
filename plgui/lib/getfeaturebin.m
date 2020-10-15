function [fgra,fdst,fgeo,fbgr] = getfeature(imfiles)
% EXTRACTPL extract features from a list of image/template files.
% ***************************************************************************

%	8/11/95	Xiaoou Tang	Created
% ***************************************************************************

  imnum = size(imfiles,1);
  global GRA_LEN GEO_LEN AREA_THRESH CONT_LEN
  fgra = zeros(imnum,GRA_LEN);
  fgeo = zeros(imnum,GEO_LEN);
  fdst = zeros(imnum,CONT_LEN/2);
  fbgr = zeros(imnum,GRA_LEN);

for i = 1:imnum, 			% foreach image and template file
  imfile = deblank_t(imfiles(i,:)); %disp(['image name: ',imfile]);
  fid = fopen(imfile);
  fea = fread(fid,'float')';
  fclose(fid);
    fgra(i,:) = fea(1:160); 
    fdst(i,:) = fea(161:160+CONT_LEN/2);
    fgeo(i,:) = fea(160+CONT_LEN/2+1: 160+CONT_LEN/2+GEO_LEN);
%    fbgr(i,:) = fea(160+CONT_LEN/2+GEO_LEN+1: length(fea));
end
disp(['Got features']);

%v1 = [peri area euler mx my u20 u02 u11 E1 E2 th]; 11
%v2 = [p1 p2 p3 p4 p5 p6 p7 E sf]; 12:20  
%v3 = [dc1,dc2,dc3,db1,db2]; db1 is short bond, 21:29
% use 12:24



