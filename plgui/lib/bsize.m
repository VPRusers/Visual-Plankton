function [bx,by]=con2bug(cont)
% This is a function to transfer contour image to 
% block image.
% Generated by Qiao Hu. 01/31/00

x=cont(:,1); y=cont(:,2);
n=length(x);
x(n+1)=x(1);y(n+1)=y(1);
if y(n)<y(1) 
   dy=1;
elseif y(n)==y(1) 
   dy=0;
else 
   dy=-1;
end
index=1;
for i=1:n
   if(y(i)<y(i+1))
      if dy>0
         xx(index)=x(i);
         yy(index)=y(i);
         index=index+1;
      else 
         xx(index)=x(i);
         xx(index+1)=x(i);
         yy(index)=y(i);
         yy(index+1)=y(i);
         index=index+2;
      end
      dy=1;
   elseif y(i)>y(i+1)
      if dy <=0
         xx(index)=x(i);
         yy(index)=y(i);
         index=index+1;
      else 
         xx(index)=x(i);
         xx(index+1)=x(i);
         yy(index)=y(i);
         yy(index+1)=y(i);
         index=index+2;
      end
      dy=-1;
   else
      if dy>0
         xx(index)=x(i);
         yy(index)=y(i);
         index=index+1;
     else
         xx(index)=x(i);
         xx(index+1)=x(i);
         yy(index)=y(i);
         yy(index+1)=y(i);
         index=index+2;
      end
      dy=0;
   end
end
bx=[];by=[];
for i=min(yy):max(yy)
   id=find(yy==i);
   for j=1:2:length(id)
      if xx(id(j))>xx(id(j+1))
         up=xx(id(j)); low=xx(id(j+1));
      else 
         up=xx(id(j+1));low=xx(id(j));
      end   
      bx=[bx low:up];
      by=[by i*ones(1,up-low+1)];
   end
end


