%function [] = testfocus;
%[] = testfocus  computes the level of focus of a set of image files 
%in the current directory. focus is determined
%by computing the standard deviation of the difference
%between the image and the median filter of the image (medfilt2)
%using a  filter size from 3x3 to 8x8, scaled by image size.  
%note that the image is first normalized to 200.
%press a key to go to the next image
%this version computes focus level for rois in in-focus out-of-focus 
%subdirectories, i.e., /files1/home/xtang/testimg/foc and 
%/files1/home/xtang/testimg/unf and plots the values.


cd /files1/home/xtang/testimg/foc
[s,w]=unix('ls -1');
i=find(w==setstr(10));
len=length(find(w==setstr(10)));

for j=2:len;fn=w(i(j-1)+1:i(j)-1);

   [z,map] = tiffread(fn);

   z=(z-min(min(z)))/(max(max(z))-min(min(z)))*200;%normalize the image to 200

   m=sqrt(size(z,1)*size(z,2))/(2/3*100)+3;
   %sz=sqrt(length(find(z(:)>70)));
   %m=floor(sz/50+2);
   m=floor(m);
   n=m;
   sz=size(z);

   z1=medfilt2(z,[m n]);
   i1=ceil(m/2);j1=ceil(n/2);
   i2=size(z,1)-i1;j2=size(z,2)-j1;

   z2=z(i1:i2,j1:j2);
   z3=z1(i1:i2,j1:j2);
   f1(j)=std2(z2-z3);
   disp([fn  '    focus= ' num2str(f1(j))]);

end;

cd /files1/home/xtang/testimg/unf
[s,w]=unix('ls -1');
i=find(w==setstr(10));
len=length(find(w==setstr(10)));

for j=2:len;fn=w(i(j-1)+1:i(j)-1);

   [z,map] = tiffread(fn);

   z=(z-min(min(z)))/(max(max(z))-min(min(z)))*200;%normalize the image to 200

   m=sqrt(size(z,1)*size(z,2))/(2/3*100)+3;
   %sz=sqrt(length(find(z(:)>70)));
   %m=floor(sz/50+2);
   m=floor(m);
   n=m;
   sz=size(z);

   z1=medfilt2(z,[m n]);
   i1=ceil(m/2);j1=ceil(n/2);
   i2=size(z,1)-i1;j2=size(z,2)-j1;

   z2=z(i1:i2,j1:j2);
   z3=z1(i1:i2,j1:j2);
   f2(j)=std2(z2-z3);
   disp([fn  '    focus= ' num2str(f2(j))]);

end;


plot(1:length(f1),f1,'o',1:length(f2),f2,'x');
grid on;
