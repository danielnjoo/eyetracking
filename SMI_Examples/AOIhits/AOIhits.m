% -----------------------------------------------------------------------
%
% (c) Copyright 1997-2017, SensoMotoric Instruments GmbH
%
% Permission  is  hereby granted,  free  of  charge,  to any  person  or
% organization  obtaining  a  copy  of  the  software  and  accompanying
% documentation  covered  by  this  license  (the  "Software")  to  use,
% reproduce,  display, distribute, execute,  and transmit  the Software,
% and  to  prepare derivative  works  of  the  Software, and  to  permit
% third-parties to whom the Software  is furnished to do so, all subject
% to the following:
%
% The  copyright notices  in  the Software  and  this entire  statement,
% including the above license  grant, this restriction and the following
% disclaimer, must be  included in all copies of  the Software, in whole
% or  in part, and  all derivative  works of  the Software,  unless such
% copies   or   derivative   works   are   solely   in   the   form   of
% machine-executable  object   code  generated  by   a  source  language
% processor.
%
% THE  SOFTWARE IS  PROVIDED  "AS  IS", WITHOUT  WARRANTY  OF ANY  KIND,
% EXPRESS OR  IMPLIED, INCLUDING  BUT NOT LIMITED  TO THE  WARRANTIES OF
% MERCHANTABILITY,   FITNESS  FOR  A   PARTICULAR  PURPOSE,   TITLE  AND
% NON-INFRINGEMENT. IN  NO EVENT SHALL  THE COPYRIGHT HOLDERS  OR ANYONE
% DISTRIBUTING  THE  SOFTWARE  BE   LIABLE  FOR  ANY  DAMAGES  OR  OTHER
% LIABILITY, WHETHER  IN CONTRACT, TORT OR OTHERWISE,  ARISING FROM, OUT
% OF OR IN CONNECTION WITH THE  SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% -----------------------------------------------------------------------
% AOIhits.m
%
% This script shows how to define AOIs and to detect to which one the gaze is
% directed.
%
% Compatible version Matlab 7.14 32 bits
%                    Psychtoolbox Version 3.0.11  http://psychtoolbox.org
%
% Author: SMI GmbH

%% Clear all variables, connections, ...
clear all
clc
warning('off', 'all');

%% Load the iViewX API library and connect to the server
InitAndConnectiViewXAPI

