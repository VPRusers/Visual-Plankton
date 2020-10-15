function fig = PLcalibrate(action, varargin)
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

if nargin<1,
  action='InitializeCALIBRATE';
end;

feval(action,varargin{:});
return;

%%%
%%%   Sub-function - InitializeCALIBRATE
%%%

function InitializeCALIBRATE()

load PLcalibrate

%redgreenblue=[0.2157 .6353 .6353];%Pierre liked this color
redgreenblue=[0.2157 .6353 .6353]*1.2;%let's make it lighter for this figure

h0 = figure('Units','normalized', ...
	'Color',[redgreenblue], ...
	'Colormap',mat0, ...
	'FileName','C:\plgui\mygui\PLcalibrate.m', ...
	'MenuBar','none', ...
   'numbertitle','off', ...
	'Name','VPR Calibration', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[0.2200    0.2500    0.6000    0.6000], ...
	'Tag','VPR Calibration', ...
	'ToolBar','none', ...
	'UserData',mat1);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.8000    0.1024    0.1411    0.3119], ...
	'Style','frame', ...
	'Tag','Frame LoadSaveExitHelp', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.06785714285714285 0.06666666666666667 0.7071428571428571 0.4825396825396826], ...
	'Style','frame', ...
	'Tag','Frame DepthofField', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.5203    0.5662    0.4244    0.1280], ...
	'Style','frame', ...
	'Tag','Frame FieldofView', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.0659    0.8377    0.8750    0.1300], ...
	'Style','frame', ...
	'Tag','Frame4', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.0683    0.7375    0.4211    0.0738], ...
	'Style','frame', ...
	'Tag','Frame Enter ImageVolume', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.0667    0.6182    0.4211    0.0738], ...
	'Style','frame', ...
	'Tag','Frame Enter Dimensions', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'ListboxTop',0, ...
	'Position',[0.09285714285714285 0.3047619047619048 0.2107142857142857 0.1952380952380952], ...
	'Style','frame', ...
	'Tag','Frame UpperLeft');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'ListboxTop',0, ...
	'Position',[0.09285714285714285 0.0880952380952381 0.2107142857142857 0.1952380952380952], ...
	'Style','frame', ...
	'Tag','Frame LowerLeft');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'ListboxTop',0, ...
	'Position',[0.3303571428571429 0.2119047619047619 0.1767857142857143 0.1952380952380952], ...
	'Style','frame', ...
	'Tag','Frame Center');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'ListboxTop',0, ...
	'Position',[0.5375 0.1 0.2107142857142857 0.1952380952380952], ...
	'Style','frame', ...
	'Tag','Frame LowerRight');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'ListboxTop',0, ...
	'Position',[0.5357142857142857 0.3095238095238095 0.2107142857142857 0.1952380952380952], ...
	'Style','frame', ...
	'Tag','Frame UpperRight');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
	'Position',[0.57    0.7397    0.383    0.0716], ...
	'Style','frame', ...
	'Tag','Frame Camera Resolution', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.2373    0.9103    0.2232    0.0400], ...
	'String','', ...
   'Style','edit','fontunits','normalized','fontsize',.6,'fontweight','normal', ...
   'horizontalalignment','left', ...
	'Tag','EditText Base Path', ...
	'TooltipString','Enter base path for data (e.g., c:\data)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.0748    0.9003    0.1589    0.0452], ...
	'String','Base Path', ...
	'Style','text', ...
	'Tag','StaticText Base Path', ...
	'TooltipString','Base path (e.g., c:\data)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5052    0.9003    0.1750    0.0452], ...
	'String','Cruise Name', ...
	'Style','text', ...
	'Tag','StaticText Cruise', ...
	'TooltipString','Cruise Name (e.g., an9902)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6837    0.9103    0.2232    0.0400], ...
	'String','', ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Cruise', ...
	'TooltipString','Enter Name of Cruise (e.g. an9902)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.6848    0.5817    0.1750    0.0452], ...
	'String','Field Height', ...
	'Style','text', ...
	'Tag','StaticText Field Height', ...
	'TooltipString','Height of video field (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.8621    0.5875    0.0647    0.0400], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Field Height', ...
	'TooltipString','Enter height of video field (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.6911    0.6299    0.1638    0.0452], ...
	'String','Field Width', ...
	'Style','text', ...
	'Tag','StaticText Field Width', ...
	'TooltipString','Width of Video Field (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.8598    0.6352    0.0654    0.0400], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Field Width', ...
	'TooltipString','Enter width of video field (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'FontName','Helvetica', ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.2539    0.8447    0.3000    0.0452], ...
	'String','AutoVPR Magnification Setting', ...
	'Style','text', ...
	'Tag','StaticText AutoVPR Magnification', ...
	'TooltipString','Select the VPR Magnification Setting used, i.e., S0, S1, S2, or S3');
