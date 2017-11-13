function varargout = ControlPanel(varargin)
% CONTROLPANEL M-file for ControlPanel.fig
%      CONTROLPANEL, by itself, creates a new CONTROLPANEL or raises the existing
%      singleton*.
%
%      H = CONTROLPANEL returns the handle to a new CONTROLPANEL or the handle to
%      the existing singleton*.
%
%      CONTROLPANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLPANEL.M with the given input arguments.
%
%      CONTROLPANEL('Property','Value',...) creates a new CONTROLPANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ControlPanel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ControlPanel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Jenny Read:
% handles is used to store the following key variables throughout the
% session:
% .ivx = structure used to define eyetracking parameters, UDP connection to eyetracker etc.


% Edit the above text to modify the response to help ControlPanel

% Last Modified by GUIDE v2.5 07-Feb-2011 15:38:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ControlPanel_OpeningFcn, ...
    'gui_OutputFcn',  @ControlPanel_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ControlPanel is made visible.
function ControlPanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ControlPanel (see VARARGIN)

% Choose default command line output for ControlPanel
handles.output = hObject;

% handles.ivx will be used to store the eyetracker structure in between
% experiments. Initially, there is no connection to the eyetracker
handles.ivx = [];

set(handles.figure1,'units','pixels');

% Look at names available:
d=dir(['..' filesep 'namesounds' filesep '*.wav']);
names=strrep({d.name},'.wav','');
set(handles.namelist,'string',['unavailable' names],'value',1);

handles.lastvaliddatadir = [pwd filesep 'data'];
set(handles.currdir,'string',handles.lastvaliddatadir);
UpdateLocationInTree(handles)

% Handles that need to be updated for each subject:
% These are all the fields in uipanel2 which are highlighted in red on start-up:
handles.subjectspecifichandles = [handles.subjectID handles.male handles.female handles.birthmonth handles.birthyear handles.namelist];
handles.handlestoupdate=ones(size(handles.subjectspecifichandles)); % say all fields need to be updated
% handlestoupdate(j)=1 means this handle needs to be updated; =0 means has
% already been updated.
set(handles.startexpt,'visible','off')
set(handles.stopexpt,'visible','off')
set(handles.uipanel13,'visible','off')
set(handles.uipanel2,'title','ENTER DETAILS:','foregroundcol','r');
set(handles.birthyear,'string',cellstr(num2str([2011:-1:1950]')),'value',11);


handles.im_eyetracking = imread('eyetracking.jpg');
handles.im_noeyetracking = imread('noeyetracking.jpg');
set(handles.EyeTracker,'value',0,'visible','off') % it's not visibel until we have all subject-specific info
EyeTracker_Callback(handles.EyeTracker, [], handles)

% Create an experiment structure using the default values:
handles.expt = DefineExptStructure;


% Bring the GUI to the front and give it focus:
figure(hObject);
uicontrol(handles.startexpt);

% Specify closing function:
set(handles.figure1,'CloseRequestFcn',@closeGUI);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ControlPanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ControlPanel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set it to desired position:
set(handles.figure1,'pos',[1   343   652   530])

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on selection change in birthmonth.
function birthmonth_Callback(hObject, eventdata, handles)
% Note that this field has been updated:
handles.handlestoupdate(handles.subjectspecifichandles==hObject)=0;
CheckSubjectInfoComplete(handles);

% --- Executes during object creation, after setting all properties.
function birthmonth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to birthmonth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',{'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'});


% --- Executes on selection change in birthyear.
function birthyear_Callback(hObject, eventdata, handles)
% Note that this field has been updated:
handles.handlestoupdate(handles.subjectspecifichandles==hObject)=0;
CheckSubjectInfoComplete(handles)


% --- Executes during object creation, after setting all properties.
function birthyear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to birthyear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',cellstr(num2str([2000:2012]')),'value',8);



