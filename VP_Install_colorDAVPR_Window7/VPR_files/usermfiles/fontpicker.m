function varargout = fontpicker(varargin)
% FONTPICKER returns a list of selected HG fonts
%  FONTS = FONTPICKER
%  returns a string cell array of font names that user selected through this GUI.
%
%  FONTS is a string cell array of font names.
%
%  FONTPICKER accepts no user input parameters. 
%  
%  FONTPICKER is a GUI tool. It lets users to see what a font returned by MATLAB
%  LISTFONTS command looks like. More important, if users are programming GUI
%  using MATLAB GUI building tool: GUIDE and having problems setting font
%  in GUIDE. This is a tool to help users to see what a HG font looks like
%  if it is asked from Java, which is how GUIDE does. 
%
%  Use this GUI to select those fonts that match between HG and Java if you
%  want your GUI display properly with selected font in GUIDE. The
%  selection is persistent if Save button is pressed and will be shown next 
%  time you run this GUI. If that is the case, a FIG file with the same
%  name will be generated. You need to keep this M file and that Fig file
%  together if you want to keep your selection. Otherwise, you may have to
%  make the selection again through this GUI.
%
%  After a list of fonts is selected, you may want to replace a font used
%  in one of your GUIs with one in the list, for example, to show your GUI
%  properly in GUIDE. Below is an example of using font 'Conga' for all
%  uicontrols in a GUI called 'example.fig':
%     fig =  hgload('example.fig');
%     set(findobj(allchild(fig),'Type','uicontrol'), 'FontName', 'Conga');
%     hgsave(fig, 'example.fig')
%     close(fig);
%
%  Example: workfonts=fontpicker
%   
%  See also: LISTFONTS, HGLOAD, HGSAVE, FINDOBJ
%
%  Example: workfonts=FONTPICKER

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fontpicker_OpeningFcn, ...
                   'gui_OutputFcn',  @fontpicker_OutputFcn, ...
                   'gui_LayoutFcn',  @fontpicker_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fontpicker is made visible.
function fontpicker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for fontpicker
handles.output = hObject;
handles.listfonts = listfonts;
handles.previousworkfont = get(handles.WorkfontList,'String');

set(handles.ListfontList,'String', char(handles.listfonts));
set(handles.ListfontList,'Max', 1);
set(handles.ListfontList,'Min', 0);

set(handles.WorkfontList,'Max', 2);
set(handles.WorkfontList,'Min', 0);

set(handles.SampleLabel,'String', getSampleString);
updateSample(handles);
updateRemoveButtons(handles);

handles.javastuff = initJavaSampleFrame(handles);

% Update handles structure
guidata(hObject, handles);

updateJavaSampleFrameSize(handles);
updateJavaSampleFrameFont(handles)

handles.javastuff.frame.show(1);

% UIWAIT makes fontpicker wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fontpicker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);

% --- Executes on button press in AddButton.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateWorkfont(handles, 'Add');

% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateWorkfont(handles, 'Remove');


% --- Executes on button press in RemoveAllButton.
function RemoveAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateWorkfont(handles, 'RemoveAll');


% --- Executes on selection change in ListfontList.
function ListfontList_Callback(hObject, eventdata, handles)
% hObject    handle to ListfontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ListfontList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListfontList

updateSample(handles);
updateJavaSampleFrameFont(handles);

% --- Executes during object creation, after setting all properties.
function ListfontList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListfontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in WorkFontList.
function WorkFontList_Callback(hObject, eventdata, handles)
% hObject    handle to WorkFontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns WorkFontList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WorkFontList


% --- Executes during object creation, after setting all properties.
function WorkFontList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkFontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in WorkfontList.
function WorkfontList_Callback(hObject, eventdata, handles)
% hObject    handle to WorkfontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns WorkfontList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WorkfontList

% --- Executes during object creation, after setting all properties.
function WorkfontList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkfontList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

javastuff = handles.javastuff;
handles = rmfield(handles, 'javastuff');
handles = rmfield(handles, 'listfonts');
handles = rmfield(handles, 'previousworkfont');
set(handles.ListfontList,'value',1);
set(handles.ListfontList,'String','listbox');
[p,f,e] = fileparts(which(mfilename));
hgsave(handles.figure1, fullfile(p, [f, '.fig']));
handles.javastuff =javastuff;
handles.previousworkfont = get(handles.WorkfontList,'String');

closeFontfind(handles);

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeFontfind(handles);


function updateSample(handles)

selection = get(handles.ListfontList, 'value');
font = handles.listfonts{selection};
set(handles.SampleLabel, 'Fontname',font);
oldunit = get(handles.SampleLabel, 'FontUnit');
set(handles.SampleLabel, 'FontUnit','Pixel');
size = num2str(get(handles.SampleLabel,'FontSize'));
set(handles.SampleLabel, 'FontUnit',oldunit);
set(handles.SampleTitle, 'String', ['Sample [', font, ', size = ', size, ' pixels]']);

