function [im, map] = rasread(filename,rows)
% RASREAD read the Sun raster image
% Inputs:
%    FILENAME, raster file name
%    ROWS, optional 2 element vector defining start and end rows to read
% Output:
%    IM, image array
%    MAP, optional colormap

im = 0;
if (filename((length(filename)-2):length(filename)) == 'tif')
  if nargin > 1,
    disp('Sorry, all rows must be read in with tiff images.');
  end;
  [im map] = tiffread(filename);

  % fix sign bit nonsense
  a = find(im == 256);  im(a) = im(a) - 256;

  return
end
if (filename((length(filename)-2):length(filename)) == 'mat')
  if nargin > 1,
    disp('Sorry, all rows must be read in with matlab images.');
  end;
  % assumes "im" and "map"  are variables saved in this Mat file
  eval(['load ' filename ]); 
  return
end

% procede trying to read Sun raster...
fid = fopen(filename,'r');
hdr = fread(fid,8,'uint');
if hdr(1) ~= hex2dec('59a66a95'),
  error('Unknown raster format');
end;
width = hdr(2);height = hdr(3);
depth = hdr(4);type = hdr(6);
maplen = hdr(8);


% read cmap and normalize it to matlab's [0,1] scale convention
if maplen,
  map = fread(fid,[maplen/3 3],'uchar')/256;
else
  map = gray(256);			% default colormap
end;

% read in the image
if (depth == 8)
  precision = 'uchar';
elseif (depth == 32)
  precision = 'float32'
end;


if (nargin > 1)
  % read in only the specified rows
  fseek(fid,rows(1)*(width*depth/8),0);
  height = rows(2)-rows(1)+1;
end;

im = fread(fid,[width,height],precision);
% reorient the matrix for display
im=im';
%      nr=size(im,1);nc=size(im,2);
fclose(fid);

%      imshow(im); colormap('gray(256)');drawnow

