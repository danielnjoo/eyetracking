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
end