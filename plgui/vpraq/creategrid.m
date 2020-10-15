function [] = creategrid(nx,ny,vn,b);
%using the  data matrix b, 
%saves the x,y,z file for gridding the specified variable number, vn
%i.e., 1=temp, 2=salt, 3=sigm, 4=fluo, 5=atte, 6=light
%then runs makegrid using the specified grid size, nx, ny
%also w/ optional input of edited data in matrix b

vs1=str2mat('temp','salt','sigm','fluo','obs','light');
vs = deblank(vs1(vn,:));

% b is the data matrix that has passed through the limits in plotsetup
% 1:dtime, 2:pcodelat, 3:pcodelon, 4:pressure, 
% 5:temp, 6:Sal, 7:sigma, 8:fluo, 9: obs, 10:light

%calc distance traveled between data points from lat lon
[range,af,ar]=dist(b(:,2),b(:,3));
range=[0 range/1000];
x=cumsum(range)';  

%prepare data set for gridding
z=b(:,4);
press=[x z];
save tmp/press press
eval(['tmp1=[x z b(:,' num2str(vn+4) ')];']);
eval(['save tmp/' vs '.dat tmp1 -ascii']);
cd tmp
dos(['c:\cygwin\bin\bash -c "c:/cygwin/bin/sh ./mgridders ' vs '.dat ' vs '.grd ' num2str(nx) ' ' num2str(ny) '"']);
cd ..
