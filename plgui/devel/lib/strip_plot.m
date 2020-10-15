function strip_plot(x)

% use the matlab strips.m to plot mean-removed, max normalized x.
%        STRIPS(X) plots vector X in horizontal strips of length 250.
%        If X is a matrix, STRIPS(X) plots each column of X in horizontal
%        strips.

% Created 8/28/95 X. Tang
% ******************************************************************

row = size(x,1);
m = mean(x);
x = x-m(ones(row,1),:);

maxx = max(abs(x));
x = x./maxx(ones(row,1),:);
strips(x);