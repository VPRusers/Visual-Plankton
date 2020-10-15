function scatter_shape(t, nc, dim)
% scatter plot

% 11/8/95, X. Tang created

clg
disp([sprintf('Class number is %d, feature vector dimention is %d', ...
      nc, dim)]);

[len dum] = size(t);

% nc = 8;
clcount = [0:nc-1];   %**
sl = len/nc;

pmark = ['s';'t';'d';'i';'o';'+';'x';'*'];
pmark1 = ['r.';'c.';'w.';'g.';'yo';'m+';'gx';'b*'];
%pmark1 = ['r+';'cx';'w*';'go';'yo';'m+';'gx';'b*'];

%pmark1 = ['r.';'cx';'w*';'go';'y.';'m.';'g.';'b*'];

k =1;
for i = (1:2:dim)
%   subplot(ceil(dim/4),2,k)
   subplot(ceil((dim-2)/4),2,k);hold on
    for cl = 1:nc  %**
       cc = clcount(cl);
       plot(t(cc*sl+1:cc*sl+sl,i),t(cc*sl+1:cc*sl+sl,i+1),pmark1(cc+1,:))
%       xlabel(sprintf('feature # %d',i));
%       ylabel(sprintf('feature # %d',i+1));
%       axis('equal')   %**
       hold on
   end
%   AX = max(t(:,i))-min(t(:,i));
%   AY = max(t(:,i+1))-min(t(:,i+1));
%   for cc = 0:nc/2-1
%       plotshapes(t(cc*sl+1:cc*sl+sl,i),t(cc*sl+1:cc*sl+sl,i+1),pmark(cc+1,:))
%       hold on
%   end
   vec = axis;
   AX = vec(2)-vec(1);
   AY = vec(4)-vec(3);
   global AX AY
   for cl = 1:nc/2
       cc = clcount(cl);
       plotshapes(t(cc*sl+1:cc*sl+sl,i),t(cc*sl+1:cc*sl+sl,i+1),pmark(cc+1,:))
       hold on
   end
   k = k+1;
end
hold off

%gtext('Figure 8. KLT on the whole runlength matrices') 
%gtext('Figure 9. KLT on the whole runlength pixel number matrices')
%gtext('Figure 10. KLT on the first column of runlength matrices') 
%set(gca,'XTick', []);
%set(gca,'YTick', []);
% set(gca,'Color',[1 1 1])

