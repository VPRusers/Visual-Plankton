function [] = supervisbin3(imfiles, domain, imtype, roidisc, cruise, imcol, imrow, taxon)

if nargin < 3
  imtype = 1;
end
n = length(domain);
n = min(imcol*imrow, n);

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
  ah=subplot('position', position);
  name1 = deblank_ts(imfiles(domain(j),:));
  %do the following in case the rois have been moved after the autoid was done.
  name=deblank([roidisc '\' cruise '\rois\' name1(max(findstr(name1,'vpr')):length(name1))]);
  if exist(name),
      x = imread(name);
  else
      idx=findstr('.',name);
      name2=[name(1:idx(1)) num2str(str2num([name(idx(1)+1:idx(1)+10)])+8640000000,11) name(idx(2):end)];
      if exist(name2),
          x = imread(deblank(name2(1:length(name2))));
      else
          disp('ROI not found');
      end
  end

  ih=image(x);axis image;
  set(ih,'buttondownfcn','selectroi','userdata',{j,0,name1,name});
  set(ah,'box','on','xtick',[],'ytick',[],'xcolor','w','ycolor','w');
  xt=get(ah,'xlim');
  yt=get(ah,'ylim');
  eval(['th=text(xt(2)/2,yt(2)/2,''' taxon ''');']);
  set(th,'fontsize',12,'color','y','interpreter','none','horizontalalignment','center','rotation',30);
  set(th,'visible','off');
  drawnow
end

domain_imfile = imfiles(domain,:);