magsetting=str2mat('S0','S1','S2','S3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Max',5, ...
	'Min',1, ...
    'Callback','PLcalibrate DefaultFOV',...
	'Position',[0.5489    0.8532    0.0600    0.0400], ...
	'String',magsetting, ...
	'Style','popupmenu','fontunits','normalized','fontsize',.5,'horizontalalignment','left', ...
	'Tag','PopupMenu AutoVPR Magnification', ...
	'TooltipString','Select the VPR magnification setting used, i.e., S0, S1, S2, or S3');
PLcalibrate DefaultFOV
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.4204  0.7556  0.0500  0.0400], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Enter Image Volume', ...
    'Enable','off', ...
	'TooltipString',['Enter the image volume directly, in milliliters.' char(10) 'This volume will be used instead of ' char(10) 'computing a volume from the dimensions.']);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
    'Callback','PLcalibrate DisableDimensions; set(findobj(''tag'',''Radiobutton Enter Dimensions''),''value'',0);if get(gcbo,''value'')==1,PLcalibrate EnableEnterImageVolume,else,PLcalibrate DisableEnterImageVolume;end', ...
	'Position',[0.0880    0.7536    0.3348    0.0452], ...
	'Style','radiobutton','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'String','Enter Image Volume directly (ml)', ...
	'Tag','Radiobutton Enter Image Volume', ...
    'Value',0, ...
	'TooltipString',['Enter the image volume directly, in milliliters.' char(10) 'This volume will be used instead of ' char(10) 'computing a volume from the dimensions.']);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'ListboxTop',0, ...
    'Callback','if get(gcbo,''value'')==1,PLcalibrate EnableDimensions;else,PLcalibrate DisableDimensions;end;set(findobj(''tag'',''Radiobutton Enter Image Volume''),''value'',0);set(findobj(''Tag'',''EditText Enter Image Volume''),''enable'',''off'',''string'','''')', ...
	'Position',[0.0896    0.6321    0.3608    0.0452], ...
	'Style','radiobutton','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'String','Enter Dimensions of Image Volume', ...
	'Tag','Radiobutton Enter Dimensions', ...
    'Value',0, ...
	'TooltipString',['Enter the Field of View and Depth of Field' char(10) 'The image volume will be computed automatically' char(10) 'by the plotting program']);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.1161    0.4476    0.1857    0.0452], ...
	'String','Upper Left', ...
	'Style','text', ...
	'Tag','StaticText Upper Left', ...
	'TooltipString','Upper left corner of field of view');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.09464285714285714 0.3880952380952381 0.07678571428571428 0.04523809523809524], ...
	'String','Near', ...
	'Style','text', ...
	'Tag','StaticText Upper Left Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.09464285714285714 0.3214285714285715 0.07678571428571428 0.04523809523809524], ...
	'String','Far', ...
	'Style','text', ...
	'Tag','StaticText Upper Left Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.1786    0.3981    0.0732    0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Upper Left Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.1786    0.3314    0.0732    0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Upper Left Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.1107142857142857 0.2333333333333333 0.1857142857142857 0.04523809523809524], ...
	'String','Lower Left', ...
	'Style','text', ...
	'Tag','StaticText Lower Left', ...
	'TooltipString','Lower left corner of field of view');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.0982    0.1095    0.0768    0.0452], ...
	'String','Far', ...
	'Style','text', ...
	'Tag','StaticText Lower Left Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.0982142857142857 0.1761904761904762 0.07678571428571428 0.04523809523809524], ...
	'String','Near', ...
	'Style','text', ...
	'Tag','StaticText Lower Left Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.1821    0.1195    0.0732    0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Lower Left Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.1821428571428571 0.1838095238095238 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Lower Left Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.35 0.35 0.1357142857142857 0.04523809523809524], ...
	'String','Center', ...
	'Style','text', ...
	'Tag','StaticText Center', ...
	'TooltipString','Center of field of view');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.3339285714285714 0.2333333333333333 0.07678571428571428 0.04523809523809524], ...
	'String','Far', ...
	'Style','text', ...
	'Tag','StaticText Center Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.3357142857142857 0.2928571428571429 0.07678571428571428 0.04523809523809524], ...
	'String','Near', ...
	'Style','text', ...
	'Tag','StaticText Center Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.4142857142857143 0.2361904761904762 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Center Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.4142857142857143 0.3004761904761905 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Center Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5517857142857142 0.4476190476190476 0.1857142857142857 0.04523809523809524], ...
	'String','Upper Right', ...
	'Style','text', ...
	'Tag','StaticText Upper Right', ...
	'TooltipString','Upper right corner of field of view');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5375 0.3214285714285715 0.07678571428571428 0.04523809523809524], ...
	'String','Far', ...
	'Style','text', ...
	'Tag','StaticText Upper Right Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5375 0.3880952380952381 0.07678571428571428 0.04523809523809524], ...
	'String','Near', ...
	'Style','text', ...
	'Tag','StaticText Upper Right Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6214285714285713 0.3314285714285715 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Upper Right Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6214285714285713 0.3980952380952381 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Upper Right Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5571    0.2429    0.1857    0.0452], ...
	'String','Lower Right', ...
	'Style','text', ...
	'Tag','StaticText Lower Right', ...
	'TooltipString','Lower right corner of field of view');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5500    0.1190    0.0768    0.0452], ...
	'String','Far', ...
	'Style','text', ...
	'Tag','StaticText Lower Right Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.2, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5482142857142857 0.1880952380952381 0.07678571428571428 0.04523809523809524], ...
	'String','Near', ...
	'Style','text', ...
	'Tag','StaticText Lower Right Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6321    0.1290    0.0732    0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Lower Right Far', ...
	'TooltipString','Edge of Focus Away from Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6303571428571428 0.1933333333333333 0.0732142857142857 0.04], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
	'Tag','EditText Lower Right Near', ...
	'TooltipString','Edge of focus Toward Camera (mm)');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'fontunits','normalized','fontsize',.6, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.58    0.7440    0.22    0.0472], ...
	'String','Camera Resolution', ...
	'Style','text', ...
	'Tag','StaticText Camera Resolution', ...
	'TooltipString','Enter Camera Resolution in pixels');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.8010    0.7552    0.11    0.0400], ...
	'Style','edit','fontunits','normalized','fontsize',.6,'horizontalalignment','left', ...
    'String','1392x1024',...
	'Tag','EditText Camera Resolution', ...
	'TooltipString',['Enter Camera Resolution in pixels. ' char(10),...
    '(use format: WxH, e.g. 1392x1024 is for B/W AutoVPR, 1028x1024 = Color AutoVPR)']);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'FontName','Helvetica', ...
	'fontunits','normalized','fontsize',.35, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.5512    0.5842    0.1480    0.0897], ...
	'String',['Field of View' char(10) '(mm)'], ...
	'Style','text', ...
	'Tag','StaticText Field of View', ...
	'TooltipString','Width and Height of Video Field in mm');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.1, ...
	'FontName','Helvetica', ...
	'fontunits','normalized','fontsize',.35, ...
	'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.3089285714285714 0.4388888888888889 0.2232142857142857 0.08968253968253968], ...
	'String',['Depth of Field' char(10) '(mm)'], ...
	'Style','text', ...
	'Tag','StaticText Depth of Field', ...
	'TooltipString','Positions (mm) of near and far focal planes of VPR imaged volume');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.15, ...
	'Callback','close(gcbf)', ...
	'fontunits','normalized','fontsize',.5,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.8196    0.2    0.1036    0.0476], ...
	'String','EXIT', ...
	'Tag','Pushbutton1 Quit', ...
	'TooltipString','Be sure to save data first');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.15, ...
	'Callback','PLcalibrate SaveSettings', ...
	'fontunits','normalized','fontsize',.5,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.8179    0.27    0.1036    0.0476], ...
	'String','SAVE', ...
	'Tag','Pushbutton1 Save', ...
	'TooltipString','Save Values');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.15, ...
	'Callback','calibration_help', ...
	'fontunits','normalized','fontsize',.5,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.8179    0.13    0.1036    0.0476], ...
	'String','HELP', ...
	'Tag','Pushbutton1 Help', ...
	'TooltipString','Calibration Help Window');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue]*1.15, ...
	'Callback','PLcalibrate LoadSettings', ...
	'fontunits','normalized','fontsize',.5,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.8179    0.34    0.1036    0.0476], ...
	'String','LOAD', ...
	'Tag','Pushbutton1 Load Values', ...
	'TooltipString','Load Values');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[redgreenblue], ...
	'FontName','Helvetica', ...
	'fontunits','normalized','fontsize',.5,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.0119    0.0048    0.9524    0.0452], ...
	'String','IMPORTANT:  Be sure to save settings of focus detection program in the calibration directory.', ...
	'Style','text', ...
	'Tag','StaticText IMPORTANT');

PLcalibrate DisableDimensions

if nargout > 0, fig = h0; end

function DefaultFOV
h1=findobj('Tag','PopupMenu AutoVPR Magnification');
dummystring=get(h1,'String');v=get(h1,'value');
magsetting=deblank(dummystring(v,:));
if ~isempty(magsetting),
    h1=findobj('tag','EditText Field Width');
    h2=findobj('tag','EditText Field Height');
    if strcmpi(magsetting,'S0'),set(h1,'string','9.75');set(h2,'string','7.5');
    elseif strcmpi(magsetting,'S1'),set(h1,'string','17.5');set(h2,'string','13.5');
    elseif strcmpi(magsetting,'S2'),set(h1,'string','24.0');set(h2,'string','24.0');
    elseif strcmpi(magsetting,'S3'),set(h1,'string','49.0');set(h2,'string','38.0');
    end
end

function EnableEnterImageVolume
set(findobj('Tag','EditText Enter Image Volume'),'enable','on');


function DisableEnterImageVolume
set(findobj('Tag','EditText Enter Image Volume'),'enable','off');


function DisableDimensions

aa=findobj('style','edit');
for j=1:length(aa);%this disables the FOV and DOF edit boxes on startup
    bb=get(aa(j),'position');
    if bb(2)<0.5 | bb(1)>0.85;
        set(aa(j),'enable','off');
    end;
end


function EnableDimensions

aa=findobj('style','edit');
for j=1:length(aa);%this disables the FOV and DOF edit boxes on startup
    bb=get(aa(j),'position');
    if bb(2)<0.5 | bb(1)>0.85;
        set(aa(j),'enable','on');
    end;
end


function SaveSettings()

h1=findobj('Tag','EditText Field Height');calibdata.fh=get(h1,'String');
h1=findobj('Tag','EditText Field Width');calibdata.fw=get(h1,'String');
h1=findobj('Tag','EditText Upper Left Near');calibdata.uln=get(h1,'String');
h1=findobj('Tag','EditText Upper Left Far');calibdata.ulf=get(h1,'String');
h1=findobj('Tag','EditText Lower Left Near');calibdata.lln=get(h1,'String');
h1=findobj('Tag','EditText Lower Left Far');calibdata.llf=get(h1,'String');
h1=findobj('Tag','EditText Center Near');calibdata.cn=get(h1,'String');
h1=findobj('Tag','EditText Center Far');calibdata.cf=get(h1,'String');
h1=findobj('Tag','EditText Upper Right Near');calibdata.urn=get(h1,'String');
h1=findobj('Tag','EditText Upper Right Far');calibdata.urf=get(h1,'String');
h1=findobj('Tag','EditText Lower Right Near');calibdata.lrn=get(h1,'String');
h1=findobj('Tag','EditText Lower Right Far');calibdata.lrf=get(h1,'String');

h1=findobj('Tag','EditText Enter Image Volume');imvol=get(h1,'String');
h1=findobj('Tag','EditText Camera Resolution');camres=get(h1,'String');

h1=findobj('Tag','PopupMenu AutoVPR Magnification');
dummystring=get(h1,'String');v=get(h1,'value');
magsetting=deblank(dummystring(v,:));
h1=findobj('Tag','EditText Base Path');basepath=get(h1,'String');
h1=findobj('Tag','EditText Cruise');cruisename=get(h1,'String');

pathname=basepath;if isempty(dir(pathname));dos(['mkdir ' pathname]);end;
pathname=[pathname,filesep,cruisename];if isempty(dir(pathname));dos(['mkdir ' pathname]);end;
pathname=[pathname,filesep,'calibration'];if isempty(dir(pathname));dos(['mkdir ' pathname]);end;
pathfilename=[pathname,filesep,'imvol_dim'];
eval(['save ' pathfilename ' calibdata camres magsetting imvol']);
%pathfilename2=[pathname,filesep,'focus_settings.cfg'];
%copyfile('default.cfg', pathfilename2);


function LoadSettings()

% Check to see if there is a previous calibration file for the specified disc,cruise,
% and, if so, load it and fill in the blanks
h1=findobj('Tag','EditText Base Path');basepath=get(h1,'String');
h1=findobj('Tag','EditText Cruise');cruisename=get(h1,'String');
pathname=[basepath,filesep,cruisename,filesep,'calibration'];
pathfilename=[pathname,filesep,'imvol_dim'];
camrate=[];
if ~isempty(dir([pathfilename '.mat'])), 
   eval(['load ' pathfilename]);
   if ~isempty(calibdata),
       h1=findobj('Tag','EditText Field Height');set(h1,'String',calibdata.fh);
       h1=findobj('Tag','EditText Field Width');set(h1,'String',calibdata.fw);
       h1=findobj('Tag','EditText Upper Left Near');set(h1,'String',calibdata.uln);
       h1=findobj('Tag','EditText Upper Left Far');set(h1,'String',calibdata.ulf);
       h1=findobj('Tag','EditText Lower Left Near');set(h1,'String',calibdata.lln);
       h1=findobj('Tag','EditText Lower Left Far');set(h1,'String',calibdata.llf);
       h1=findobj('Tag','EditText Center Near');set(h1,'String',calibdata.cn);
       h1=findobj('Tag','EditText Center Far');set(h1,'String',calibdata.cf);
       h1=findobj('Tag','EditText Upper Right Near');set(h1,'String',calibdata.urn);
       h1=findobj('Tag','EditText Upper Right Far');set(h1,'String',calibdata.urf);
       h1=findobj('Tag','EditText Lower Right Near');set(h1,'String',calibdata.lrn);
       h1=findobj('Tag','EditText Lower Right Far');set(h1,'String',calibdata.lrf);
   end
   if ~isempty(imvol),
       h1=findobj('Tag','EditText Enter Image Volume');set(h1,'String',imvol);
   end
   if ~isempty(camrate),
       h1=findobj('Tag','EditText Camera Resolution');set(h1,'String',camres);
   end
   if ~isempty(magsetting),
       h1=findobj('Tag','PopupMenu AutoVPR Magnification');
       dummystring=get(h1,'string');
       magval=strmatch(magsetting,dummystring,'exact');
       set(h1,'value',magval);
   end
   drawnow;
end;
% Check to see if there is a previous .cfg file for the specified disc,cruise
% and if so, copy to local dir as default.cfg
pathfilename2=[pathname,filesep,'focus_settings.cfg'];
if ~isempty(dir(pathfilename2));
   copyfile(pathfilename2,'default.cfg');
end;




