%% Clear all variables, connections
clear all
clc
warning('off', 'all');

%% Load sequences for test and real experiment
rng('shuffle'); % Reseed the random-number generator for each expt.
debuging = input('Is this a test?: ','s'); % set as 1 if you whant to run a short version
debug = str2num(debuging);
if debug == 1
    load('stim_cues150jpg');
    load('DEBUG_TrialSequenceProbailisticCT_3Phases','stim'); % load stimulus & trial sequence file (from 'generateTrialSequence.m')
else
    load('stim_cues150jpg');
    load('TrialSequenceProbailisticCT_3Phases','stim'); % load stimulus & trial sequence file (from 'generateTrialSequence.m')
end

%% Set up experimental parameters
param.subjID = input('Input subject ID: ','s'); 
param.probCaseID = input('Probability assignment case number [1,24]: '); % matches stim.probCase; range = [1 24]

%% Set directories according to computer working
curDir = pwd;
if isequal(computer, 'GLNXA64')
    dataDir = fullfile([curDir,'/DATA']);
elseif isequal(computer, 'MACI64')
    dataDir = fullfile([curDir,'/DATA']);
else
    dataDir = fullfile([curDir,'\DATA']); % where data will be saved
end
    
if ~exist(dataDir)
    mkdir(dataDir);
end

%% Tell the program where to start
crash = input('Did it crash (Yes = 1)?'); % in case task was interrupted
if crash == 1
    startPhase = input('Input phase number: '); % 1-3
    startBlock = input('Input block number: '); % 1-4
else
    startPhase = 1;
    startBlock = 1;
end

%% EXPERIMENTAL DESIGN & PARAMETERS
% 1) Learning Phase (IL) phase: 240 trials (4 blocks x 60 trials)
% 2) Experimental Phase (EP) Phase: 240 trials (4 blocks x 60trials)
% < 15 sec[stim + response] - 0.5 sec[feedback] - 1 sec ITI
% Although this code actually runs Phase 1 & 2, it generates sequences for
% all three phases

%% Parameters
param.nPhase = 2; %originally  set as 3;
param.namePhase = {'LP','EP'}; % Originally contained {'IL','NS','TS'}; 
param.TrialSequenceID = ceil(rand(1,param.nPhase)*10); % assign randomized sequence ID
param.nBlockPhase = stim.nBlockPhase; % total number of blocks per phase
param.nTrialBlock = stim.nTrialBlock; % total number of trials per block
param.nTrialPhase = stim.nTrialPhase; % total number of trials per phase
param.probCase = stim.probCase(param.probCaseID,:); % probability assigned to each cue dimension
for iP = 1 : param.nPhase
    param.randTrialSequenceBlock{iP} = stim.randTrialSequenceBlock{param.TrialSequenceID(iP),iP};
    param.probFeedback{iP} = stim.probFeedback{param.probCaseID}(stim.randTrialSequence{iP}(:,param.TrialSequenceID(iP)),:); % feedback probability matrix matched to param.seqTrial
    param.probFeedback10{iP} = stim.probFeedback10{param.probCaseID}(stim.randTrialSequence{iP}(:,param.TrialSequenceID(iP)),:); % feedback probability matrix matched to param.seqTrial
    for iB = 1 : param.nBlockPhase
        param.matCombinationL{iP}(:,iB) = stim.matCombination(param.randTrialSequenceBlock{iP}(:,iB),1); % left stimuli
        param.matCombinationR{iP}(:,iB) = stim.matCombination(param.randTrialSequenceBlock{iP}(:,iB),2); % right stimuli
        param.extFeedbackProb{iP}(:,iB) = stim.probFeedback{param.probCaseID}(param.randTrialSequenceBlock{iP}(:,iB),6); % feedback probability matrix matched to param.seqTrial % feedback probability extracted
    end
end

%% Timing (in sec)
param.tStim = 15; % stimulus+response display duration 
param.tFeedback = 0.5; % feedback duration
param.tITI = 1; % inter-trial-interval 

%% INITIALIZATION
AssertOpenGL;

