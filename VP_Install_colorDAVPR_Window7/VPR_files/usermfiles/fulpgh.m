function fulpg(dim)

if nargin<1
%	dim=[1.25 2.5 6 7.25];
%        dim=[0.5 1.0 7.5 10];
        dim=[1.0 1.0 10 7.5];
end

dimp=[0 0 dim(3:4)];
%dimp=[0.5 0 dim(3) 7.0];

set(gcf,'units','inches','position',dimp,'paperposition',dim)
set(gcf,'paperorientation','landscape')