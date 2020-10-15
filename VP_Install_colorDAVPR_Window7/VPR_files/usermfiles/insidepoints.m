function [inpts]=insidepoints(xpts,ypts)

xr=xpts;yr=ypts;
plot(xr,yr,'.');

disp('Left mouse button defines curve points')
disp('right button for end point');

hold on; 
x=[];
y=[];
button=1;
while button==1,
   [x1,y1,button]=ginput(1);
   x=[x1;x];
   y=[y1;y];
   if length(x)>1 ,
      plot(x,y);
   end;
end

inpts=[];                                  
for j=1:length(yr);
   idx=find(diff(sign(y-yr(j))));
   y1=y(idx);y2=y(idx+1);
   x1=x(idx);x2=x(idx+1);
   slope=(y2-y1)./(x2-x1);
   intercept=y1-slope.*x1;
   xi=(yr(j)-intercept)./slope;
   nwalls=length(find(xi>xr(j)));
   if mod(nwalls,2)~=0;
      inpts=[inpts;j];
   end
end

plot(xr(inpts),yr(inpts),'o')
   
