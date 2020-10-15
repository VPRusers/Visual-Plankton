% JPEG2AVI
%
% create avi-movie from single frames (jpeg-images)
%
% Author: P. Knott, 06 May 2004

% frames/images:
fpath= 'C:\My Files\steve\copepod_movie\h00_resized\';
imglist= dir([fpath '*.jpg']);				% edit path/filename to match your images' location

% default-parameters:
fps= 20;														% frames per second
fname= 'C:\My Files\steve\copepod_movie\copepods.avi';						% path/name of movie output file
codec= 'hfyu';												% video codec (FOURCC), I use HuffYUV ('hfyu') because it is lossless

% create movie:
for k= 1:length(imglist);
	img= imread([fpath imglist(k).name]);			% get current frame
	m(k)= im2frame(img);
	if rem(k, 100) == 0
		disp([num2str(k) ' frames processed...'])
%		drawnow
	end
end

% create avi:
movie2avi(m, fname, 'compression', codec, 'fps', fps);

% play result:
movie(m, 1, fps)