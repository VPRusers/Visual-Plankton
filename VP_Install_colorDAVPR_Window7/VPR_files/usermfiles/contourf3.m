function [cout,H,CS] = contourf3(varargin)
%CONTOURF Filled contour plot.
%   CONTOURF(...) is the same as CONTOUR(...) except that the contours
%   are filled.
%
%   C = CONTOURF(...) returns contour matrix C as described in CONTOURC
%   and used by CLABEL.
%
%   [C,H,CF] = CONTOURF(...) also returns a column vector H of handles
%   to PATCH objects and the contour matrix CF for the filled areas.
%
%   Example:
%      z=peaks; contourf(z), hold on, shading flat
%      [c,h]=contour(z,'k-'); clabel(c,h), colorbar
%
%   See also CONTOUR, CONTOUR3, CLABEL, COLORBAR.

%   Author: R. Pawlowicz (IOS)  rich@ios.bc.ca   12/14/94
%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 1996/08/12 23:01:02 $

error(nargchk(1,5,nargin));

% Check for empty arguments.
for i = 1:nargin
  if isempty(varargin{i})
    error ('Invalid Argument - Input matrix is empty');
  end
end

% Trim off the last arg if it's a string (line_spec).
nin = nargin;
if isstr(varargin{end})
  [lin,col,mark,msg] = colstyle(varargin{end});
  if ~isempty(msg), error(msg); end
  nin = nin - 1;
else
  lin = '';
  col = '';
end

if (nin == 4),
   [x,y,z,nv] = deal(varargin{1:4});
   if (size(y,1)==1), y=y'; end;
   if (size(x,2)==1), x=x'; end;
   [mz,nz] = size(z);
elseif (nin == 3),
  [x,y,z] = deal(varargin{1:3});
  nv = [];
  if (size(y,1)==1), y=y'; end;
  if (size(x,2)==1), x=x'; end;
  [mz,nz] = size(z);
elseif (nin == 2),
  [z,nv] = deal(varargin{1:2});
  [mz,nz] = size(z);
  x = 1:nz;
  y = (1:mz)';
elseif (nin == 1),
  z = varargin{1};
  [mz,nz] = size(z);
  x = 1:nz;
  y = (1:mz)';
  nv = [];
end

if nin <= 2,
    [mc,nc] = size(varargin{1});
    lims = [1 nc 1 mc];
else
    lims = [min(varargin{1}(:)),max(varargin{1}(:)), ...
            min(varargin{2}(:)),max(varargin{2}(:))];
end

i = find(isfinite(z));
minz = min(z(i));
maxz = max(z(i));

% Generate default contour levels if they aren't specified 
if length(nv) <= 1
  if isempty(nv)
    CS=contourc([minz maxz ; minz maxz]);
  else
    CS=contourc([minz maxz ; minz maxz],nv);
  end

  % Find the levels
  ii = 1;
  nv = [];
  while (ii < size(CS,2)),
    nv=[nv CS(1,ii)];
    ii = ii + CS(2,ii) + 1;
  end
end

% Handle interior holes correctly
draw_min=1;

% I've removed the following code because it makes contourf
% leave holes just because the user passed in a value in nv
% that is below the surface.  I'm not sure that is the correct
% behavior.  CMT 22-May-1996
%if 0 & any(nv < minz),
%  draw_min=0;
%end;

% Get the unique levels

nv = sort([minz nv maxz]);
zi = [1, find(diff(nv))+1];
nv = nv(zi);

% Surround the matrix by a very low region to get closed contours, and
% replace any NaN with low numbers as well.

zz=[ repmat(NaN,1,nz+2) ; repmat(NaN,mz,1) z repmat(NaN,mz,1) ; repmat(NaN,1,nz+2)];
kk=find(isnan(zz(:)));
zz(kk)=minz-1e4*(maxz-minz)+zeros(size(kk));

xx = [2*x(:,1)-x(:,2), x, 2*x(:,nz)-x(:,nz-1)];
yy = [2*y(1,:)-y(2,:); y; 2*y(mz,:)-y(mz-1,:)];
if (min(size(yy))==1),
  [CS,msg]=contours(xx,yy,zz,nv);
else
  [CS,msg]=contours(xx([ 1 1:mz mz],:),yy(:,[1 1:nz nz]),zz,nv);
end;
if ~isempty(msg), error(msg); end

% Find the indices of the curves in the c matrix, and get the
% area of closed curves in order to draw patches correctly. 
ii = 1;
ncurves = 0;
I = [];
Area=[];
while (ii < size(CS,2)),
  nl=CS(2,ii);
  ncurves = ncurves + 1;
  I(ncurves) = ii;
  xp=CS(1,ii+(1:nl));  % First patch
  yp=CS(2,ii+(1:nl));
  Area(ncurves)=sum( diff(xp).*(yp(1:nl-1)+yp(2:nl))/2 );
  ii = ii + nl + 1;
end

newplot;
if ~ishold,
  view(2);
  set(gca,'xlim',lims(1:2),'ylim',lims(3:4))
end

% Plot patches in order of decreasing size. This makes sure that
% all the leves get drawn, not matter if we are going up a hill or
% down into a hole. When going down we shift levels though, you can
% tell whether we are going up or down by checking the sign of the
% area (since curves are oriented so that the high side is always
% the same side). Lowest curve is largest and encloses higher data
% always.

H=[];
[FA,IA]=sort(-abs(Area));
if ~isstr(get(gca,'color')),
  bg = get(gca,'color');
else
  bg = get(gcf,'color');
end
if isempty(col)
  edgec = get(gcf,'defaultsurfaceedgecolor');
else
  edgec = col;
end
if isempty(lin)
  edgestyle = get(gcf,'defaultpatchlinestyle');
else
  edgestyle = lin;
end
for jj=IA,
  nl=CS(2,I(jj));
  lev=CS(1,I(jj));
  if (lev ~=minz | draw_min ),
    xp=CS(1,I(jj)+(1:nl));  
    yp=CS(2,I(jj)+(1:nl)); 
    if (sign(Area(jj)) ~=sign(Area(IA(1))) ),
      kk=find(nv==lev);
      if (kk>1+sum(nv<=minz)*(~draw_min)), 
        lev=nv(kk-1);
      else 
        lev=NaN;         % missing data section
      end;
    end;

    if (isfinite(lev)),
      H=[H;patch(xp,yp,lev,'facecolor','flat','edgecolor',edgec,'linestyle',edgestyle)];
    else
      H=[H;patch(xp,yp,lev,'facecolor',bg,'edgecolor',edgec,'linestyle',edgestyle)];
    end;
  end;
end;

numPatches = length(H);
if numPatches>1
  for i=1:numPatches
    set(H(i), 'faceoffsetfactor', 0, 'faceoffsetbias', (1e-3)+(numPatches-i)/(numPatches-1)/30); 
  end
end

if nargout>0, 
  % Return contour matrix for unfilled contours
  cout=contours(x,y,z,nv);
end