function subjectID_Callback(hObject, eventdata, handles)
% hObject    handle to subjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectID as text
%        str2double(get(hObject,'String')) returns contents of subjectID as a double
% Update datadir
subjectID = get(hObject,'string');
subjectID = strrep(subjectID,' ','_');
%set(handles.datadir,'string', ['data/' subjectID '/']);
% Say this field has been updated
handles.handlestoupdate(handles.subjectspecifichandles==hObject)=0;
% so all others now need to be:
handles.handlestoupdate(handles.subjectspecifichandles~=hObject)=1;
CheckSubjectInfoComplete(handles)
handles.expt.subject = subjectID;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function subjectID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in female.
function female_Callback(hObject, eventdata, handles)
% hObject    handle to female (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value')==1
    set(handles.male,'value',0)
elseif get(hObject,'value')==0
    set(handles.male,'value',1)
end
% Note that this field has been updated:
handles.handlestoupdate(handles.subjectspecifichandles==hObject)=0;
% Also update male button as well:
handles.handlestoupdate(handles.subjectspecifichandles==handles.male)=0;
guidata(hObject, handles);
CheckSubjectInfoComplete(handles)

% --- Executes on button press in male.
function male_Callback(hObject, eventdata, handles)
if get(hObject,'value')==1
    set(handles.female,'value',0)
elseif get(hObject,'value')==0
    set(handles.female,'value',1)
end
% and call the female callback
ControlPanel('female_Callback',handles.female,[],handles);


function notes_Callback(hObject, eventdata, handles)
handles.expt.notes = get(handles.notes,'string');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function datadir_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function datadir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));


% --- Executes on selection change in expt2run.
function expt2run_Callback(hObject, eventdata, handles)
% hObject    handle to expt2run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns expt2run contents as cell array
%        contents{get(hObject,'Value')} returns selected item from expt2run
j = get(hObject,'value');
expts = get(hObject,'string');
expt2run = expts{j};
fprintf('Changed selected experiment to %s\n',expt2run)
% Make Adj/Noun controller visible, if appropriate:
if strcmp(expt2run,'Scenes') && get(handles.soundradiobutton,'value')==1
    set(handles.uipanel13,'visible','on')
else
    set(handles.uipanel13,'visible','off')
    % Then we are definitely using adjective cue:
    set(handles.adjradiobutton,'value',1)
    set(handles.nounradiobutton,'value',0)
end

% --- Executes during object creation, after setting all properties.
function expt2run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expt2run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startexpt.
function startexpt_Callback(hObject, eventdata, handles)
% When this button is pressed, PTB starts running the experiment with the
% specified parameters.
% Bring the GUI to the front and give it focus:
figure(handles.figure1);

set(handles.startexpt,'visible','off')
set(handles.stopexpt,'visible','on')
HideCursor

try
    % Get expt structure:
    expt = UpdateExptStructure(handles);
    %Read back any changes in figure handles as I sometimes store things there:
    handles = guidata(handles.figure1);
    % NB this also opens up a connection to the eyetracker if needed.
    aborted = 0;
    % NB am no lonre automatically running a calibration test on every expt
    % %     % Run a quick calibration test
    % %     if expt.eyetracking
    % %         TestCalibration_Callback(handles.TestCalibration, [], handles);
    % %         % Read off  result
    % %         handles = guidata(hObject);
    % %         handles.CalTestResult
    % %         if ~isfield(handles,'CalTestResult') || handles.CalTestResult~=1.1
    % %             ShowCursor
    % %             button = questdlg('Eyetracker needs recalibrating. Continue with experiment?','Calibration warning','Continue with poor calibration','Cancel experiment',2);
    % %             if strcmp(button,'Cancel experiment')
    % %                 aborted=1;
    % %             end
    % %         end
    % %     end
    
    if ~aborted
        HideCursor % again
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Call the right PTB program:
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Look up from GUI which expt to run:
        j = get(handles.expt2run,'value');
        expts2run = get(handles.expt2run,'string');
        expt2run = expts2run{j};
        set(handles.infotext,'string',sprintf('Running experiment %s',expt2run))
        
        expt.ExptType = expt2run;
            
        if strcmp(expt2run,'Whole-screen naming')
            exitedOK = Expt_WholeScreenNaming(expt);
        elseif strncmp(expt2run,'Patchwork',9)
            expt.ExptType = 'Patchwork';
            expt.nsquares = str2num(expt2run(end));
            exitedOK = Expt_Patchwork(expt);            
        elseif strcmp(expt2run,'Squares')
            exitedOK = Expt_FGBGsquares(expt);
        elseif strcmp(expt2run,'Scenes')
            exitedOK = Expt_Scenes(expt);
        end
        
        if exitedOK==1
            set(handles.infotext,'string','Program ran successfully');
        elseif exitedOK==2
            set(handles.infotext,'string','Experiment was aborted by user.');
        else
            set(handles.infotext,'string',sprintf('Program failed with error message %s',lasterr))
        end
        Screen('FillRect',expt.PTBwin,expt.blankcol)
        Screen('Flip',expt.PTBwin)
        % Put mouse back on experimetnter's screen:
        SetMouse(500,500,setdiff([1 2],expt.screenID))
    end
