function [] = scalebar(mmv,fignum);

figure(fignum);
axes('position',[0.93 0.45 0.01 0.1]);
pcolor(mmv);
shading('interp');
set(gca,'xticklabel','');
set(gca,'yticklabel','');
set(gca,'fontname','timesnewroman','fontsize',8);
text(0,-1,num2str(mmv(1,1)));
text(-1,34,num2str(mmv(31,1)));
set(gca,'fontsize',8)
