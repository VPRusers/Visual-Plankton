function fig = train_help()
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

load train_help
load train_help_text

h0 = figure('Color',[0 0.85 0.85], ...
	'Colormap',mat0, ...
	'FileName','C:\plgui\mygui\train_help.m', ...
   'MenuBar','none', ...
   'numbertitle','off', ...
	'Name','Training Help', ...
	'PaperPosition',[18 180 576 432], ...
	'Units','normalized', ...
	'Position',[0.0361  0.4544  0.5234  0.4596], ...
	'Tag','train_help_window', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
   'BackgroundColor',[0 .85 .85], ...
   'ForegroundColor',[0 0 .1], ...
	'ListboxTop',0, ...
   'Position',[.1 .85 .8 .1], ...
   'horizontalalignment','center', ...
    'fontunits','normalized','fontsize',.4,'fontweight','bold','fontname','helvetica',...
	'String','Training Help', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0 0.85 0.85], ...
	'Position',[.05 .1 .9 .8], ...
   'Style','listbox', ...
   'selectionhighlight','off', ...
   'String',train_help_text, ...
   'fontunits','normalized','fontsize',.048, ...
   'fontname','helvetica',...
	'Tag','Listbox Calib_help', ...
   'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0 0.85 0.85], ...
	'Callback','close(gcbf)', ...
	'fontunits','normalized','fontsize',.65,'FontWeight','normal', ...
	'ListboxTop',0, ...
	'Position',[0.75 0.024 0.2 0.07], ...
	'String','Exit Help', ...
	'Tag','Pushbutton1 Quit', ...
	'TooltipString','Quit without Saving');

if nargout > 0, fig = h0; end
