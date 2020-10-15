function [] = toggletowpath

ah=get(gcbf,'children');
ch=get(ah(1),'children');
v=get(ah(2),'value');
if v, 
    set(ch(1),'visible','on');
else
    set(ch(1),'visible','off');
end

    
