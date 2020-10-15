function fulpg(dim)

if nargin<1
%	dim=[1.25 2.5 6 7.25];
        dim=[0.5 1.0 7.5 10];
end

dimp=[0 0 dim(3:4)];

set(gcf,'units','inches','position',dimp,'paperposition',dim)