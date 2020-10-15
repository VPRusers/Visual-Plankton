function [nxgrd,nygrd]=gridsize(pr)
%To calculate a gridsize using a constant density of
% data points per grid point, and assuming that you want
% a single grid point for every 2 dbars in the vertical

%Input variable is pressure (pr)
%The "bad" data points should be removed from pr prior to calculating x and y

%nygrd=fix((max(pr)-min(pr))/round(2/mean(abs(diff(pr)))))+1; %# of pressure grid points
%nygrd=floor(max(abs(pr))/2); %# of pressure grid points; denominator is bin depth in meters
%nygrd=floor(max(abs(pr))/5); %# of pressure grid points
%nygrd=floor(max(abs(pr))/20); %# of pressure grid points
nygrd=20;%fix the number of depth bins.
nxgrd=round((length(pr)/nygrd)/10); %Where the last number is the desired density of data points

%The x and y increments of total distance and pressure are calculated
% as:

%xincr=[0:totkm(length(totkm))/(x-1):totkm(length(totkm))];
%yincr=[min(pr):2:max(pr)];

%where totkm is the cumulative distance travelled
