function plmaingui(action, varargin)
global MAT2 MAT3

if nargin<1,
   action='InitializePLMAIN';
end;

feval(action,varargin{:});
return;


function InitializePLMAIN()

% If plmaingui is already running, bring it to the foreground.
h = findobj(allchild(0), 'tag', 'Plankton Identification System');
if ~isempty(h)
   figure(h(1))
   return
end

plinit;

%%%
%%%  Sub-Function - ApplyPLMAIN
%%%

function ApplyPLMAIN()

hdl=findobj(allchild(0),'tag','Listbox Method');
method=get(hdl,'Value');
switch method
case 1
   PLcalibrate;
case 2
   focus_help;
case 3
   PLtrain_start1;
case 4
  PLclassify;
case 5
   PLplot;
end

%%%
%%%  Sub-Function - ShowAbout
%%%

function ShowAbout
about1={...
      'Step 1:   CALIBRATION'
   'Calibrate the system to determine the imaged volume   '
'You can do this by recording the field of view (width    '
'and height using a ruler. Then record the depth of focus '
'using a tethered animal or proxy thereof.  Alternatively '
'record known concentrations of plankton in a tank.       '
'(Click Apply to open the Calibration window)               '
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '}; 
about2={...
'Step 2:  FOCUS DETECTION'
   '                                                      '
   'The focus detection program picks out in-focus '
   'objects from the video and saves these regions of'
   'interest (ROIs) as tif files for further processing.  '
   '                                                      '
   'Click Apply for help on the Focus Detection program.  '
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '};
about3={...
   'Step 3:  TRAINING THE COMPUTER'
   '                                                      '
   'To train the computer to identify plankton:           '
   '                                                      '
   '- Copy a subset of ROIS to a parallel TRROIS folder '
   '- Manually sort these training images.                '
   '- Run the training program to build the classifier.'
   '                                                      '
   'Click Apply to open the training window.              '
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '}; 
about4={...
   'Step 4:  AUTOMATIC IDENTIFICATION OF PLANKTON         '
   '                                                      '
   'This step is used for feature extraction and          '
   'classification.                                       '
   '                                                      '
   'Click Apply to open the automatic identification window.'
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '}; 
about5={...
      'Step 5:  View the Results'
   '                                                      '
  'This step plots distributions of plankton abundance,   '
   'environmental variables, and flight control variables'
   'in real time.  Post processing allows editing results. '
   '                                                      '
  'Click Apply to view and edit the results.           '
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '
   '                                                      '};
aboutArray={about1 about2 about3 about4 about5};

hdlmethod=findobj(allchild(0),'tag','Listbox Method');
method=get(hdlmethod,'Value');
hdlabout=findobj(allchild(0),'tag','Listbox About');
set(hdlabout,'String',aboutArray{method});
drawnow;
