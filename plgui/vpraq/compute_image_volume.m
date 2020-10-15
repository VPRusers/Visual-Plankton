function [image_volume, mm2pp]=compute_image_volume
%Computes or acquires the imaged volume from calibration file (e.g. c:\data\shunyo\calibration\imvol_dim.mat)
%If image volume was entered directly, this program just uses that value.
%The computed method sums the volumes of the four truncated triangular prism-shaped volumes 
%that make up the imaged volume.  Each prism volume is defined by two edges of the imaged volume
%at the corners of the field of view and the center line.
%The image_volume is in milliliters.

 
global basepathcruise cruise

eval(['load ' basepathcruise '\calibration\imvol_dim']);%loads the variables calibdata, camres, imvol, and magsetting

a=fieldnames(calibdata);
a=str2mat(a);
for j=1:size(a,1), eval([deblank(a(j,:)) '=str2num(calibdata.' deblank(a(j,:)) ');']);end

if ~isempty(imvol),
    image_volume=str2num(imvol);
else
    ul=abs(uln-ulf)/10;%divide by 10 to convert from mm to cm
    ll=abs(lln-llf)/10;
    c=abs(cn-cf)/10;
    ur=abs(urn-urf)/10;
    lr=abs(lrn-lrf)/10;
    area=fh/10/2*fw/10/2;
    prism_left_volume=(ul+ll+c)/3*area;
    prism_top_volume=(ul+ur+c)/3*area;
    prism_bottom_volume=(ll+lr+c)/3*area;
    prism_right_volume=(ur+lr+c)/3*area;
    image_volume=prism_left_volume+prism_top_volume+prism_bottom_volume+prism_right_volume;
end

%compute single pixel area in square millimeters
%pixel dimensions for the digital AutoVPR camera are 1392 wide by 1024 high
%and pixels are square so only need to use one dimension, choose x

npx=str2num(camres(1:findstr('x',camres)-1));
npy=str2num(camres(findstr('x',camres)+1:end));
mm2pp=((fw/npx)*(fh/npy));
