% calibration routine, largely based on iViewX toolbox
% Seems to be working OK now with just those disks. Now trying to get it
% working with animations.

result=1;

% File to store calibration data to:
filename = 'test';

try 
    %% start of Frans Cornelissen's iViewX code
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [success, ivx]=iViewX('stoprecording', ivx); % ?? necessary
    data = IVXreceive(ivx)
    [success, ivx]=iViewX('startrecording', ivx);
    data = IVXreceive(ivx)
    % send (possibly adapted) calibration point positions
    [success, ivx]=iViewX('setcalibration', ivx, ivx.nCalPoints); %??
    [success, ivx]=iViewX('sendcalibrationpoints', ivx);
    
    % now we should wait for iView to send
    % information on calibration screen size
    % and calibration point positions
    tBreak=GetSecs+ivx.commTimeOut;
    npts=0;
    klaar=0;
    while klaar==0
        [keyIsDown,secs,keyCode] = KbCheck;
        if 1==keyCode(ivx.modifierKey) & 1==keyCode(ivx.breakKey)
            fprintf('Break or modifier key detected')
            result=-1;
            return;
            break;
        end
        
        if GetSecs>tBreak
            fprintf([mfilename ': timed out waiting for data.\n']);
            result=-1;
            return
        end
        [data, ivx]=iViewX('receivedata', ivx);
        
        if ~isempty(data) & data ~=-1
            
            data
            
            tBreak=GetSecs+ivx.commTimeOut; % reset time out
            
            if strfind(data, 'ET_CHG')
                pt=str2num(data(8:end));
                fprintf('Change to point: %d\n', pt);
                % this signals we have all the points
                klaar=1;
                break;
            elseif strfind(data, 'ET_PNT')
                coords=str2num(data(8:end));
                %                 fprintf('Coords for point %d:\t%d\t%d\n', coords(1), coords(2), coords(3));
                npts=npts+1;
                if coords(1) ~=npts
                    fprintf('Point order mismatch\n');
                end
                ivx.absCalPos(coords(1),:)=coords(2:3); % 1 is point nr.
            elseif strfind(data, 'ET_CSZ')
                % we should receive this message first
                scr_size=str2num(data(8:end));
                fprintf('Screen: %d\t%d\n', scr_size(1), scr_size(2));
                % we could check if the screen size reported matches the one
                % expected
            end
        end
    end
    
    
    fprintf('Calibrating using %d points (%d received).\n', size(ivx.absCalPos,1), npts);
    while ~isempty(data)
        data = IVXreceive(ivx);
    end
    
    iViewX('erasescreen', ivx);
    
    nPointsShown=0;
    allowManAccept=1;
    % we now draw first calibration point and then
    % start a loop in which we wait for iView to tell us
    % when to draw the next calibration point
    
    jframe=[];jtgt=[]; 
    
    tBreak=GetSecs+ivx.commTimeOut;
    
    klaar=0;
    while klaar==0
        %! original code was: draw calibration point
        %! iViewX('drawcalibrationpoint', ivx, [ivx.absCalPos(pt,1), expt.visstimscreenrect(2)+ivx.absCalPos(pt,2)]);
        
        nPointsShown=nPointsShown+1;
        nextPt=0;
        %     After displaying the first point, the software must monitor
        %     the serial port for further ÒET_CHGÓ commands or  ÒET_BRKÓ,
        %     which cancels the calibration procedure.
        % we also detect manual acceptance of calibration point
        if allowManAccept && pt==1
            fprintf('Press spacebar when child is fixating first point...\n');
        end
        while nextPt==0
            fprintf('displaying calibration target at location %d\n',pt)
            [jtgt,jframe]=DisplayCalTargetFrame(ivx.absCalPos(pt,1), ivx.absCalPos(pt,2),expt,jtgt,jframe);
        
            if GetSecs>tBreak
                fprintf([mfilename ': timed out waiting for data.\n']);
                result=-1;
                iViewX('erasescreen', ivx);
                return
            end
            [keyIsDown,secs,keyCode] = KbCheck;
            if 1==keyCode(ivx.modifierKey) & 1==keyCode(ivx.breakKey)
                % stop program altogether
                result=-1;
                iViewX('break', ivx);
                fprintf('aborting calibration routine\n')
                iViewX('erasescreen', ivx);
                return;
            end
            if keyCode(ivx.breakKey), % stop calibration
                result=-1;
                iViewX('break', ivx);
                fprintf('break key detected\n')
                iViewX('erasescreen', ivx);
                return;
            end
            if keyCode(ivx.nextCalPointKey), % force next calibration point
                iViewX('accept', ivx);
                nextPt=1;
            end
            
            % If you want the subject to manually accept the point with a
            % key press once they fixate, the ÒET_ACCÓ  command must then
            % be sent to the serial port.  This instructs iView to change
            % to the next calibration point  rather than having it detect
            % fixations itself.
            if keyIsDown==0
                allowManAccept=1; % we only accept manually if key has been released in between
            end
            
            %            if ( displaykeycode(ivx.calAcceptKey) || keyCode(ivx.calAcceptKey)) && allowManAccept==1, % manually accept calibration point
            if ( keyCode(ivx.calAcceptKey)) && allowManAccept==1, % manually accept calibration point
                iViewX('accept', ivx);
                allowManAccept=0;
                displaykeycode(ivx.calAcceptKey)=0;
                fprintf('...Manually accepting first calibration point\n')
            end
            
            [data, ivx]=iViewX('receivedata', ivx);
            
            
            if ~isempty(data) & data ~=-1
                data
                
               
                if strfind(data, 'ET_CHG')
                    pt=str2num(data(8:end));
                    fprintf('Change to point: %d\n', pt);
                    % this signals the point was fixated correctly so we can
                    % go the next point
                    nextPt=1;
                    break;
                elseif strfind(data, 'ET_BRK')
                    fprintf('Eyetracker sent break signal; aborting calirbation')
                    result=-1;
                    return
                elseif strfind(data, 'ET_FIN')
                    %                     fprintf('Point: %d (pos %d) finished.\n', nPointsShown, pt);
                    
                    result=1;
                    klaar=1;
                    fprintf('Calibration Finished\n');
                    break
                end
            end
        end
    end
    
    [success, ivx]=iViewX('stoprecording', ivx); % ?? necessary
    
    iViewX('erasescreen', ivx);
    
    fprintf('\nEnd of calibration.\n');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % end of Frans Cornelissen's iViewX code
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Save the data that was recorded
    sendstr = ['ET_SAV ' strrep(filename,'.mat','.idf')]
    IVXsend(sendstr,ivx);
    data = IVXreceive(ivx)
    
    if result==1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % The calibration completed at least - let's have a look.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%
        % Read output of calibration
        %%%%%%%%%%%%%%%%%%%%%%%
        % First specify format:
        sendstr = 'ET_FRM "%TS: %SX, %S"'
        IVXsend(sendstr,ivx)
        data = IVXreceive(ivx)
        sendstr = 'ET_RES';
        IVXsend(sendstr,ivx)
        data = IVXreceive(ivx)
        clear calibresult
        while ~isempty(data);
            data
            % Read off first 6 cahracters to see what sorrt of infor we have
            cmd = data(1:6)
            data = data(8:end);
            if  strcmp(cmd,'ET_PNT')  && ~isempty(data)
                % This is followed by the index and position of the calibration
                % point:
                tmp=textscan(data,'%f%f%f');
                pt = tmp{1};
                calibresult.pos(pt).pointx = tmp{2};
                calibresult.pos(pt).pointy = tmp{3};
                jtime=0;
            elseif strcmp(cmd,'ET_CSP') && ~isempty(data)
                jtime=jtime+1;
                tmp=textscan(data,'%f%f%f%f%f');
                calibresult.pos(pt).timeinms(jtime) = tmp{1};
                calibresult.pos(pt).xL(jtime) = tmp{2};
                calibresult.pos(pt).yL(jtime) = tmp{3};
                calibresult.pos(pt).xR(jtime) = tmp{4};
                calibresult.pos(pt).yR(jtime) = tmp{5};
            elseif strcmp(cmd,'ET_RES')
                'successfully read back information about eye gaze during calibration'
            elseif strcmp(cmd,'ET_VLS') && ~isempty(data)
                % THis is an estiamte of calibration accuracy
                % See p. 470 of RED manual
                tmp=textscan(data,'%s%f%f%f%f%f');
                eye = tmp{1};eye=eye{:};
                calibresult.(eye).RMSxdev = tmp{2};
                calibresult.(eye).RMSydev = tmp{3};
                calibresult.(eye).RMSdevdist = tmp{4};
                calibresult.(eye).meanxdev = tmp{5};
                calibresult.(eye).meanydev = tmp{6};
                
            end
            % See if there is another line of data:
            data=IVXreceive(ivx);
            
        end % Finsihed reading output
        save(filename,'calibresult','expt','ivx')
        
        if exist('calibresult') && isstruct(calibresult)
            % See if we have an estimate of quality:
            if isfield(calibresult,'left') && isfield(calibresult.left,'RMSxdev')
                if calibresult.left.RMSxdev<10 % alter to adjust quality
                    result = 1.1;
                else
                    result = 1.3;
                end
            end
            if isfield(calibresult,'right') && isfield(calibresult.right,'RMSxdev')
                if calibresult.right.RMSxdev<10 % alter to adjust quality
                    result = 1.1;
                else
                    result = 1.3;
                end
            end
            
            save(filename,'calibresult','expt','ivx')
            
            
            % Draw output
            figure(ivx.fig)
            hold off
            calibcols = {'r' 'g' 'c' 'b' 'm' 'y' 'r' 'g' 'c' 'b' 'y' 'r' 'g' 'c' 'b' 'y' };
            for pt=1:length(calibresult.pos)
                % Mark location of calibration target:
                plot(calibresult.pos(pt).pointx,calibresult.pos(pt).pointy,'o','markerfacecol','k','markersize',12,'markeredgecol',calibcols{pt},'linew',3)
                hold on
                % Show recorded gaze positions
                plot(0.5*(calibresult.pos(pt).xL+calibresult.pos(pt).xR),0.5*(calibresult.pos(pt).yL+calibresult.pos(pt).yR),'.-','col',calibcols{pt})
                drawnow
            end
            set(gca,'ydir','rev')
            axis equal
            xlim([0 expt.visstimxsize])
            ylim([0 expt.visstimysize])
            title('Results of this calibration')
            drawnow
            % Save this file to a jpg:
            jpgname = strrep(filename,'.mat','');
            print(ivx.fig,jpgname,'-djpeg')
            
        end
        
    end % checkign whether calibration was successful
    
    Screen('FillRect',expt.PTBwin,expt.blankcol);
    Screen('Flip', expt.PTBwin);
    
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    
    Screen('CloseAll');
    rethrow(lasterror);
end %try..catch..


