function result = IVXTestCalibration(expt);
% Put up a couple of targets and see if the eye position is as expected
result=0;

% Define where to put up test targets
th = rand(1)*360;
%th = [th th+180]; % two points diametrically opposed
rad = expt.ny/4;
testx  = expt.nx/2 + rad .* sind(th);
testy  = expt.ny/2 + rad .* cosd(th);
testtime = 1; % seconds to display cal target for

cols = {'r' 'b' 'm' 'g' };

% File to store calibration data to:
filename = strrep(strrep(['IVXCalTest_' expt.subject '_' expt.timestamp '.mat'],' ','_'),':','-');
filename=[expt.datadir filesep filename];

ivx=expt.ivx;

% Put up gray background to rouhgly match luminance with real stimuli
Screen('FillRect',expt.PTBwin,127);
Screen('Flip', expt.PTBwin);

% Get ready:
ivx=IVXPrepareForExpt(ivx);


figure(expt.ivx.fig)
hold off
for j=1:length(testx)
    % Start streaming data from eye-tracker
    IVXsend('ET_STR',ivx);
    data=IVXreceive(ivx);

    % Display cal target:
    aborted=DisplayCalTarget(testx(j), testy(j),testtime,expt);
    
    % Stop streaming data from eye-tracker
    IVXsend('ET_EST',expt.ivx);
    
    % See what the eye movement data look like    
    REDdata='anything';
    jtime=0;
    while ~isempty(REDdata)
        REDdata = IVXreceive(expt.ivx);
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
                    testpoint(j).x(jtime) = tmp{2};
                    testpoint(j).y(jtime) = tmp{3};
                else
                    % we seem to have bincoular data
                    testpoint(j).xL(jtime) = tmp{2};
                    testpoint(j).xR(jtime) = tmp{3};
                    testpoint(j).yL(jtime) = tmp{4};
                    testpoint(j).yR(jtime) = tmp{5};
                end
            end
        end
    end % have now read all data forthcoming from eyetracker
    if (~isfield(testpoint(j),'x') || isempty(testpoint(j).x)) && (isfield(testpoint(j),'xL') || ~isempty(isfield(testpoint(j).xL)))
        testpoint(j).x = (testpoint(j).xL + testpoint(j).xR)/2;
        testpoint(j).y = (testpoint(j).yL + testpoint(j).yR)/2;
    end
    figure(expt.ivx.fig)
    plot(testx(j), testy(j),'o','markerfacecol','k','markersize',12,'markeredgecol',cols{j},'linew',3)
    hold on
    if isfield(testpoint(j),'x') && ~isempty(testpoint(j).x)
        plot(testpoint(j).x,testpoint(j).y,'.-','col',cols{j})
        
        % Find the error
        sqerr  = (testpoint(j).x-testx(j)).^2 + (testpoint(j).y-testy(j)).^2;
        testpoint(j).RMSerror_inpix = sqrt(mean(sqerr));        
        
    end
    set(gca,'position',[0 0 1 1],'ydir','rev','color',[1 1 1]*0.5)
    xlim([1 ivx.nx])
    ylim([1 ivx.ny])
    axis off
end
drawnow
if isfield(testpoint,'RMSerror_inpix') && length([testpoint.RMSerror_inpix])==length(testx)
    
    fprintf('Tested calibration. RMS error for each point was %f\n',   [testpoint.RMSerror_inpix])
    
    ndata = 0;
    nrubbish = 0;
    for jj=1:length(testpoint)
        ndata = ndata + length(testpoint(j).x);
        nrubbish = nrubbish + sum(testpoint(j).x==0 & testpoint(j).y==0);
    end
    fprintf('%d / %d eye position measures were (0,0) i.e. meaningless.\n',nrubbish,ndata);
    
    % May want to change this. At the mometn I am saying things look OK if
    % the maximum RMSerror < 100 pix (this depends on child too though) and
    % if at least half the data recorded is meaningful 
    if max([testpoint.RMSerror_inpix])<100 && nrubbish/ndata<0.5
        result=1.1; % test looks OK!
    else
        result=1.3; % test looks a bit rubbish
    end
else
    result = 3; % failed to get RED data for some reason
end
   
save(filename)

% Put up default background
Screen('FillRect',expt.PTBwin,expt.blankcol);
Screen('Flip', expt.PTBwin);