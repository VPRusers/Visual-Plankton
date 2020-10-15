function [] = focus;
%[] = focus  computes the level of focus of a set of image files 
%in the current directory. focus is determined
%by computing the standard deviation of the difference
%between the image and the median filter of the image (medfilt2)
%using a  filter size from 3x3 to 8x8, scaled by image size.  
%note that the image is first normalized to 200.
%press a key to go to the next image

[s,w]=unix('ls -1');
%[s,w]=unix('cat /files3/e302/autoid/cam4/DIAT_CHSOC/aid/aid.d167.h03');
i=find(w==setstr(10));
len=length(find(w==setstr(10)));

for j=2:len;fn=w(i(j-1)+1:i(j)-1);

[z,map] = tiffread(fn);
%z=z(25:180,100:512);%crop the image if needed (eg to remove time code)
figure(1);%to view the image
image(z);axis([0 512 0 256]);colormap(map);

%figure;%to surf the image
%surf(flipud(z));colormap(map);shading flat;rotate3d on;view(-20,75);

z=(z-min(min(z)))/(max(max(z))-min(min(z)))*200;%normalize the image to 200

%figure(3);
%z4=z;
%z4(z4>70)=200;
%image(z4);axis([0 512 0 256]);colormap(map);

%figure(4);
%hist(z(:),100);colormap(map);

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
%figure(2);%plot the original image minus the smoothed
%surf(flipud(z2-z3));colormap(map);shading flat;rotate3d on;view(-20,75);
f=std2(z2-z3);
disp([fn  '    focus= ' num2str(f)]);
%disp('focus= '),disp( f);
%disp('roisize= '),disp(sz);
%disp('medianwindowsize '),disp(m);

%fn=fn(38:length(fn));
title([fn(1:6) '\' fn(7) fn(8:9) '\' fn(10:length(fn)) '    focus= ' num2str(f)]);


pause;

end;