catch
    ShowCursor
    if exist('expt')
        SetMouse(500,500,setdiff([1 2],expt.screenID))
    end
    lasterr
    set(handles.infotext,'string',sprintf('Program failed with error message %s',lasterr))
end
ShowCursor

set(handles.startexpt,'visible','on')
set(handles.stopexpt,'visible','off')
% Refresh the file list:
currdir_Callback(handles.currdir, [], handles);

% Wait for sound output to finish, then close sound channel:
status=PsychPortAudio('GetStatus',expt.soundhandle);
while status.Active
    status=PsychPortAudio('GetStatus',expt.soundhandle);
end
ShowCursor
% Bring the GUI to the front and give it focus:
figure(handles.figure1); % - doesn't work with PTB window up.

% --- Executes on button press in stopexpt.
function stopexpt_Callback(hObject, eventdata, handles)
% hObject    handle to stopexpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sca
set(handles.startexpt,'visible','on')
set(handles.stopexpt,'visible','off')




% --- Executes on button press in extractdata.
function extractdata_Callback(hObject, eventdata, handles)
% When pressed, go through all files selected and extrct key values
% Begin writing extracteddata structure into an Excel file.
filename = strrep(['Data_' strrep(datestr(now),':','-') '.xls'],' ','_');

% Go through all files and extract data
filenames = get(handles.filenames,'string');
if isempty(filenames)
    set(handles.infotext,'string','No data-files are selected!')
    return
end
jselected = get(handles.filenames,'value');
selectedfiles = {filenames{jselected}};

% All expts will have this:
additionalheaderrow1 = {'General information about subject and test' '' '' '' '' '' ''  ...
    'Summary of all trials done' '' '' '' '' '' };
basicfieldstoread = {'subject' 'subjectgender' 'subjectbirthmonthyear' 'monthyearoftest' 'ageattesting_inyears' 'timestamp' 'notes' ...
'ntrialsdone' 'nnoresponse' 'minTnoresponse'  'ncorrect' 'meanRT_correct' 'SDRT_correct'};


