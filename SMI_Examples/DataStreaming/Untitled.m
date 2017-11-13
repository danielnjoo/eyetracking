InitAndConnectiViewXAPI 
try  
    for i = 1:100

        ret_sam = iView.iV_GetSample(pSampleData);

        if (ret_sam == 1)

            Smp = libstruct('SampleStruct', pSampleData);
            msg =	[int2str(i) '  ' int2str(Smp.timestamp) ' - GazeX: ' int2str(Smp.leftEye.gazeX) ' - GazeY: ' int2str(Smp.leftEye.gazeY)];
            disp(msg);

        else

            msg = 'Unable to get gaze samples';
            disp(msg)

        end

        pause(0.025); %% originally 0.034, but the faster the refresh, the better?

    end

catch ME

    msg = 'Unable to get gaze samples';
    disp(msg);
    ME.message
        
end