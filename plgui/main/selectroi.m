function []=selectroi

ph=get(gcbo,'parent');
ud=get(gcbo,'userdata');
iviewon=get(findobj(gcbf,'tag','IrfanView'),'value');
name=ud{4};
name(name==47)=92;
if ud{2}==0,
    ud{2}=1;
    lw=3;
    xc='b';
    yc='b';
    if iviewon,
        dos(['"C:\Program Files\IrfanView\i_view32.exe" ' name ' /one &']);
    end
elseif ud{2}==1,
    ud{2}=0;
    lw=1;
    xc='w';
    yc='w';
    if iviewon,
        dos(['"C:\Program Files\IrfanView\i_view32.exe" /killmesoftly &']);
    end
end

set(gcbo,'userdata',ud);
set(ph,'linewidth',lw,'xcolor',xc,'ycolor',yc);

name1=ud{3};
roiname=name1((max(findstr('\',name1))+1):length(name1));
figtitle=get(gcbf,'name');
idx=findstr('roi',figtitle);
if isempty(idx),
    if ud{2}==1,
        figtitle=[figtitle '  ' roiname];
    end
else
    if ud{2}==1,
        figtitle=[figtitle(1:idx-1) roiname];
    else
        figtitle=figtitle(1:idx-3);
    end
end

set(gcbf,'name',figtitle);
