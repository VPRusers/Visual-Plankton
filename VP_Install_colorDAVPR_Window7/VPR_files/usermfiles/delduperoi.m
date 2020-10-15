clear
count=0;
cr=setstr(13);
lf=setstr(10);


%Establish the input and output files

filename1=input(['Enter filename containing list of rois:' cr lf],'s');
filename2=input(['Enter output filename' cr lf],'s');

fid2=fopen(filename2,'a');
fid1=fopen(filename1,'r');

%Determine how long your file is.....
[s,f]=unix(['wc ',filename1,' ']);
A=sscanf(f,'%f');totrois=A(1)-1;

%Read first line of data
  a=fgetl(fid1);            %First line contains totalsize
  a=fgetl(fid1);  
  size=sscanf([a(1:14)],'%f');
  s=a(5:24);
  mm=sscanf([s(12:13)],'%f');
  fprintf(fid2,'%s\n',s);

for k=1:totrois-1 
  b=fgetl(fid1);
  size2=sscanf([b(1:4)],'%f');
  s2=b(5:24);
  mm2=sscanf([s2(12:13)],'%f');
  if (size2~=size) | (size2==size & (mm2-mm)>1)
    fprintf(fid2,'%s\n',s2)
    size=size2;
    out=1;
    end
end

  
   