function updateWorkfont(handles, action)

selection = get(handles.ListfontList, 'value');
font = {handles.listfonts{selection}};

workfonts = cellstr(get(handles.WorkfontList,'String'));
switch action
    case 'Add'
        if isempty(workfonts) | isempty(deblank(fliplr(deblank(fliplr(workfonts{1})))))
            workfonts = font;
        elseif ~ismember(font, workfonts)
            workfonts = {workfonts{:}, font{:}};
        end
    case 'Remove'
        selected = get(handles.WorkfontList,'Value');
        index = 1:length(workfonts);
        index(selected)=[];
        if isempty(index)
            workfonts = '  ';    
        else
            workfonts = workfonts(index);    
        end
        set(handles.WorkfontList,'Value', 1);        
            
    case 'RemoveAll'
        workfonts = '  ';    
        set(handles.WorkfontList,'Value', 1);        
end

workfonts = sort(workfonts);
set(handles.WorkfontList,'String', workfonts);

updateRemoveButtons(handles);


function updateRemoveButtons(handles)

workfonts = get(handles.WorkfontList,'String');
if isempty(workfonts)
    set(handles.RemoveButton,'enable','off');
    set(handles.RemoveAllButton,'enable','off');
else
    set(handles.RemoveButton,'enable','on');
    set(handles.RemoveAllButton,'enable','on');
end

function closeFontfind(handles)

handles.javastuff.frame.dispose;
handles=rmfield(handles, 'javastuff');
handles.output = handles.previousworkfont;
guidata(handles.figure1, handles);
uiresume(handles.figure1);


function sample = getSampleString

sample = 'The quick brown fox jumps over the lazy dog. 1234567890';


function jhandles = initJavaSampleFrame(handles)
import javax.swing.*;
import javax.swing.border.*;
import java.awt.*;

jhandles = [];

jPanel = JPanel;
jTextPane = JTextPane;
jTextPane.setEditable(0);
jTextPane.setOpaque(0);
jTextPane.setText(getSampleString);

border = BorderFactory.createEtchedBorder(Color.white,Color(148/255, 145/255, 140/255));
jtitledBorder = TitledBorder(border,'Sample');

jFrame = JFrame(get(handles.figure1,'Name'));
layout = BorderLayout;
jPanel.setBorder(jtitledBorder);
jPanel.setLayout(layout);
jPanel.add(jTextPane);
jFrame.getContentPane.add(jPanel);

javastuff.frame = jFrame;
javastuff.textpane = jTextPane;
javastuff.titleborder = jtitledBorder;
javastuff.panel = jPanel;
jhandles=javastuff;

function updateJavaSampleFrameSize(handles)

javastuff = handles.javastuff;

oldunit = get(handles.figure1,'Unit');
set(handles.figure1,'Unit','pixel');
pos= get(handles.figure1,'Position');
set(handles.figure1,'Unit',oldunit);

screensize = get(0,'screensize');
javastuff.frame.setSize(pos(3)+5,150);
javastuff.frame.setLocation(pos(1)-3, screensize(4)-pos(2)+3);

oldunit = get(handles.SampleLabel,'Unit');
set(handles.SampleLabel,'Unit','pixel');
labelpos = get(handles.SampleLabel,'position');
set(handles.SampleLabel,'Unit',oldunit);
inset = java.awt.Insets(10, labelpos(1)-10, 5, 5);
javastuff.textpane.setMargin(inset);

function updateJavaSampleFrameFont(handles)

selection = get(handles.ListfontList, 'value');
font = {handles.listfonts{selection}};

if ~isempty(font)
    oldunit = get(handles.SampleLabel, 'FontUnit');
    set(handles.SampleLabel, 'FontUnit', 'Pixel');
    size = get(handles.SampleLabel,'FontSize');
    set(handles.SampleLabel, 'FontUnit', oldunit);
    title =['Sample [', char(font), ', size = ', num2str(size), ' pixels]'];
    jfont = java.awt.Font(char(font), 0, size);
    handles.javastuff.textpane.setFont(jfont);
    handles.javastuff.titleborder.setTitle(title);
    handles.javastuff.panel.repaint;
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
closeFontfind(handles);



% --- Creates and returns a handle to the GUI figure. 
function h1 = fontpicker_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

[p,f,e] = fileparts(which(mfilename));
figfile = fullfile(p, [f, '.fig']);

if exist(figfile)
    h1=hgload(figfile);
    hsingleton = h1;
    return;
end

h1 = figure(...
'Units','characters',...
'CloseRequestFcn','fontpicker(''figure1_CloseRequestFcn'',gcf,[],guidata(gcf))',...
'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
'Colormap',get(0,'defaultfigureColormap'),...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','fontpicker',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[65.8000   29.0769  104.6000   33.9231],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'CreateFcn','fontpicker(''figure1_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','figure1',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', [], ...
'taginfo', struct(...
'figure', 2, ...
'frame', 4, ...
'pushbutton', 8, ...
'text', 5, ...
'listbox', 3), ...
'override', 0, ...
'release', 14, ...
'resize', 'none', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'lastSavedFile', 'd:\work\fontpicker.m'));