%% Tracking
if connected
    
    try
        
        %% Calibration
        disp('Calibrate iViewX')
        
        ret_setCal = iView.iV_SetupCalibration(pCalibrationData);
        
        if (ret_setCal == 1 )
            
            ret_cal = iView.iV_Calibrate();
            
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
        
        
        %% Get the AOIs position based on the screen information
        % Refer to Psychtoolbox Documentation
        
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
        
        % Define black and white
        white = WhiteIndex(ScreenNumber);
        black = BlackIndex(ScreenNumber);
        red = [255 0 0];
        green = [0 255 0];
        blue = [0 0 255];
        gray = [100 100 100];
        
        % Open an on screen window and get its size 
        [window, windowRect] = Screen('OpenWindow', ScreenNumber, white);
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        
        % Get the centre coordinate of the window and create a base
        % rectangle for the AOIs
        [xCenter, yCenter] = RectCenter(windowRect);
        baseRect = [0 0 400 400];
        
        % Compute  the Screen X positions of the AOIs and define colors
        squareXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
        numSquares = length(squareXpos);
        allColors = [red; green; blue];
        
        % Make our rectangle coordinates
        AOIs = nan(4, 3);
        
        for i = 1:numSquares
            AOIs(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end
        penWidthPixels = 6;
        
        HideCursor;
        
        %% AOI Definition 
        
        AOIRecStructData.x1 = AOIs(1,1);
        AOIRecStructData.y1 = AOIs(2,1);
        AOIRecStructData.x2 = AOIs(3,1);
        AOIRecStructData.y2 = AOIs(4,1);
        AOIData.aoiGroup = int8('Group1');
        AOIData.aoiName = int8('AOI1');
        AOIData.enabled = int32(1);
        AOIData.eye = int8('l');
        AOIData.fixationHit = int32(1);
        AOIData.outputMessage = int8('Output Message to file from AOI1');
        AOIData.outputValue = int32(1);
        AOIData.position = AOIRecStructData;
        pAOIStruct = libpointer('AOIStruct', AOIData);
        ret_defAOI1 = iView.iV_DefineAOI(pAOIStruct);
        
        AOIRecStructData.x1 = AOIs(1,2);
        AOIRecStructData.y1 = AOIs(2,2);
        AOIRecStructData.x2 = AOIs(3,2);
        AOIRecStructData.y2 = AOIs(4,2);
        AOIData.aoiGroup = int8('Group1');
        AOIData.aoiName = int8('AOI2');
        AOIData.enabled = int32(1);
        AOIData.eye = int8('l');
        AOIData.fixationHit = int32(1);
        AOIData.outputMessage = int8('Output Message to file from AOI2');
        AOIData.outputValue = int32(2);
        AOIData.position = AOIRecStructData;
        pAOIStruct = libpointer('AOIStruct', AOIData);
        ret_defAOI2 = iView.iV_DefineAOI(pAOIStruct);
        
        AOIRecStructData.x1 = AOIs(1,3);
        AOIRecStructData.y1 = AOIs(2,3);
        AOIRecStructData.x2 = AOIs(3,3);
        AOIRecStructData.y2 = AOIs(4,3);
        AOIData.aoiGroup = int8('Group1');
        AOIData.aoiName = int8('AOI3');
        AOIData.enabled = int32(1);
        AOIData.eye = int8('l');
        AOIData.fixationHit = int32(1);
        AOIData.outputMessage = int8('Output Message to file from AOI3');
        AOIData.outputValue = int32(3);
        AOIData.position = AOIRecStructData;
        pAOIStruct = libpointer('AOIStruct', AOIData);
        ret_defAOI3 = iView.iV_DefineAOI(pAOIStruct);
        
        % pointer to OutputValue
        OutputValue = int32(0);
        pOutputValue =  libpointer('int32Ptr',OutputValue);
        
        %% Get samples and detect AOI hits
        exitLoop = 0;
        
        if (ret_defAOI1 == 1 && ret_defAOI2 == 1 && ret_defAOI3 == 1)
            
            while ~(exitLoop)
                
                ret_samp = iView.iV_GetSample(pSampleData);
                
                if (ret_samp == 1)
                    
                    % get sample for printing
                    Smp = libstruct('SampleStruct', pSampleData);
                    
                    x0 = Smp.leftEye.gazeX;
                    y0 = Smp.leftEye.gazeY;
                    xr = Smp.rightEye.gazeX;
                    yr = Smp.rightEye.gazeY;
                    
                    ret_out = iView.iV_GetAOIOutputValue(pOutputValue);
                    msg =	[int2str(Smp.timestamp) ' - GazeX: ' int2str(x0) ', ' int2str(xr) ' - GazeY: ' int2str(y0) ', ' int2str(yr) ...
                        ' - Ret: ' int2str(ret_out)  ' - Output Value: ' int2str(pOutputValue.Value)];
                    disp(msg);
                    
                    %Draw gaze points
                    if (ret_out == 1)
                        switch pOutputValue.Value
                            
                            case 1
                                Screen('DrawDots', window, [x0,y0], 30, red);
                                Screen('DrawDots', window, [xr,yr], 30, red);
                            case 2
                                Screen('DrawDots', window, [x0,y0], 30, green);
                                Screen('DrawDots', window, [xr,yr], 30, green);
                            case 3
                                Screen('DrawDots', window, [x0,y0], 30, blue);
                                Screen('DrawDots', window, [xr,yr], 30, blue);
                            otherwise
                                Screen('DrawDots', window, [x0,y0], 30, black);
                                Screen('DrawDots', window, [xr,yr], 30, black);
                        end
                    else
                        Screen('DrawDots', window, [x0,y0], 30, gray);
                        Screen('DrawDots', window, [xr,yr], 30, gray);
                        disp('AOIOutputValue could not be retrieved')
                    end
                    
                    
                    %Draw AOIs
                    Screen('FrameRect', window, allColors, AOIs, penWidthPixels);
                    Screen('Flip', window);
                    
                end
                
                
                pause(0.01);
                
                % end experiment after a mouse button has been pushed
                if (waitForMouseNonBlocking)
                    exitLoop = 1;
                end
                
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

%% Release screen
Screen('CloseAll');
ShowCursor


%% Unload the iViewX API library and disconnect from the server
UnloadiViewXAPI







