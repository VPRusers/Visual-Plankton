% to look at rois in the current directory

WIN_WID = 800;
WIN_HEIGHT =600;
IMCOL = input('Col num: ');
IMROW = input('Row num: ');
global  WIN_WID WIN_HEIGHT IMCOL IMROW
a='0';
[dum w] = unix('ls -1'); 
%disp([w]);
start_file = input('Starting file number: ');
NUM = IMCOL*IMROW;
i=find(w==setstr(10)); 
imnum=length(find(w==setstr(10)));
imfiles=[];
for j=2:imnum;
  imfiles=str2mat(imfiles,w(i(j-1)+1:i(j)-1));
end;
imfiles(1,:)=[w(1:i(1)-1) blanks(size(imfiles,2)-length(w(1:i(1)-1)))];

sw = 1;			% set switch for continue options
for d = 1:ceil(imnum/NUM)
   if sw ~= 3
     domain = [(1+(d-1)*NUM):min(d*NUM,imnum)];
     disp(domain);
     fig = figure(1);clf;
     set(fig,'Position',[0 40 WIN_WID WIN_HEIGHT]);
     [xwid, ywid, imrow, imcol, btnarea, d_imfile]= supervisbin(imfiles, domain,1);
     sw = input('Continue (1), Next hour (2), Stop (3): ');  % 2,3 doesn't
     if sw==2|sw==3, break; end;
   else
     break;
   end
end
