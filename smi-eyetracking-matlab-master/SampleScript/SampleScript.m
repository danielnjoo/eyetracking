%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show images of objects + allow for text input.
% Eye-tracking added
% Sample script
% Written by Stephanie Gagnon
% This version was last modified on 2012 Nov (show 1pic)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

commandwindow;
KeyboardType = -1;
Screen('Preference', 'SkipSyncTests', 0);


%% Path info
workDir = pwd;

stimdir = fullfile([workDir, '/Stimuli/']);
outdir = fullfile([workDir, '/Data/']);

%% Prompt Box for Subject Information, save to outdir
repeat=1;
while (repeat);
    prompt= {'Subject number'};
    defaultAnswer={'1'};
    answer=inputdlg(prompt,'Subject information',1, defaultAnswer);
    [subjno]=deal(answer{:});
    if isempty(str2num(subjno)) || ~isreal(str2num(subjno))
        h=errordlg('Subject Number must be an integers','Input Error'); repeat=1; uiwait(h);
    else
        cd(outdir)
        fileName=['Pilot_CvS','_',subjno,'.txt'];	% set data file directory and name
        if exist(fileName)~=0
            button=questdlg('Overwrite data?');
            if strcmp(button,'Yes'); repeat=0; end
        else
            repeat=0;
        end
    end
end

%% Open up data file
dataFile=fopen(fileName, 'a');
cd('..')

%% Sets up the title of the output file
fprintf(dataFile,('\nTrial\tStimulus\tRT\tInputType\tInputNum\tResponse\n')); %trial, pic, rt, type of input, num of type, response


screens = Screen('Screens');
screenNumber = max(screens);


%% Initialize some variables
subjNUMstr = subjno;
subjno=str2num(subjno);
keynum=0;
rt=0;
trial=1; %trial number
CYCLE=4; % # times to present each image
example=1; %otherwise 0
practice=0; % if starting w/practice trials, 0 otherwise
ISI = 1; %how long to wait between diff objects
numpics = 1; % modified for adjusting Eye-tracker
picnum = randperm(numpics); % random 1-numpics, and then later add 36 if even subjno
evenSubj_picnum = 0;

