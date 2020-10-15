function [tcs]=ms2tc(ms);
%function [tcs]=ms2tc(ms);
%converts milliseconds since midnight to equivalent time code
%returned as a string in hh:mm:ss:ff  where ff is frame # (0 to 29)


fd=ms/86400000*24;%time of day in decimal hours
hh=floor(fd);
mm=floor((fd-hh)*60);
ss=floor(((fd-hh)*60-mm)*60);
ff=floor((((fd-hh)*60-mm)*60-ss)*30);

h0='';if length(num2str(hh))==1,h0='0';end;
m0='';if length(num2str(mm))==1,m0='0';end;
s0='';if length(num2str(ss))==1,s0='0';end;
f0='';if length(num2str(ff))==1,f0='0';end;

tcs=[h0 num2str(hh) ':' m0 num2str(mm) ':' s0 num2str(ss) ':' f0 num2str(ff)];

