function [mmv] = xyz_sizedotplot(v,c);
%function [] = xyz_colordotplot(v);
%color dot plot of a variable versus latitude and longitude
%input v, a 4-column matrix with (lon,lat,depth,var)
%30 color levels that span the range of values in the dependent variable.

colormap(cmap4(1,30));
cm=colormap;
vmax=max(v(:,4));
vmin=min(v(:,4));
mmv=[vmin:(vmax-vmin)/30:vmax];mmv=[mmv;mmv]';
hold on
for j=1:30,
   k=find(v(:,4)>=mmv(j,1) & v(:,4)<=mmv(j+1,1));
   %plot3(v(k,1),v(k,2),v(k,3),'linestyle','.','markersize',(j+3)/2,'color',cm(j,:));
   plot3(v(k,1),v(k,2),v(k,3),'.','markersize',j/2,'color',c);
end;
box on;
grid on;
xlabel('Latitude');ylabel('Longitude');zlabel('Depth');
axis vis3d;
view(10,40);

