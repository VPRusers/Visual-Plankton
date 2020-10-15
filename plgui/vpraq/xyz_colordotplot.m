function [] = xyz_colordotplot(v,ms,mm,mk,mf,cbar,mm2);
%function [] = xyz_colordotplot(v,ms,mm,mk,mf,cbar,mm2);
%color dot plot of a variable versus latitude, longitude, and depth
%input a four column array where
%first column is longitude, second column is latitude, the third column 
%is depth, and the fourth column is the value of the dependent variable to be plotted.
%Basically this is just a 3D scatter plot of a 4-column matrix using
%64 color levels that span the range of values in the fourth column.
%Options:
%ms:  if a scalar, ms is the maximum markersize (1-64) (default is 1)
%     if a 2 element row vector, ms specifies the min and max markersize
%           for a single size marker, make the 2 elements of ms the same.
%mm is two element vector with [min,max] of values to be plotted
%using the specified color range, points outside this range are  
%    plotted as small gray dots.
%for a single color, make mm a 3-element color 
%array, e.g. [0 0 1] and a size dot plot for that color will be made.
%mk is the markertype (in quotes, '.' is default):
% +,o,*,.,x,square,diamond,v,^,>,<,pentagram,hexagram,none
%mf = 'filled' is option for filled markers, default is open symbols
%cbar = 1 draw colorbar; if cbar=0 don't; default is 1;
%mm2 is a 2 element vector [min,max] that over-rides mm and hard sets the 
%  color range (or dot size range for sizeonly plots); 
%  needed for global color range on multipanel plots.


%figure;
sizeonlyflag=0;
if nargin>2,
    if ~isempty(mm),
        if length(mm)<3,
            vout=v(v(:,4) < mm(1) | v(:,4) > mm(2),:);
            v=v(v(:,4) >= mm(1) & v(:,4) <= mm(2),:);
        else
            sizeonlyflag=1;
        end
    end
end


if nargin==1,
    msf=0;
    ms1=1;
elseif length(ms)==1,
    msf=(ms-1)/64;
    ms1=1;
elseif length(ms)==2,
    msf=(ms(2)-ms(1))/64;
    ms1=ms(1);
end

if nargin<4,
    mk='.';
end

if nargin<5,
    mf='none';
end

if nargin<6,
    cbar=1;
end

if nargin<7,
    mm2=0;
end

colormap jet;
cm=colormap;%default colormap is jet
if nargin>=7,
    vmax=mm2(2);
    vmin=mm2(1);
else
    vmax=max(v(:,4));
    vmin=min(v(:,4));
end

if vmin==vmax,text(.5,.5,'No Data');return;end
mmv=[vmin:(vmax-vmin)/64:vmax];mmv=[mmv;mmv]';
hold on
for j=1:64,
    k=find(v(:,4)>=mmv(j,1) & v(:,4)<=mmv(j+1,1));
    if sizeonlyflag,
        if strcmp(mf,'none'),
            plot3(v(k,1),v(k,2),v(k,3),'marker',mk,'linestyle','none','markersize',msf*j+ms1,'color',mm);
        else
            plot3(v(k,1),v(k,2),v(k,3),'marker',mk,'linestyle','none','markersize',msf*j+ms1,'color',mm,'markerfacecolor',mm);
        end
    elseif strcmp(mf,'none'),
        plot3(v(k,1),v(k,2),v(k,3),'marker',mk,'linestyle','none','markersize',msf*j+ms1,'color',cm(j,:));
    else
        plot3(v(k,1),v(k,2),v(k,3),'marker',mk,'linestyle','none','markersize',msf*j+ms1,'color',cm(j,:),'markerfacecolor',cm(j,:));
    end
end;
ah=gca;

if nargin>2,
    if ~isempty(mm) & length(mm)<3,
        plot3(vout(:,1),vout(:,2),vout(:,3),'marker',mk,'linestyle','none','markersize',1,'color',[.5 .5 .5]);
    end
end
box on;
grid on;
xlabel('Longitude','fontsize',14);ylabel('Latitude','fontsize',14);zlabel('Depth','fontsize',14);
view(17,30);
set(gca,'fontsize',12);
set(gca,'units','normalized','position',[.2 .2 .6 .6]);
set(gca,'dataaspectratio',[1 1 300]);
axissnug;
cameratoolbar('show');
cameratoolbar('setmode','orbit');
axis vis3d;
hold off;

if cbar,
    axes('position',[0.9 0.3 0.02 0.4]);      
    if sizeonlyflag,
        hold on
        for j=ms1:msf*64/5:msf*64+ms1,
            if strcmp(mf,'none'),
                plot(0.5,j,'marker',mk,'markersize',j,'color',mm);
            else
                plot(0.5,j,'marker',mk,'markersize',j,'color',mm,'markerfacecolor',mm);
            end
        end
        text(ones(6,1)*3,ms1:msf*64/5:msf*64+ms1,num2str(10.^mmv(round(1:64/5:64+1),1)-1,2));
        axis off
    else    
        pcolor(mmv);
        shading('interp');
        set(gca,'xticklabel','');
        set(gca,'yticklabel','');
        set(gca,'fontname','timesnewroman','fontsize',8);
        text(.5,-2,num2str(mmv(1,1)));
        text(.5,70,num2str(mmv(65,1)));
        %h=ylabel('#/L');
        %set(h,'fontname','timesnewroman','fontsize',6);
        set(gca,'fontsize',8)
    end
end
hold off;
axes(ah);