filetypes = { 'ColPchwk4' 'ColSqurs3' 'Adjv' 'Noun' }; % removed ColPcwk2 and 6..
n=length(filetypes);
for jprefix=1:n
    clear extracteddata
    thisfiletype = filetypes{jprefix}
    % Find all selected files which are of this type:
    jfiles = find(strncmp(selectedfiles,thisfiletype,length(thisfiletype)));
    
    % Decide which fields to export for this file-type:
    if ~isempty(findstr(thisfiletype,'Pchwk')) || ~isempty(findstr(thisfiletype,'SglTgt'))
        % It is a patchwork or single-target experiment:
        otherfieldstoread = {   };
        additionalheaderrow2 = {};
    elseif  ~isempty(findstr(thisfiletype,'Squrs'))
        % It is a main FG/BG expt:
        otherfieldstoread = { 'ntrialsdone_tgtinFG' 'nnoresponse_tgtinFG' 'ncorrect_tgtinFG' 'meanRT_correct_tgtinFG' 'SDRT_correct_tgtinFG' ...
            'ntrialsdone_tgtinBG' 'nnoresponse_tgtinBG' 'ncorrect_tgtinBG' 'meanRT_correct_tgtinBG' 'SDRT_correct_tgtinBG' ...
              'ntrialsdone_tgtabsent' 'nnoresponse_tgtabsent' 'ncorrect_tgtabsent' 'meanRT_correct_tgtabsent' 'SDRT_correct_tgtabsent'};
          additionalheaderrow2 = {  '|- trials when target present in foreground' '' '' '' '-|' ...
              '|- trials when target present in background ' '' '' '' '-|' ...
              '|- trials when target absent ' '' '' '' '-|' };
    elseif ~isempty(findstr(thisfiletype,'Adjv')) || ~isempty(findstr(thisfiletype,'Noun'))
        % For this, insert extra columns recording number of errors made for each scene        
        otherfieldstoread = { 'ntrialsdone_tgtinFG' 'nnoresponse_tgtinFG' 'ncorrect_tgtinFG' 'meanRT_correct_tgtinFG' 'SDRT_correct_tgtinFG' 'nerrors_redFG' 'nerrors_greenFG' 'nerrors_blueFG' 'nerrors_yellowFG'  ...
            'ntrialsdone_tgtinBG' 'nnoresponse_tgtinBG' 'ncorrect_tgtinBG' 'meanRT_correct_tgtinBG' 'SDRT_correct_tgtinBG'  'nerrors_redBG' 'nerrors_greenBG' 'nerrors_blueBG' 'nerrors_yellowBG'  ...
            'ntrialsdone_tgtabsent' 'nnoresponse_tgtabsent' 'ncorrect_tgtabsent' 'meanRT_correct_tgtabsent' 'SDRT_correct_tgtabsent'   'nerrors_redABS' 'nerrors_greenABS' 'nerrors_blueABS' 'nerrors_yellowABS'  };
        additionalheaderrow2 = {  '|- trials when target present in foreground' '' '' '' '' '' '' '' '-|' ...
            '|- trials when target present in background ' '' '' '' '' '' '' '' '-|' ...
            '|- trials when target absent ' '' '' '' '' '' '' '' '-|' };
        
    else
        fprintf('Filetype %s not defined for excel output\n',thisfiletype);
        otherfieldstoread = '';
    end
        
    % Create two header rows before the main data:
    fieldstoread = {basicfieldstoread{:} otherfieldstoread{:}};
    additionalheaderrow = {additionalheaderrow1{:} additionalheaderrow2{:} };
    for jfield=1:length(fieldstoread)
        extracteddata{1,jfield} = additionalheaderrow{jfield};
        extracteddata{2,jfield} = fieldstoread{jfield};
    end
          
    for j=1:length(jfiles)
        file = [handles.lastvaliddatadir filesep selectedfiles{jfiles(j)}]        
               
        load(file,'expt');
        for jfield=1:length(fieldstoread)
            fld = fieldstoread{jfield};
            if ~isfield(expt,fld) | isnan(expt.(fld))
                extracteddata{j+2,jfield} = '-';
            else
                extracteddata{j+2,jfield} = expt.(fld);
            end
        end
        
        % Check that subject specified in filename agrees with values internal to file:
        [pathstr,thisfilename,ext,versn]=fileparts(file);
        juscore=findstr(thisfilename,'_');
        file_timestamp = thisfilename(juscore(end)+1:end); 
        file_subject = thisfilename(juscore(2)+1:juscore(3)-1); 
        if ~strcmp(expt.timestamp,file_timestamp) || ~strcmp(expt.subject,file_subject)
            jfield = find(strcmp(fieldstoread,'notes'));
            extracteddata{j+2,jfield} = ['!!! conflict between filename and contents. ' extracteddata{j+1,jfield}] ;
            % NB offset by 2 to allow for the 2 header rows.
        end
    end
    if ~isempty(jfiles)
        s(jprefix) = xlswrite(filename,extracteddata,thisfiletype);
    end
    
end
extracteddata
save tmp 
if exist('s') && ~isempty(s)&& sum(s)>0
    set(handles.infotext,'string',sprintf('Results successfully written to Excel file %s',filename))
else
    set(handles.infotext,'string','Error making Excel file.')
end


% --- Executes on selection change in dirnames.
function dirnames_Callback(hObject, eventdata, handles)
% Click to change directory
dirnames = get(hObject,'string');
j = get(hObject,'value');
newdir = dirnames{j};
[pathstr,name,ext,version]=fileparts(get(handles.currdir,'string'));
if strcmp(newdir,'..')
    % then move up a directory
    set(handles.currdir,'string',pathstr);
    currdir_Callback(handles.currdir, [], handles);
