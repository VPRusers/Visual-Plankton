function [r,g,b] = tiffread(filename)
%TIFFREAD Read a TIFF (Tagged Image File Format) file from disk.
%   Note: TIFFREAD has been grandfathered; use IMREAD instead.
%
%   [R,G,B] = TIFFREAD('filename') reads the TIFF file 'filename'
%   and returns the RGB image in the matrices R,G,B. 
%
%   [X,MAP] = TIFFREAD('filename') reads the file 'filename' and
%   returns the indexed image X and associated colormap MAP.
%   [X,MAP] is created via uniform quantization if the file
%   contains an RGB image.
%       
%   TYPE = TIFFREAD('filename') reads the file header and returns
%   24 if the image is an RGB image, 8 if it is an 8-bit indexed
%   image, 4 if it is a 4-bit indexed image, or 1 if it is a
%   1-bit (binary) indexed image.
%
%   If no extension is given with the filename, the extension
%   '.tif' is assumed.
%
%   Gray (intensity) and binary images are returned as indexed
%   images with a gray colormap.  Use IND2GRAY after reading the
%   file to create an intensity image.  For example,
%     [X,map] = tiffread('grayimage.tif');
%     I = ind2gray(X,map);
%
%   See also IMFINFO, IMREAD, IMWRITE.

%   updated to call IMREAD, Chris Griffin 8-15-96
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 5.6 $  $Date: 1997/11/24 15:36:29 $


if isempty(findstr(filename,'.'))
        filename=[filename,'.tif'];
end;

[info,msg] = imfinfo(filename,'tif');
if ~isempty(msg), 
    error(msg);
end

if nargout==1
    r = info.BitsPerSample;
    return;
end

[X,map] = imread(filename,'tif');

if isempty(map) 
    sizeX = size(X);
    if ndims(X)==3 & sizeX(3)==3    % RGB Image
       r = double(X(:,:,1))/255;
       g = double(X(:,:,2))/255;
       b = double(X(:,:,3))/255;
    elseif ndims(X)==2              
       if islogical(X)              % Binary imag
          [r,g] = gray2ind(X,256);
          if isa(r, 'uint8'), r = double(r)+1; end        
       else                         % Grayscale Intensity imag
          [r,g] = gray2ind(X,256);
          if isa(r, 'uint8'), r = double(r)+1; end    
       end
    end
else                                % Indexed Image
    r = double(X)+1;
    g = map;
end
