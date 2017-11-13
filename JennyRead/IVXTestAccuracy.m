function result = IVXTestAccuracy(expt);
% For use to test the accuracy of the eyetracking data reported by the
% RED50. Put up an image with a bunch of numbered targets, have the subject
% saccade from one to the other, and see how accurate it is.
result=0;

% File to store calibration data to:
filename = strrep(strrep(['IVXAccTest_' expt.subject '_' expt.timestamp '.mat'],' ','_'),':','-');
filename=[expt.datadir filesep filename];

ivx=expt.ivx;

% Define where to put up test targets
nx = 7;
ny = 3;
x = ([1:nx] - (nx+1)/2 ) /nx * ivx.nx + ivx.nx/2;
y = ([1:ny] - (ny+1)/2 ) /ny * ivx.ny + ivx.ny/2;
[x,y] = meshgrid(x,y);
x=x(:)';
y=y(:)';
% And finally correct so the targets appear in the IVX region of the
% screen:
testx = expt.visstimscreenrect(1) + x;
testy = expt.visstimscreenrect(2) + y;

mp = colormap(jet);
cols = mp(randperm(64),:);

% Get ready:
ivx=IVXPrepareForExpt(ivx);

figure(ivx.fig)
hold off
plot(testx, testy,'o','markeredgecol','k','markersize',12,'markerfacecol','k','linew',3)
hold on

for j=1:length(x)
    % Start streaming data from eye-tracker
    IVXsend('ET_STR',ivx);
    data=IVXreceive(ivx);

    % Indicate which object they are to look at
    DisplayTargetArray(expt.PTBwin,testx,testy,j);
    
    % Leave it up for a bit:
    WaitSecs(2)
    
    % Stop streaming data from eye-tracker
    IVXsend('ET_EST',ivx);
    
    % See what the eye movement data look like    
    REDdata='anything';
    jtime=0;
    while ~isempty(REDdata)
        REDdata = IVXreceive(ivx);
        % Still seem to have some :s and ,s for some reason:
        REDdata=strrep(strrep(REDdata,':',''),',','');
        if length(REDdata)>6
            cmd = REDdata(1:6);
            REDdata = REDdata(8:end);
            if  strcmp(cmd,'ET_SPL') && ~isempty(REDdata)
                jtime=jtime+1;
                tmp=textscan(REDdata,'%f%f%f%f%f');
                testpoint(j).REDtimeinms(jtime) = tmp{1};
                if isempty(tmp{4}) || isnan(tmp{4})
                    % presum,ably we have monoc data (or av of both)
                    testpoint(j).x_IVX_raw(jtime) = tmp{2};
                    testpoint(j).y_IVX_raw(jtime) = tmp{3};
                else
                    % we seem to have bincoular data
                    testpoint(j).xL_IVX_raw(jtime) = tmp{2};
                    testpoint(j).xR_IVX_raw(jtime) = tmp{3};
                    testpoint(j).yL_IVX_raw(jtime) = tmp{4};
                    testpoint(j).yR_IVX_raw(jtime) = tmp{5};
                end
            end
        end
    end % have now read all data forthcoming from eyetracker
    if (~isfield(testpoint(j),'x_IVX_raw') || isempty(testpoint(j).x_IVX_raw)) && (isfield(testpoint(j),'xL_IVX_raw') || ~isempty(isfield(testpoint(j).xL_IVX_raw)))
        testpoint(j).x_IVX_raw = (testpoint(j).xL_IVX_raw + testpoint(j).xR_IVX_raw)/2;
        testpoint(j).y_IVX_raw = (testpoint(j).yL_IVX_raw + testpoint(j).yR_IVX_raw)/2;
    end

    % Sometimes the eyetracker outputs (0,0) for reasons we don't
    % understand, presumably because it lost your gaze position for a
    % while. I am going to replace these with NaNs so they do not get
    % plotted
    testpoint(j).x_IVX_clean = testpoint(j).x_IVX_raw;
    testpoint(j).y_IVX_clean = testpoint(j).y_IVX_raw;
    jj = find( [testpoint(j).x_IVX_raw]==0 | [testpoint(j).y_IVX_raw]==0);
    testpoint(j).x_IVX_clean(jj) = NaN;
    testpoint(j).y_IVX_clean(jj) = NaN;
        
    % Convert from IVX to PTB screen coordinates
    testpoint(j).x_PTB = testpoint(j).x_IVX_clean + expt.visstimscreenrect(1);
    testpoint(j).y_PTB = testpoint(j).y_IVX_clean + expt.visstimscreenrect(2);
    % Make a note of target location in PTB coordinates:
    testpoint(j).tgtx_PTB = testx(j);
    testpoint(j).tgty_PTB = testy(j);
        
    
    % Add this eyetrack data to the figure:
    figure(ivx.fig)
    col = cols(j,:);
    plot(testx(j), testy(j),'o','markeredgecol','k','markersize',12,'markerfacecol',col,'linew',3)
    if isfield(testpoint(j),'x_PTB') && ~isempty(testpoint(j).x_PTB)
        plot(testpoint(j).x_PTB,testpoint(j).y_PTB,'.-','col',col) 
         plot(testpoint(j).x_PTB,testpoint(j).y_PTB,'w:') 
    end
    set(gca,'position',[0 0 1 1],'ydir','rev','color',[1 1 1]*0.5)
    xlim([1 expt.nx])
    ylim([1 expt.ny])
    axis equal  off
    drawnow
end
% Save the data:   
save(filename)
% Save this figure to a jpg:
jpgname = strrep(filename,'.mat','');
print(ivx.fig,jpgname,'-djpeg');

% Put up default background
Screen('FillRect',expt.PTBwin,expt.blankcol);
Screen('Flip', expt.PTBwin);


function DisplayTargetArray(win,x,y,jtgt)
Screen('FillRect',win,127);
Screen('DrawDots', win, [x;y] , 20 ,0, [], 1 );
Screen('TextSize',  win ,8);
for j=1:length(x)
    strg = num2str(j);
    if j == jtgt
        col = [255 0 0];
    else
        col = [255 255 255];
    end
    Screen('DrawText', win, strg ,x(j)-3*length(strg) ,y(j)-8 , col , 0  );
end
Screen('Flip', win);
