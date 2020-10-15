function [fgra,fdst,fgeo] = getfeature(imfiles)
% EXTRACTPL extract features from a list of image/template files.
% ***************************************************************************

%	8/11/95	Xiaoou Tang	Created
% ***************************************************************************

  imnum = size(imfiles,1);
  global GRA_LEN GEO_LEN AREA_THRESH CONT_LEN
  fgra = zeros(imnum,GRA_LEN);
  fgeo = zeros(imnum,GEO_LEN);
  fdst = zeros(imnum,CONT_LEN/2);

for i = 1:imnum, 			% foreach image and template file
%  i
  imfile = deblank_t(imfiles(i,:)); %disp(['image name: ',imfile]);

  fid = fopen(imfile);
  fea = fread(fid,'float')';
  fclose(fid);
  if 0 %fea(161) < AREA_THRESH    **             % if object too small, discard
    fgra(i,:) = zeros(1,GRA_LEN);  % disp(['object too small, for getfeature'])
    fdst(i,:) = zeros(1,CONT_LEN/2);
    fgeo(i,:) = zeros(1,GEO_LEN);
  else
    fgra(i,:) = fea(1:160); 
    lenf = length(fea); contlen = (lenf-164)/2;
    cont = [fea(165:(164+contlen))' fea((164+contlen+1):lenf)'];
    dist = cont_intp(cont, CONT_LEN);
    fdst(i,:) = fds(dist)';
 
   [v1,v2,v3] = geofea(cont, 2);         % ** add gray scale features
   v1(1:2) = fea(161:162);		% 
   fgeo(i,:) = [v1 v2 v3(1:4)/v3(5) v3 ];
%   figure(1)
  end
end
disp(['Got features']);
if 0
for j = 1:size(types,1)
  type = ['f',deblank(types(j,:))]
  com = ['feat = [feat ', type, '];']
  eval(com)
end
%    fgeo(i,:) = [v1 v2 xm, v3];
%v1 = [peri area euler mx my u20 u02 u11 E1 E2 th]; 11
%v2 = [p1 p2 p3 p4 p5 p6 p7 E sf]; 12:20  
%v3 = [dc1,dc2,dc3,db1,db2]; db1 is short bond, 21:29
% use 12:24
end


