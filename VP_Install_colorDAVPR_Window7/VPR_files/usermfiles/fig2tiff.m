%fast figure capture and tiff write
%i.e., captures a matlab figure as a .tif file

fn=input('What do you want to name your tiff file>     ','s');

[x,map]=capture; 
%imwrite(x,map,'calanus.tif','tif');

imwrite(x,map,fn,'tif');
