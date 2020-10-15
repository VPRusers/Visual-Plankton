function [stat] = scatter_poly(fvec,mx,pnum)
% SCATTER  creates 2d scatter plots of a feature vector
% ***************************************************************************
% Inputs:
%    FVEC, an MxN matrix of M observations with N elements each
%    MX,   number of observations of each class.
% Usage:
%    [ps] = powerspec(x)

% History:       
%	5/10/95, X. Tang,     		Created.
%       9/20/95, X. Tang,               add plot number limit input
%***************************************************************************

hold on
[len dim] = size(fvec);
dim = min(dim, 16);			% plot maximum 16 features
if nargin == 3
   dim = min(dim,pnum);
end
nc = length(mx);
mx = cumsum(mx);
mx = [0;mx(:)];

s = ['ro'; 'g+'; 'yx'; 'b*'];
clor = ['w';'c';'m';'r';'g';'y';'b';'w'];
sides = [3, 3, 4, 4, 5, 6, 7, 8];
rotate = [0, 180, 0, 45, 90, 180, 0, 90];
minv = min(fvec)-abs(min(fvec))*0.05;
maxv = max(fvec)+abs(max(fvec))*0.05;  

for i = 1:2:dim-1
  subplot(dim/4,2,(i-1)/2+1)
  for cl = 1:4
    domain = mx(cl)+1:mx(cl+1);
    plot(fvec(domain,i),fvec(domain,i+1),s(cl,:))
    xlabel(sprintf('Feature # %d', i));
    ylabel(sprintf('Feature # %d', i+1));
%    set(gca,'XTickLabels','');
%    set(gca,'YTickLabels','');
    hold on
  end
  for cl = 5:nc
    k = cl-4;
    domain = mx(cl)+1:mx(cl+1);
    newpoly(fvec(domain,i),fvec(domain,i+1),2,2,clor(k,:),'n',sides(k), ...
             rotate(k), [minv(i),maxv(i)],[minv(i+1),maxv(i+1)]);
    xlabel(sprintf('Feature # %d', i));
    ylabel(sprintf('Feature # %d', i+1));
%    set(gca,'XTickLabels','');
%    set(gca,'YTickLabels','');
    hold on
  end     
end
hold off
drawnow					% flush graphics