elseif strcmp(newdir,'.')
    % do nothing, stay in current directory
else
    str = get(handles.currdir,'string');
    set(handles.currdir,'string',[str filesep newdir]);
    currdir_Callback(handles.currdir, [], handles);
end

% --- Executes during object creation, after setting all properties.
function dirnames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirnames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filenames.
function filenames_Callback(hObject, eventdata, handles)
% hObject    handle to filenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns filenames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filenames


% --- Executes during object creation, after setting all properties.
function filenames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currdir_Callback(hObject, eventdata, handles)
% NB - this is the current directory for the dataa extraction & analysis,
% not for writing the data.
newdir = get(hObject,'string');
% Remove any double slashes, unless they occur at the front:
newdir(3:end) = strrep(newdir(3:end),'\\','\');
% Check new string is a valid directory
if ~isdir(newdir)
    he=errordlg(sprintf('Not a valid directory'),'Error setting directory:','modal');set(he,'pos',handles.dlgpos)
    set(hObject,'string',handles.lastvaliddatadir)
else
    handles.lastvaliddatadir = newdir;
    set(hObject,'string',newdir);
end
guidata(hObject, handles);
UpdateLocationInTree(handles)


% --- Executes during object creation, after setting all properties.
function currdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateLocationInTree(handles)
tmp  = dir(get(handles.currdir,'string'));
% Strip out special places:
cnt=0;
for j=1:length(tmp)
    if ~strcmp(tmp(j).name,'$RECYCLE.BIN') && ~strcmp(tmp(j).name,'System Volume Information')
        cnt=cnt+1;
        contents(cnt)=tmp(j);
    end
end
j=[contents.isdir];
dirs={contents(j).name};
set(handles.dirnames,'string',dirs,'value',1);
j=~[contents.isdir];
files={contents(j).name};
cnt=0;
for j=1:length(files)
    [pathstr,name,ext,version]=fileparts(files{j});
    if strcmp(ext,'.mat')
        cnt=cnt+1;
        matfiles{cnt} = files{j};
    end
end
if exist('matfiles') & ~isempty(matfiles)
    set(handles.filenames,'string',matfiles,'value',[1:length(matfiles)]); % by default ,select all mat files in directory
else
    set(handles.filenames,'string','');
end
guidata(handles.currdir, handles);


function CheckSubjectInfoComplete(handles)
% handlestoupdate(j)=1 means this handle needs to be updated; =0 means has
% already been updated.0
j = handles.subjectspecifichandles(handles.handlestoupdate==1);
set(j,'foregroundcol','r');
j = handles.subjectspecifichandles(handles.handlestoupdate==0);
set(j,'foregroundcol','k');
if sum(handles.handlestoupdate)==0
    set([handles.startexpt handles.EyeTracker],'visible','on')
    set(handles.uipanel2,'title','Participant information','foregroundcol','k');
else
    set(handles.startexpt,'visible','off')
    set(handles.uipanel2,'title','ENTER DETAILS:','foregroundcol','r');
end
% Update handles structure
guidata(handles.uipanel2, handles);


% --- Executes on selection change in ntrials.
function ntrials_Callback(hObject, eventdata, handles)
% hObject    handle to ntrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ntrials contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ntrials


% --- Executes during object creation, after setting all properties.
function ntrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ntrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in namelist.
function namelist_Callback(hObject, eventdata, handles)
% Note that this field has been updated:
handles.handlestoupdate(handles.subjectspecifichandles==hObject)=0;
CheckSubjectInfoComplete(handles)

% Use the sound file corresponding to this name:
jname = get(handles.namelist,'value');
names = get(handles.namelist,'string');
if strcmp(names{jname},'unavailable')
    handles.expt.namesoundfile = 'unavailable';
else
    handles.expt.namesoundfile = ['..' filesep 'namesounds' filesep names{jname} '.wav' ];
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function namelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function closeGUI(src,event)
selection = questdlg('Are you sure you''re finished?',...
    'Close Control Panel',...
    'Yes','No','Yes');
switch selection
    case 'Yes'
        % Tidy up
        delete(gcf)
        PsychPortAudio('Close');
        sca
        % exit
    case 'No'
        return
end


% --- Executes on button press in EyeTracker.
function EyeTracker_Callback(hObject, eventdata, handles)
% hObject    handle to EyeTracker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v = get(handles.EyeTracker,'value');
% objects which should only be visible if eyetracking is on
hh = [handles.caliblev handles.calibrate handles.text22 handles.TestCalibration handles.checkETacc handles.text24 handles.ncalpoints];
% Picture of eyes
axes(handles.eyepic);
if v
    set(hObject,'foregroundcol','k','string','ON')
    image(handles.im_eyetracking)
    set(hh,'visible','on')
    handles.expt.eyetracking = 1;
else
    set(hObject,'foregroundcol','k','string','OFF')
    image(handles.im_noeyetracking)
    set(hh,'visible','off')
    handles.expt.eyetracking = 0;
end
axis off
guidata(hObject,handles);


function caliblev_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function caliblev_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in calibrate.
function calibrate_Callback(hObject, eventdata, handles)
if get(handles.EyeTracker,'value')
    set(handles.infotext,'string','Running calibration - press SPACE when child is fixating first target')
    drawnow
    try
        % Get expt structure:
        expt = UpdateExptStructure(handles);
        % NB, this calls CheckEyeTrackerConnection which
        % reads off the calirbation paraemeters set in the GUI
        
        handles=guidata(hObject);
        if ~expt.ivx.connected
            % we could not get a valid connection to the eyetracker, so we
            % cannot calibrate
            return
        end
        % Look up parameters to use for calibration:
        
         % Run calibration
        result=IVXCalibration3(expt);
        Screen('Flip',expt.PTBwin)
        % Save the result for reference
        handles.CalTestResult = result;
        guidata(hObject,handles);
        
        if floor(result)==1
            message = 'Calibration completed without error; no information available on its quality.';
            if result==1.1
                message = 'Calibration is good!';
            elseif result==1.3
                message = 'Calibration is poor-quality -- suggest you repeat.';
            end
        else
            message = 'Calibration failed';
        end
    catch
        SetMouse(500,500,setdiff([1 2],expt.screenID))
        ShowCursor
        lasterr
        message = sprintf('Calibration failed with error message %s',lasterr);
    end
else
    message = 'Eye tracking is not enabled!';
end
set(handles.infotext,'string',message)
figure(handles.figure1);

% --- Executes on button press in TestCalibration.
function TestCalibration_Callback(hObject, eventdata, handles)
set(handles.infotext,'string','Testing calibration')
drawnow
try
    % Get expt structure:
    expt = UpdateExptStructure(handles);
    if ~expt.ivx.connected
        % we could not get a valid connection to the eyetracker, so we
        % cannot calibrate
        return
    end
    % Run calibration
    result=IVXTestCalibration(expt);
    % Save the result for reference
    handles.CalTestResult = result;
    guidata(hObject,handles);
    if floor(result)==1
        message = 'Test completed without error; no information available on its quality.';
        if result==1.1
            message = 'Test suggests calibration is still good!';
        elseif result==1.3
            message = 'Test suggests need to recalibrate.';
        end
    else
        message = 'Test failed';
    end
catch
    SetMouse(500,500,setdiff([1 2],expt.screenID))
    ShowCursor
    lasterr
    message = sprintf('Test failed with error message %s',lasterr);
end
set(handles.infotext,'string',message)
figure(handles.figure1);

%---------------------------------------------------
function [handles,expt] = CheckEyeTrackerConnection(handles,expt)
% Check we have a valid connection to the eyetracker. If not, try and start
% one. When we have finished, expt.ivx and handles.ivx will be the same.
% If ivx.connected=1, then we have a valid connection. If not, we couldn't
% get one so eye-tracking has been turned off.
ivx=handles.ivx;
% See if the supplied ivx structure is valid; if not, get the default ivx structure:
if ~isstruct(ivx) || ~isfield(ivx,'host')
    ivx = IVXDefaults(expt);
end

% Set calibration level appropriately:
ivx.caliblevel = get(handles.caliblev,'value');

% Set numebr of calibration points:
strn = get(handles.ncalpoints,'string');
ncal = str2num(strn{get(handles.ncalpoints,'value')});
ivx.nCalPoints = ncal;

% If we have a connection, test its status:
stat=-1;
if isfield(ivx,'udp')
    try
        stat=pnet(ivx.udp,'status');
    catch
    end
end
if stat<=0 %then we do not have a valid connection
    % so open one up:
    ivx=IVXOpenup(ivx);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See if we are connected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ivx.connected=0;
IVXsend('ET_PNG',ivx);
data = IVXreceive(ivx);
% If we got 'ET_PNG' back, we are connected:
ivx.connected = strncmp(data,'ET_PNG',6);

if ~ivx.connected
    % Hm, not connected.
    % Try closing it down and starting again
    pnet('closeall');
    ivx=IVXOpenup(ivx);
    % Ping IviewX
    ivx.connected=0;
    IVXsend('ET_PNG',ivx);
    data = IVXreceive(ivx);
    % If we got 'ET_PNG' back, we are connected:
    ivx.connected = strncmp(data,'ET_PNG',6);
end
if ~ivx.connected
    'Cannot establish connection with eyetracker'
    set(handles.infotext,'string',sprintf('Cannot contact eyetracker; proceeding without eyetracking',lasterr))
    set(handles.EyeTracker,'value',0);
    % Write these changes back
    guidata(handles.figure1,handles);
    % and update for change in eyetracking status
    EyeTracker_Callback(handles.EyeTracker, [], handles);
else
    % We do have a working connection with the eyetracker!
    % Make sure it's ready etc:
    ivx = IVXPrepareForExpt(ivx);
end
% Write this ivx structure back to handles for safekeeping:
handles.ivx = ivx;
guidata(handles.figure1,handles);
% Write this into the expt structure for future use!
expt.ivx = ivx;




function expt = UpdateExptStructure(handles)
% Read current values off the GUI and update expt structure if necessary
% NB I only do the quick stuff here. Time-consuming stuff like loading
% files, I either do once for all in "DefineExptStructure" when the
% ControlPanel is opened, or in the relevant callback function when the experimenter changes a value, e.g. sets
% the child's name.
expt = handles.expt;

expt.Version = mfilename('fullpath');

% See if a PTB window is already open (should be) and open one if not (may
% have been closed following an error);
win = Screen('Windows');
if isempty(win)
    % win was empty: we need to open a window again
    expt = DefineExptStructure;
    % this also makes all the necessary textures
end
Screen(expt.PTBwin,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Update the image to display between trials, since this is
% gender-specific:
if get(handles.male,'value')
    expt.subjectgender = 'male';
    expt.intertrialtex = expt.intertrialtex_boy;
else
    expt.subjectgender = 'female';
    expt.intertrialtex = expt.intertrialtex_girl;
end

% In this version, the response mode is fixed:
expt.responsemode = 2;
expt.responsemodetype = 'touch target if present on screen; press "no" target if not';
% Set proportion of target-absent trials accordingly
if expt.responsemode==1
    expt.percenttrialstgtabsent = 0; % target is always present
else expt.responsemode==2 || expt.responsemode==3
    expt.percenttrialstgtabsent = 100/3; % target is absent on 4/12 trials
end
% Look up from GUI if we are using sound cues or visual cues:
if get(handles.visradiobutton,'val')==1
    expt.cuemode='Visual';
    expt.mode = 'Adjv';
end
if get(handles.soundradiobutton,'val')==1
    expt.cuemode='Sound';
    % Look up from GUI if we are doing adjectives or noun:
    if get(handles.nounradiobutton,'val')==1
        expt.mode='Noun';
    end
    if get(handles.adjradiobutton,'val')==1
        expt.mode='Adjv';
    end
end



% Work out age of subject
jmonth = get(handles.birthmonth,'value');
months = get(handles.birthmonth,'string');
jyear = get(handles.birthyear,'value');
years = get(handles.birthyear,'string');
expt.subjectbirthmonthyear = [months{jmonth} years{jyear}];

% Work out date of test:
tmp=datestr(now);
j=find(tmp=='-');
testmonth=tmp(j(1)+1:j(2)-1);
testyear = tmp(j(2)+1:j(2)+5);
expt.monthyearoftest = [testmonth testyear];
% Convert year to number:
numageyear = str2num(years{jyear});
numtestyear = str2num(testyear);
% Convert month to number:
months = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'  'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};
numagemonth = find(strcmp(months{jmonth},months))/12;
numtestmonth = find(strcmp(testmonth,months))/12;
expt.ageattesting_inyears =  + numtestyear + numtestmonth  - numageyear - numagemonth;

% Update timestamp:
expt.timestamp = strrep(strrep(datestr(now,30),' ','_'),':','-');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eye-tracking code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In between experiments, the ivx structure controlling the eyetracking is stored in handles.ivx.
% When we run an experiment, it gets written to expt.ivx so that everything
% needed to run teh experiment is contained within the expt structure.
% Check we have a valid connection to the eyetracker; attempt to open one
% if not.
% If successful, the ivx structure will be both written into expt.ivx and
% stored for future use in handles.ivx. If we cannot open a connection to
% the eye tracker, ivx.connected will be zero.
if expt.eyetracking
    [handles,expt] = CheckEyeTrackerConnection(handles,expt);
    expt.ivx.fig = GetEyeTrackerFig(handles,expt);
    handles = guidata(handles.figure1);
end

expt.headrestalert = get(handles.headrest,'val');

expt = orderfields(expt);

function fig = GetEyeTrackerFig(handles,expt);
% figure to show eytracking data:
if ~isfield(handles,'eyetrackerfig')
    handles.eyetrackerfig = figure;
end
figure(handles.eyetrackerfig);
set(handles.eyetrackerfig,'pos',[666   254   755   566],'numbertitle','off','name','Eye tracker results');
guidata(handles.figure1,handles);
fig = handles.eyetrackerfig;


% --- Executes on button press in checkETacc.
function checkETacc_Callback(hObject, eventdata, handles)
set(handles.infotext,'string','Testing accuracy of eyetracking data')
drawnow
try
    % Get expt structure:
    expt = UpdateExptStructure(handles);
    if ~expt.ivx.connected
        % we could not get a valid connection to the eyetracker, so we
        % cannot calibrate
        return
    end
    % Run calibration
    result=IVXTestAccuracy(expt);
    message = 'Accuracy test complete';
catch
    SetMouse(500,500,setdiff([1 2],expt.screenID))
    ShowCursor
    lasterr
    message = sprintf('Accuracy test failed with error message %s',lasterr);
end
set(handles.infotext,'string',message)
figure(handles.figure1);


% --- Executes on selection change in ncalpoints.
function ncalpoints_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ncalpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in headrest.
function headrest_Callback(hObject, eventdata, handles)
v = get(hObject,'value');
if v
    set(hObject,'foregroundcol','k','string','ON')
else
    set(hObject,'foregroundcol','k','string','OFF')
end


% --- Executes on button press in visradiobutton.
function visradiobutton_Callback(hObject, eventdata, handles)
if get(hObject,'value')==1
    set(handles.soundradiobutton,'value',0);
else
    set(handles.soundradiobutton,'value',1);
end
% Hide the Adj/Noun buttons, if they have selected a visual cue:
j = get(handles.expt2run,'value');
expts = get(handles.expt2run,'string');
expt2run = expts{j};
if strcmp(expt2run,'Scenes') && get(handles.soundradiobutton,'value')==1
    set(handles.uipanel13,'visible','on')
else
    set(handles.uipanel13,'visible','off')
end


% --- Executes on button press in soundradiobutton.
function soundradiobutton_Callback(hObject, eventdata, handles)
if get(hObject,'value')==1
    set(handles.visradiobutton,'value',0);
else
    set(handles.visradiobutton,'value',1);
end
% Hide the Adj/Noun buttons, if they have selected a visual cue:
j = get(handles.expt2run,'value');
expts = get(handles.expt2run,'string');
expt2run = expts{j};
if strcmp(expt2run,'Scenes') && get(handles.soundradiobutton,'value')==1
    set(handles.uipanel13,'visible','on')
else
    set(handles.uipanel13,'visible','off')
end