%% Start Psychtoolbox
numScreen = max(Screen('Screens')); % use 3 for left; 2 for center; and 1 for right
[window,rect] = Screen('OpenWindow',numScreen); % w = designate window; rect = pixel coordinates
[c(1), c(2)] = RectCenter(rect);
dp.ScrSizePix(1) = rect(3); % screen width in pixel
dp.ScrSizePix(2) = rect(4); % screen height in pixel
dp.colorWhite = 255; % fixation color is "white"
dp.colorBlack = 0;
dp.colorBackground = 128; % background color is "gray"

%% Stimulus settings
dp.pxCueSize = 500; % stimulus size in pixels; 150x150 square
dp.dispLocation(1,:) = [c(1)-dp.ScrSizePix(1)/4-dp.pxCueSize/2, c(2)-dp.pxCueSize/2, c(1)-dp.ScrSizePix(1)/4+dp.pxCueSize/2, c(2)+dp.pxCueSize/2]; % left stimulus
dp.dispLocation(2,:) = [c(1)+dp.ScrSizePix(1)/4-dp.pxCueSize/2, c(2)-dp.pxCueSize/2, c(1)+dp.ScrSizePix(1)/4+dp.pxCueSize/2, c(2)+dp.pxCueSize/2]; % right stimulus
% i.e. location: [0,0,100,100] (0,0 is X,Y of the top left corner of texture. 100,100 is the X,Y of the textures bottom right corner)

%% Text settings
Screen('TextFont',window,'Arial');
Screen('TextSize',window, 36);

%% Response
KbName('UnifyKeyNames');  % Enable unified mode of KbName, so KbName accepts identical key names on all operating systems
param.keyRight = KbName('RightArrow'); % right index; right arrow
param.keyLeft = KbName('LeftArrow');  % left index; left arrow
param.keyGo = KbName('g');
ListenChar(2); % get key responses but suppresses output to the command window
HideCursor;

%% Make textures 
Screen('FillRect',window,dp.colorBackground);
DrawFormattedText(window,'Loading...','center','center',dp.colorBackground);
Screen('Flip',window);

for iS = 1 : stim.nCue
    matStim{iS} = Screen('MakeTexture',window,stimJPG{iS});
end

%% Save experimental parameters
if isempty(crash)
    save(fullfile(dataDir,[param.subjID '_expParameters']),'param'); %,'paramS','dp','DIO','out_lines');
end

%% TRACKER PARAMETERS

%% Load the iViewX API library and connect to the server
InitAndConnectiViewXAPI

%% Check tracker connection
if connected
    disp('Get System Info Data')
    ret_sys = iView.iV_GetSystemInfo(pSystemInfoData);
    
    if (ret_sys == 1 )
        disp(pSystemInfoData.Value)
    else
        msg = 'System Information could not be retrieved';
        disp(msg);
    end
    
 %% Calibration
    disp('Calibrate iViewX')
    ret_setCal = iView.iV_SetupCalibration(pCalibrationData);
    
    if (ret_setCal == 1 )
        
        ret_cal = iView.iV_Calibrate(); %% problem here with GetSecsTest, returns 3 not 1 
        
        if (ret_cal == 1 )
            
            disp('Validate Calibration')
            ret_val = iView.iV_Validate();
            
            if (ret_val == 1 )
                
                disp('Show Accuracy')
                ret_acc = iView.iV_GetAccuracy(pAccuracyData, int32(0));
                
                if (ret_acc == 1 )
                    
                    disp(pAccuracyData.Value)
                    
                else
                    
                    msg = 'Accuracy could not be retrieved';
                    disp(msg);
                end
                
            else
                msg = 'Error during validation';
                disp(msg);
                
            end
            
        else
            
            msg = 'Error during calibration';
            disp(msg);
        end
    else
        msg = 'Calibration data could not be set up';
        disp(msg);
    end
    
    try
        
        % Get the screen numbers
        screenNumbers = Screen('Screens');
        
        SecondaryScreenNumber = 2;
        PrimaryScreenNumber = 1;
        SingleScreenNumber = 0;
        
        %Choose Screen:
        ScreenNumber = PrimaryScreenNumber;
        %ScreenNumber = SecondaryScreenNumber;
        %ScreenNumber = SingleScreenNumber;
        
        % Note: To change the screen of the calibration/validation edit the
        % CalibrationData.displayDevice inside InitAndConnectiViewXAPI.m
        
        window = Screen('OpenWindow',0);
        HideCursor;
        exitLoop = 0;
        
        while ~(exitLoop)
            
            ret_sam = iView.iV_GetSample(pSampleData);
            
            if (ret_sam == 1)
                
                % get sample
                Smp = libstruct('SampleStruct', pSampleData);
                
                x0 = Smp.leftEye.gazeX;
                y0 = Smp.leftEye.gazeY;
                x1 = Smp.rightEye.gazeX;
                y1 = Smp.rightEye.gazeY;
                
               
                Screen('DrawDots', window, [x0,y0], 10, [0 0 255]);
                Screen('DrawDots', window, [x1,y1], 10, [0 0 255]);
                Screen( window,  'Flip');
                
            end
            
            pause(0.034);
            
            % end experiment after a mouse button has been pushed
            if (waitForMouseNonBlocking)
                exitLoop = 1;
            end
            
        end
        
    catch ME
        
        msg = 'Unable to track gaze';
        disp(msg);
        ME.message
        
        % Release screen
        Screen('CloseAll');
        ShowCursor
    end