h2 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','fontpicker(''AddButton_Callback'',gcbo,[],guidata(gcbo))',...
'Min',2.12199583987777e-314,...
'Position',[0.4282982791587 0.848072562358277 0.139579349904398 0.0612244897959184],...
'String','>',...
'TooltipString','Add',...
'Value',2.12199583987777e-314,...
'Tag','AddButton');


h3 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','fontpicker(''RemoveButton_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[0.4282982791587 0.73469387755102 0.139579349904398 0.0612244897959184],...
'String','<',...
'TooltipString','Remove',...
'Tag','RemoveButton');


h4 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','fontpicker(''RemoveAllButton_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[0.4282982791587 0.653061224489796 0.139579349904398 0.0612244897959184],...
'String','<<',...
'TooltipString','RemoveAll',...
'Tag','RemoveAllButton');


h5 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'CData',zeros(1,0),...
'ForegroundColor',[0.901960784313726 0.901960784313726 0.901960784313726],...
'Position',[0.0382409177820268 0.138321995464853 0.936902485659656 0.151927437641723],...
'String',{ 'Frame' },...
'Style','frame',...
'Tag','frame3',...
'UserData',zeros(1,0));


h6 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'HorizontalAlignment','left',...
'Position',[0.0611854684512428 0.26530612244898 0.512428298279159 0.0430839002267574],...
'String','Sample [Book Antiqua, size = 16 pixels]',...
'Style','text',...
'Tag','SampleTitle');


h7 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'FontName','Book Antiqua',...
'FontSize',12,...
'HorizontalAlignment','left',...
'Position',[0.0478011472275335 0.151927437641723 0.923518164435946 0.111111111111111],...
'String','The quick brown fox jumps over the lazy dog. 1234567890',...
'Style','text',...
'Tag','SampleLabel');


h8 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'CData',zeros(1,0),...
'ForegroundColor',[0.901960784313726 0.901960784313726 0.901960784313726],...
'Position',[0.0401529636711281 0.333333333333333 0.347992351816444 0.619047619047619],...
'String',{ 'Frame' },...
'Style','frame',...
'Tag','frame1',...
'UserData',zeros(1,0));


h9 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'CData',zeros(1,0),...
'ForegroundColor',[0.901960784313726 0.901960784313726 0.901960784313726],...
'Position',[0.611854684512428 0.333333333333333 0.35755258126195 0.619047619047619],...
'String',{ 'Frame' },...
'Style','frame',...
'Tag','frame2',...
'UserData',zeros(1,0));


h10 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'HorizontalAlignment','left',...
'Position',[0.0592734225621415 0.934240362811792 0.286806883365201 0.036281179138322],...
'String','Fonts returned by LISTFONT',...
'Style','text',...
'Tag','text1');


h11 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'HorizontalAlignment','left',...
'Position',[0.632887189292543 0.927437641723356 0.311663479923518 0.0408163265306122],...
'String','List of fonts working in GUIDE',...
'Style','text',...
'Tag','text2');


h12 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','fontpicker(''ListfontList_Callback'',gcbo,[],guidata(gcbo))',...
'CData',zeros(1,0),...
'Position',[0.0535372848948375 0.360544217687075 0.319311663479924 0.569160997732426],...
'String','listbox',...
'Style','listbox',...
'Value',1,...
'CreateFcn','fontpicker(''ListfontList_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','ListfontList',...
'UserData',zeros(1,0));


h13 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'BackgroundColor',[1 1 1],...
'Callback','fontpicker(''WorkfontList_Callback'',gcbo,[],guidata(gcbo))',...
'Max',2,...
'Position',[0.627151051625239 0.35827664399093 0.326959847036329 0.569160997732426],...
'String',{ 'Book Antiqua' },...
'Style','listbox',...
'Value',1,...
'CreateFcn','fontpicker(''WorkfontList_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','WorkfontList');


h14 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','fontpicker(''SaveButton_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[0.625239005736138 0.0294784580498866 0.139579349904398 0.0612244897959184],...
'String','Save',...
'TooltipString','Save font list',...
'Value',1,...
'Tag','SaveButton');


h15 = uicontrol(...
'Parent',h1,...
'Units','normalized',...
'Callback','fontpicker(''CancelButton_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[0.833652007648183 0.0294784580498866 0.139579349904398 0.0612244897959184],...
'String','Cancel',...
'TooltipString','Cancel',...
'Tag','CancelButton');



hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % FONTPICKER
    % create the GUI
    gui_Create = 1;
elseif ishandle(varargin{1}) & varargin{1}==gcbo
    % FONTPICKER(ACTIVEX,...)    
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif ischar(varargin{1}) & ishandle(varargin{2})
    % FONTPICKER('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % FONTPICKER(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

