function [filelist] = dosdir3(roipath) 
filelist=[];
d = dir(roipath);
d=d([d.bytes]~=0);%only use files with something in them.
n_files = size(d,1);
for (i = 1 : n_files(1))
   filelist = [filelist,d(i).name,10];
end