end

        %% MAIN EXPERIMENT
        %% START BLOCK
        for iP = startPhase : param.nPhase

            %% Instructions
            Screen('FillRect',window,dp.colorBackground);

            if iP == 1
                DrawFormattedText(window,'First Round','center',c(2)-260,[178 255 102]); % displayed in green
                DrawFormattedText(window,'Your goal is to win as many trials as possible','center',c(2)-180,255);
            elseif iP == 2
                DrawFormattedText(window,'Second Round','center',c(2)-260,[178 255 102]); 
                DrawFormattedText(window,'The task is the same as Phase 1','center',c(2)-180,255);
                DrawFormattedText(window,'Your goal is to win as many trials as possible','center',c(2)-100,255);
            end    
            DrawFormattedText(window,'+','center','center',dp.colorWhite);
            DrawFormattedText(window,'Please do not move your left hand during the experiment','center',c(2)+100,[102 178 255]); % displayed in blue
            DrawFormattedText(window,'Press RIGHT ARROW key to continue','center',c(2)+180,dp.colorWhite);
            Screen(window, 'Flip');    
            while 1 % wait for subject's response
                [keyIsDown, timeKeyPress, keyCode] = KbCheck;
                if keyCode(param.keyRight)
                    break;
                end
            end

            timePhase = GetSecs; % record start time of the phase
            for iB = startBlock : param.nBlockPhase

                %% Initialize data matrices
                dE.randNumFeedback = zeros(param.nTrialBlock,1); % random number drawn in each trial
                dE.keyResp = NaN(param.nTrialBlock,1); % record left(1)/right(-1) key response
                dE.RT = NaN(param.nTrialBlock,1); % record RT
                dE.winTrial = zeros(param.nTrialBlock,1); % record actual feedback given
                dE.timeTrial = zeros(param.nTrialBlock,1); % records duration of each trial
                dE.timeStimCum = zeros(param.nTrialBlock,1); % records cumulative time from the phase starting point
                dE.timeFbCum = zeros(param.nTrialBlock,1);
                dE.points = zeros(param.nTrialBlock,1); % records amount of points obtained
                dE.bestDecision = zeros(param.nTrialBlock,1); % records optimal choice trials
                dE.leftWeight = zeros(param.nTrialBlock,1); % records left cue weight
                dE.rightWeight = zeros(param.nTrialBlock,1); % records right cue weight

                %% Block Introduction
                if iB > 1 % skip the first block intro (there's a phase intro instead)
                    initPhase = ['Block ' num2str(iB) '/' num2str(param.nBlockPhase)];
                    DrawFormattedText(window,initPhase,'center',c(2)-260,dp.colorWhite);
                    DrawFormattedText(window,'Your goal is to win as many trials as possible.','center',c(2)-180,255);
                    DrawFormattedText(window,'+','center','center',dp.colorWhite);
                    DrawFormattedText(window,'Please do not move your left hand during the experiment','center',c(2)+100,[102 178 255]); % displayed in blue
                    DrawFormattedText(window,'Press RIGHT ARROW key to continue','center',c(2)+180,dp.colorWhite);
                    Screen(window, 'Flip');
                    while 1 % wait for subject's response
                        [keyIsDown, timeKeyPress, keyCode] = KbCheck;
                        if keyCode(param.keyRight)
                            break;
                        end
                    end
                end

                %% Countdown 5 sec -> 1 sec fixation
                for tC = 5 : -1 : 0
                    Screen('FillRect',window,dp.colorBackground);
                    if tC > 0
                        DrawFormattedText(window,num2str(tC),'center','center',dp.colorWhite);
                    else
                        DrawFormattedText(window,'+','center','center',dp.colorWhite);
                    end
                    Screen(window, 'Flip');
                    WaitSecs(1);
                end

                %% START TRIAL
                for iT = 1 : param.nTrialBlock
                    timeTrial = GetSecs;
                    FlushEvents('keyDown'); flagKeypress = 0; % reset key press
                    dE.randNumFeedback(iT) = rand(1); % draw a random number (used for feedback determination)

                    %% Stimuli presentation
                    Screen('FillRect',window,dp.colorBackground);
                    DrawFormattedText(window,'+','center','center',dp.colorWhite);
                    Screen('DrawTexture',window,matStim{param.matCombinationL{iP}(iT,iB)},[],dp.dispLocation(1,:));
                    Screen('DrawTexture',window,matStim{param.matCombinationR{iP}(iT,iB)},[],dp.dispLocation(2,:));
                    [timeVBL,timeStim,timeFlip,Missed,Beampos] = Screen(window, 'Flip');

                    %% Check for button press within stimuli presentation
                    while (GetSecs - timeStim) < param.tStim
                        if flagKeypress == 0 % record only the first response
                            [keyIsDown, timeKeyPress, keyCode] = KbCheck;
                            if keyIsDown && keyCode(param.keyLeft) > 0 % left key is pressed
                                dE.keyResp(iT) = 1; % left = 1
                                dE.RT(iT) = timeKeyPress - timeStim;
                                if dE.randNumFeedback(iT) < param.extFeedbackProb{iP}(iT,iB) % win
                                    dE.winTrial(iT) = 1;
                                end
                                flagKeypress = 1;
                            elseif keyIsDown && keyCode(param.keyRight) > 0 % right key is pressed
                                dE.keyResp(iT) = -1; % right = -1
                                dE.RT(iT) = timeKeyPress - timeStim;
                                if dE.randNumFeedback(iT) >= param.extFeedbackProb{iP}(iT,iB) % win
                                    dE.winTrial(iT) = 1;
                                end
                                flagKeypress = 1;
                            end
                        end

                        if flagKeypress == 1 % if a response is made, move on
                            break;
                        end
                    end

                    %% Probabilistic feedback
                    % This compares a random number between 0-1 vs the weight of
                    % the selected cue. If larger is a win. 
                    Screen('FillRect',window,dp.colorBackground);
                    if isnan(dE.keyResp(iT))  % no response
                        DrawFormattedText(window,'Miss','center','center',dp.colorWhite);
                        DrawFormattedText(window,'0','center','center',c(2)+100,dp.colorWhite);
                        dE.points(iT) = 0; 
                    elseif dE.winTrial(iT) == 1 && dE.timeTrial(iT) <= (mean(dE.timeTrial)+ std(dE.timeTrial)) && dE.timeTrial(iT) >= (mean(dE.timeTrial) - std(dE.timeTrial)) %% mean+std > RT > mean-std (Normal range)
                        DrawFormattedText(window,'Win','center','center',dp.colorWhite);
                        DrawFormattedText(window,'+1','center','center',c(2)+100,dp.colorWhite);
                        dE.points(iT) = 1; 
                    elseif dE.winTrial(iT) == 1 && dE.timeTrial(iT) < mean(dE.timeTrial) - std(dE.timeTrial) %% RT < mean-std (Fast range)
                        DrawFormattedText(window,'Win','center','center',dp.colorWhite);
                        DrawFormattedText(window,'+2','center','center',c(2)+100,dp.colorWhite);
                        dE.points(iT) = 2;            
                    elseif dE.winTrial(iT) == 1 && dE.timeTrial(iT) > (mean(dE.timeTrial) + std(dE.timeTrial)) %% RT > mean + std (Slow threshold)
                        DrawFormattedText(window,'Correct but SLOW','center','center',dp.colorWhite);
                        DrawFormattedText(window,'0','center','center',c(2)+100,dp.colorWhite);
                          dE.points(iT) = 0; 
                    elseif dE.winTrial(iT) == 0 %% Lost trial
                        DrawFormattedText(window,'Incorrect','center','center',dp.colorWhite);
                        DrawFormattedText(window,'0','center','center',c(2)+100,dp.colorWhite);
                        dE.points(iT) = 0; 
                    end
                    [timeVBL,timeFb,timeFlip,Missed,Beampos] = Screen(window, 'Flip');
                    while (GetSecs - timeFb) < param.tFeedback
                    end

                    %% Check if participant's choice was the best
                    % All is relative to the left stimuli. Since max probability = 1.0
                    % L = 1-Right & R = 1-Left
                    % L > 0.5 ---> L wins
                    % L < 0.5 ---> R wins
                    if param.extFeedbackProb{iP}(iT,iB) > 0.5 & dE.keyResp(iT) == 1 
                        dE.bestDecision(iT) = 1;
                    elseif param.extFeedbackProb{iP}(iT,iB) > 0.5 & dE.keyResp(iT) == -1
                        dE.bestDecision(iT) = 0;
                    elseif param.extFeedbackProb{iP}(iT,iB) < 0.5 & dE.keyResp(iT) == -1
                        dE.bestDecision(iT) = 1;
                    elseif param.extFeedbackProb{iP}(iT,iB) < 0.5 & dE.keyResp(iT) == 1
                        dE.bestDecision(iT) = 0;
                    elseif param.matCombinationL{iP}(iT,iB) == 0.5 % if left and right weights are the same, discard trial
                        dE.bestDecision(iT) = NaN;
                    end

                    %% Get the weight of each cue
                    dE.leftWeight(iT)= param.extFeedbackProb{iP}(iT,iB); 
                    dE.rightWeight(iT)= 1 - dE.leftWeight(iT); 

                    %% ITI
                    Screen('FillRect',window,dp.colorBackground);
                    DrawFormattedText(window,'+','center','center',dp.colorWhite);
                    Screen(window, 'Flip');
                    WaitSecs(param.tITI);

                    dE.timeTrial(iT) = GetSecs- timeTrial; % records duration of each trial
                    dE.timeStimCum(iT) = timeStim - timePhase; % records cumulative stim onset since the phase start time
                    dE.timeFbCum(iT) = timeFb - timePhase; % records cumulative feedback onset since the phase start time
                end

                %% Performance summary (diplayed at the end of each block)
                dE.cumPoints(1) = nansum(dE.points); % number of win trials
                dE.cumPoints(2) = nansum(dE.winTrial)/param.nTrialBlock*100; % percentage of win trials
                textScorePhase = ['Points earned in this block: ' num2str(dE.cumPoints(1)) ' (' num2str(round(dE.cumPoints(2))) '% win)'];
                Screen('FillRect',window,dp.colorBackground);
                DrawFormattedText(window,['This is the end of Block ' num2str(iB)],'center',c(2)-150,dp.colorWhite);
                DrawFormattedText(window,textScorePhase,'center','center',[178 255 102]); % displayed in green
                DrawFormattedText(window,'Please take a short break.','center',c(2)+150,dp.colorWhite);
                Screen(window, 'Flip');         

                %% SAVE DATA AFTER EACH BLOCK
                save(fullfile(dataDir,[param.subjID '_' param.namePhase{iP} '_Block' num2str(iB)]),'dE','iP','iB'); 
                WaitSecs(5);
            end

            %% Ending text
            Screen('FillRect',window,dp.colorBackground);
            DrawFormattedText(window,['This is the end of the Phase ' num2str(iP)],'center','center',dp.colorWhite);
            DrawFormattedText(window,'Please wait for the experimenter.','center',c(2)+150,dp.colorWhite);
            Screen(window, 'Flip');
            if iP == 1
                while 1
                    [keyIsDown, timeKeyPress, keyCode] = KbCheck;
                    if keyIsDown && keyCode(param.keyGo) > 0
                        break;
                    end
                end
            else
                WaitSecs(3);
            end
        end


%% EXIT EXPERIMENT
Screen('CloseAll');
ListenChar(0);
ShowCursor;

