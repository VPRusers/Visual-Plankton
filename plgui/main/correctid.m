function []=correctid

h=findobj('tag','correctID_1');
ah=get(h,'children');
ah=ah(1:length(ah)-1);%don't use last handle, which is IrfanView button.
if ~isempty(ah),
    ch=get(ah,'children');
    roinames2mv=[];
    dummystring=get(gcbo,'String');v=get(gcbo,'value');
    mv2taxon=deblank(dummystring(v,:));
    if ~iscell(ch),ch={ch},end%need to do this in case there's only one image on the page
    for j=1:length(ch),
        ud=get(ch{j}(2),'userdata');
        if ud{2}==1,
            roinames2mv=[roinames2mv;ud{3}];
            ud{2}=0;
            lw=1;
            xc='w';
            yc='w';
            set(ch{j}(2),'userdata',ud);
            eval(['set(ch{j}(1),''string'',''' mv2taxon ''',''visible'',''on'');']);
            ph=get(ch{j}(2),'parent');
            set(ph,'linewidth',lw,'xcolor',xc,'ycolor',yc)
        end;
    end;
    udata=get(gcbo,'userdata');
    eval(['udata.' mv2taxon '=[udata.' mv2taxon ';roinames2mv]']);
    set(gcbo,'userdata',udata);
    eval(['disp(udata.' mv2taxon ')']);
end;