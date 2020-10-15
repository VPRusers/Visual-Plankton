function [xwid, ywid, imrow, imcol, btnarea, domain_imfile] = supervisbin2(imfiles, domain, imtype, disc, cruise)
%domain = [1:16];

global WIN_WID WIN_HEIGHT IMCOL IMROW

if nargin < 3
  imtype = 1;
end
n = length(domain);
imcol = IMCOL; imrow = IMROW;

n = min(imcol*imrow, n);
%defaultPos=get(0,'DefaultFigurePosition');
btnarea = .18; %90/defaultPos(4) +.02;
ttlarea = .0;
xwid = 1/imcol;			% sublot window width
ywid = (1-btnarea-ttlarea)/imrow;

for j = 1:n
  if rem(j,imcol) == 0
    col = imcol;
  else
    col = rem(j,imcol);
  end
  row = ceil(j/imcol);

  position = [(col-1)*xwid, (imrow-row)*ywid+btnarea, xwid, ywid];
  subplot('position', position); 
  name = deblank_ts(imfiles(domain(j),:));
  %do the following in case the rois have been moved after the autoid was done.
  name=[disc '\' cruise '\rois\' name(findstr(name,'vpr'):length(name))];
  
  clear x
  if imtype == 1
    [x, map] = imread(name(1:length(name)-1));
  else
    [x, map] = rasread(name); 
  end
  [nr,nc] = size(x);
  xx = zeros(nr,nc);
  xx(2:2:2*nr,:) = x;
  xx(1:2:2*nr-1,:) = x;  
  x = xx; clear xx;
  nr = nr*2;

%  fprintf('image size is %dx%d \n',size(x,1),size(x,2)) 
%  cla;set(gca,'visible','off');
  ih=image(x);
  set(ih,'tag',[num2str(j)],'buttondownfcn','imselect');
  p1=3*pi/2;p3=2*pi;p2=(p3-p1)/256;
  map=[(p1:p2:p3)', (p1:p2:p3)', (p1:p2:p3)'];
  map=cos(map).^4;
  colormap(map);brighten(.8);%drawnow; 
  if nr < floor(WIN_HEIGHT*ywid) & nc < floor(WIN_WID*xwid)
    % use truesize for small image, scale down large image to window size.
    axis([1 floor(WIN_WID*xwid) 1 floor(WIN_HEIGHT*ywid)]);
  else
    axis([1 max(nr, nc) 1 max(nr, nc)]);
  end
  drawnow
  set(gca,'visible','off');
end

domain_imfile = imfiles(domain,:);

