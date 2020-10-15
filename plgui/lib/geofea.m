function [v1,v2,v3] = geofea(img, case1);

% compute geometrical feature of binary images 
% The origin is the upper left corner. X is the colum number, Y is the row 
% number from top to bottom.

%	8/16/95	Xiaoou Tang	Created
%       05/03/00 Qiao Hu Modified
%  09/14/01  Cabell Davis modified
% ***************************************************************************
if case1 == 1
  area = sum(sum(img));                  % area 
  if area < 9
    disp('object size too small');
  end
  peri = sum(sum(bwperim(img,4)));       % 4-connect perimeter
  euler = bweuler(img,8);                % 8-connect euler number
  [y,x] = find(img);
elseif case1 == 2			% img is the outline
  area = size(img,1); peri = area; euler = 0;
  x = img(:,1);
  y = img(:,2);
end

% computing first three order moments

m00 = area; m10 = sum(x); m01 = sum(y);
mx = m10/area;				% col number of the center       
my = m01/area;        			% row number of the center
xx = x.*x; yy = y.*y; 
m20 = sum(xx);				% second vertical moment	
m02 = sum(yy);				% second horiz moment
m11 = sum(x.*y);
m30 = sum(x.*xx);
m12 = sum(x.*yy);
m21 = sum(xx.*y);
m03 = sum(y.*yy);

u00 = m00; u20 = m20-mx*m10; u02 = m02-my*m01;
u11 = m11 - my*m10; 
u30 = m30 - 3*mx*m20 + 2*m10*mx*mx;
u12 = m12 - 2*my*m11 - mx*m02 + 2*my*my*m10;
u21 = m21 - 2*mx*m11 - my*m20 + 2*mx*mx*m01;
u03 = m03 - 3*my*m02 + 2*my*my*m01;

u_2 = u00*u00;
u_3 = u00^(5/2);
n20 = u20/u_2; n02 = u02/u_2; n11 = u11/u_2;
n30 = u30/u_3; n12 = u12/u_3; n21 = u21/u_3; n03 = u03/u_3;

% computing invariant moments

p1 = n20+n02;
p2 = (n20-n02)^2 + 4*n11*n11;
p3 = (n30-3*n12)^2 + (3*n21-n03)^2;
p4 = (n30+n12)^2 + (n21+n03)^2;
p5 = (n30-3*n12)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) ...
     +(3*n21-n03)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2);
p6 = (n20-n02)*((n30+n12)^2-(n21+n03)^2)+4*n11*(n30+n12)*(n21+n03);
p7 = (3*n21-n30)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) ...
     +(3*n12-n30)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2); 

a = u20;   				% second moment around horiz
c = u02;   				% second moment around vert.
b = -2*u11;
[E1,E2,th] = princ_moment(a,c,b); 	% principle moments

sf = peri*peri/(4*pi*area);  		% shape factor
E = E1/E2;
[dc1,dc2,dc3,db1,db2] = wid_geofea(th, mx, my, [x y]); % db2 is long bond

peri = bperi(img);
area = barea(img);
%v3 = bwids([dc1,dc2,dc3,db1,db2],th,cam);
v1 = [peri area euler mx my u20 u02 u11 E1 E2 th];
v2 = [p1 p2 p3 p4 p5 p6 p7 E sf];
v3 = [dc1,dc2,dc3,db1,db2];