%% Set up eye tracking
eyetracking = input('Eyetracking (1 to enable, 0 to disable): ');
if eyetracking  %Initialize variables
            numCalib = 9;   % number of calibration pts
            ETfileName=['Pilot_CvS','_',subjNUMstr,'.idf'];
            iView_outdir = ['"D:\MatlabFiles\Eyetracking&Matlab\SampleScript\Data\',ETfileName,'"'];
            % eye tracker connection settings -- Tufts Rm 304
            hport = 4444;                   % host port (iView)
            cport = 5555;                   % client port (Matlab)
            host = '127.0.0.1';             % host address (if internal)
            % UDP socket initialization
            udp = pnet('udpsocket',cport);
else
        display(sprintf('%s\t%s','Eyetracking:','disabled'))
end

%% Types of Inputs
response1= 'Response 1 Details...';
response2= 'Response 2 Details...';
response3= 'Response 3 Details...';
response4='Response 4 Details...';


%% Display Parameters
grey =  [180,180,180];
red = [255, 0,0];
black = 0;
TextStyle = 1;
Font = 'arial';
FontSize = 24;  %size for directions
TypingFontSize = 20; %size for typing input
LineSpacing = 2;
white = [256 256 256];
RETURN = 10;
DELETE = 8;
%ScreenWidth=RectWidth(screenRect);
%ScreenHeight=RectHeight(screenRect);
%SizeofScreen=[0 0 1280 800];
SizeofScreen = get(0,'ScreenSize');
imageWidth= 274;
imageHeight=274;
Top= SizeofScreen(3);
Bottom = SizeofScreen(4);
Middle = Bottom/2;
headingY = Middle- (.5*(Middle))%(imageHeight/2)-80;%'center'-137+20; %200%ScreenHeight/4;
typingY = Middle+(imageHeight/2)+50;%'center'+137+20; %800%ScreenHeight*(3/4);
top1Y = Middle-350;
top2Y = Middle-100;

%% Stimulus Presentation
HideCursor;
%set up the screen
Screen('Preference', 'VBLTimestampingMode', 1);
Screen('Preference','SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
Screen('Preference', 'SuppressAllWarnings', 1);
whichScreen = max(Screen('Screens')); %present on highest numbered screen
% offscreen window
window = Screen('OpenWindow', whichScreen);%,[],[1152,0,2179,768]);%
%sets according to global vars
Screen('TextFont',window, Font);
Screen('TextSize',window, FontSize);
Screen('TextStyle', window, TextStyle);
Screen('FillRect', window, grey);
Screen('Flip', window); %flips grey screen

%% Instructions
message = 'Instructions...\n\n\n\nPress the spacebar when you are ready to continue.';
DrawFormattedText(window,message,'center',top1Y,black);
Screen('Flip',window); % this prepares the objects in the back screen and then flips them to the front
WaitSecs(1); % wait before the spacebar will work
KbWait(KeyboardType);

%%Instructions about task
message ='More Instructions...\n\nPress the spacebar for a practice session.';
DrawFormattedText(window,message,'center','center',black);
Screen('Flip',window);
WaitSecs(1);
KbWait(KeyboardType);
%

%% START STUDY
%waitforscan(window)

% Start Eyetracking
RuniView(udp,host,hport);

TimeZero = GetSecs;


try
    %% Start the Image Presentation
    for i = 1:numpics;
        for repeat = 1:CYCLE;
            % determine pics to show
            img=([stimdir 'image_' num2str(picnum(i)) '.jpg']); %path to image, take image indexed i

            q=imread(img);
            tx=Screen('MakeTexture',window,q);
            Screen('DrawTexture',window,tx);
            
            %Larger font, change HEADING
            Screen('TextSize',window, FontSize);
            if repeat == 1;
                DrawFormattedText(window,response1,'center',headingY,black);
            else if repeat ==2;
                    DrawFormattedText(window,response2,'center',headingY,black);
                else if repeat == 3;
                        DrawFormattedText(window,response3,'center',headingY,black);
                    else if repeat == 4;
                            DrawFormattedText(window,response4,'center',headingY,black);
                        end
                    end
                end
            end
            
            Screen('Flip', window);
            
            imgOnsetTime = GetSecs;
            WaitSecs(0.5); % Don't let them respond immediately
            
            %% Type answers into screen
            Screen('TextSize',window,TypingFontSize);
            string = ''; %empty string
            FlushEvents ('keyDown');
            ListenChar(2);
            while 1
                typedInput = GetChar;
                switch(abs(typedInput))
                    case{RETURN},
                        break;
                    case {DELETE},
                        if ~isempty(string);
                            string= string(1:length(string)-1);
                            Screen('TextSize',window,TypingFontSize);
                            DrawFormattedText(window,string,'center',typingY,black);
                        end;
                    otherwise, % all other keys
                        string= [string typedInput];
                        Screen('TextSize',window,TypingFontSize);
                        DrawFormattedText(window,string,'center',typingY,black);
                end;
                Screen('DrawTexture',window,tx);
                %Larger font, change HEADING
                Screen('TextSize',window, FontSize);
                if repeat == 1;
                    DrawFormattedText(window,response1,'center',headingY,black);
                else if repeat ==2;
                        DrawFormattedText(window,response2,'center',headingY,black);
                    else if repeat == 3;
                            DrawFormattedText(window,response3,'center',headingY,black);
                        else if repeat == 4;
                                DrawFormattedText(window,response4,'center',headingY,black);
                            end
                        end
                    end
                end
                Screen('Flip', window);
                FlushEvents(['keyDown']);
            end
            
            % Reaction Time
            rt = Getsecs - imgOnsetTime;
            rt = rt*1000; %make intelligible
            
            %% Save into data file
            % change for data file
            if repeat == 1;
                typeOfInput= 'response1';
                else if repeat ==2;
                        typeOfInput= 'response2';
                    else if repeat == 3;
                            typeOfInput= 'response3';
                        else if repeat == 4;
                                typeOfInput = 'response4';
                            end
                        end
                    end
            end
            
            % Code image names
            if repeat == 1;
                inputNum= 1; % object name is coded as 4
                else if repeat ==2;
                        inputNum= 2;
                    else if repeat == 3; 
                            inputNum= 3;
                        else if repeat == 4;
                                inputNum= 4;
                            end
                        end
                    end
            end
                
            %% Save to output file
            fprintf(dataFile,'%d\t%d\t%3.3f\t%s\t%d\t%s\n',trial,picnum(i),rt,typeOfInput,inputNum,string); %trial, pic, rt, input type, input num, responses


            %Setup next trial
            string= '';
            keynum=0;
            inputNum = 0;
            rt=0;
            
            % Increment ET
            SMI_incrementTrial_SG(udp,host,hport);
        end
        %advance to next trial
        trial= trial+1;
        
        %  Show a blank screen between objects
        Screen('FillRect', window, grey);
        Screen('Flip', window); %flips grey screen
        WaitSecs(ISI);
    end
catch ME
    Screen closeall
    ListenChar(0);
    ShowCursor;
    rethrow(ME)
end

%% Finished Experiment, press SB to exit
message = 'You have just finished the experiment!\n\nPlease get the experimenter.';
DrawFormattedText(window,message,'center','center',black);
Screen('TextFont',window, Font);
Screen('Flip',window);

WaitSecs(1);
KbWait(KeyboardType);

%% Stop eye-tracking recording, save file
SMI_stopiView_SG(iView_outdir,udp,host,hport);

%% Close the textures that are open
Screen('Close', tx);

% Close everything else
Screen('CloseAll');
ShowCursor;
fclose('all');
