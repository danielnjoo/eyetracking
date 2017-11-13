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
% Slideshow.m
%
% This script shows how to connect to SMI eye tracking application,
% calibrate the eye tracker and record eye tracking data while stimulus images will be shown
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
  
    
    image1 = imread('1280\image01.jpg');
    image2 = imread('1280\image02.jpg');
    image3 = imread('1280\image03.jpg');
    
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
        
        window = Screen('OpenWindow',ScreenNumber);
        HideCursor;
        
        %% Set Recording
        % clear buffer and  start recording
        ret_clr = iView.iV_ClearRecordingBuffer();
        ret_str = iView.iV_StartRecording();
        
        if (ret_str ~=1 || (ret_clr ~= 1 && ret_clr ~= 191)  )
            disp('Recording could not be set up')
        end
        
        % show first image
        ret_msg = iView.iV_SendImageMessage('image01.jpg');
        
        if(ret_msg ~= 1)
            disp('Message could not be sent')
        end
        
        texture1 = Screen('MakeTexture', window, image1);
        Screen('DrawTexture', window, texture1);
        Screen(window, 'Flip');
        pause(3);
        
        % show second image
        ret_msg = iView.iV_SendImageMessage('image02.jpg');
        
        if(ret_msg ~= 1)
            disp('Message could not be sent')
        end
        
        texture2 = Screen('MakeTexture', window, image2);
        Screen('DrawTexture', window, texture2);
        Screen(window, 'Flip');
        pause(3);
        
        % show third image
        ret_msg = iView.iV_SendImageMessage('image03.jpg');
        
        if(ret_msg ~= 1)
            disp('Message could not be sent')
        end
        
        texture3 = Screen('MakeTexture', window, image3);
        Screen('DrawTexture', window, texture3);
        Screen(window, 'Flip');
        pause(3);
        
        % stop recording
        ret_stop = iView.iV_StopRecording();
        
        if(ret_stop ~= 1)
            disp('Recording could not be stopped correctly')
        end
        
        %% Release screen
        Screen('CloseAll');
        ShowCursor
        
        % save recorded data
        user = 'User1';
        description = 'Description1';
        ovr = int32(1);
        current_wd = pwd;
        filename = fullfile(current_wd,['iViewXSDK_Matlab_Slideshow_Data_' user '.idf']);
        ret_save = iView.iV_SaveData(filename, description, user, ovr);
        
        if(ret_save ~= 1)
            disp('Recording data could not be saved')
        end
        
    catch ME
        
        msg = 'Unable to run slideshow';
        disp(msg);
        ME.message
        
        % Release screen
        Screen('CloseAll');
        ShowCursor
    end
end


%% Unload the iViewX API library and disconnect from the server
UnloadiViewXAPI



