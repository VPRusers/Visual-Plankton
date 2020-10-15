function [filelist] = dosdir(roipath) 
filelist=[];
d = dir([roipath '\*.tif']);
n_files = size(d,1);
for (i = 1 : n_files(1))
   if d(i).bytes <300000
      filelist = [filelist,d(i).name,10];
   end % ignore the file larger than 300K which will crash the plp.   
end
