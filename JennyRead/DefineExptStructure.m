function expt = DefineExptStructure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Very important function which defines the default expt structure. The actual expt strucutre passed to the
% actual stimulus code is first updated with the current settings of the
% GUI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hard-wired parameters:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expt.screenID = 2;
expt.datadir = 'data';
expt.blankcol = 0; % what colour to display in between trials
expt.timetoleaveupafteranswer = 1; % how many seconds to leave the stimulus up after child has answered
expt.intertrialinterval = 2.5; % how many seconds to wait in before the next trial
expt.timestamp = strrep(strrep(datestr(now,30),' ','_'),':','-');
expt.repeatcueeveryNsecs = 3; % Repeat the cue every so often, in case child has forgotten, lost motivation or whatever. Set this to infinity for no repeats.
% Meaning of standard keys:
KbName('UnifyKeyNames');
expt.key_abort = KbName('Escape');
expt.key_repeatcue = KbName('f8'); % for the experimenter to have the computer repeat the cue
expt.key_touchpad = KbName('f9'); % for the experimenter to move on to the next trial - currently disabled
expt.key_yesbutton = KbName('f3'); % for the child to answer "yes" or "target present"
expt.key_nobutton = KbName('f5'); % for the child to answer "no" or "target not present"
expt.key_headrest = KbName('f7'); % senses whether child's head is back on the headrest

expt.Version = mfilename('fullpath');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[expt.nx,expt.ny]=Screen('WindowSize',expt.screenID);
% In this version of the code, we do not necessarily use the whole area of
% the screen for the visual stimuli. Rather, they are restricted to teh
% bottom half of the screen, where we can do eye tracking.
% Area of the screen used for visual stimuli:
expt.visstimxsize = expt.nx;
expt.visstimysize = expt.ny/2;
% This puts the vis-stim area at the bottom of the screen, in the miidle:
left = (expt.nx-expt.visstimxsize)/2;
right = expt.nx - left;
top = expt.ny-expt.visstimysize;
bot = expt.ny;
expt.visstimscreenrect = [left top right bot];
% Area of the screen not used for stimuli:
expt.unusedscreenrect = [0 0 expt.nx expt.ny-expt.visstimysize];
% Area of the screen counted as a "no" response if pressed:
expt.nobuttonrect = [ expt.nx/2-75 (expt.ny-expt.visstimysize)/2-75 expt.nx/2+75 (expt.ny-expt.visstimysize)/2+75];

% Positions of squares in main expt:

% Positions of squares in main expt:
nsquares = 3;
% sqside = sidelength in pixels
% I want the bg area to be the same as the fg.
% Thus I want nsquares * sqside^2 = visstimxsize*visstimysize - nsquares * sqside^2
% I.e.  sqside^2 = visstimxsize*visstimysize /2/nsquares
%expt.sqside = sqrt(expt.visstimxsize*expt.visstimysize /2/nsquares) ;
expt.sqside = 220;
expt.sqxcens = expt.visstimxsize/2 + [ -1.15 0 1.15]*expt.sqside*1.25;
expt.sqycens = expt.ny-expt.visstimysize/2 + [0 0 0]*expt.sqside*0.4;
%expt.sqxcens = [200 200 400 500 600];
%expt.sqycens = [100 300 250 100 300];
%nsquares = length(expt.sqxcens);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PTB windows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);

% Open a PTB Window if one is not already open:
win = Screen('Windows');
if length(win)==1
    expt.PTBwin = win;
elseif length(win)>1
    % Somehow we have opened too many windows: close the extra ones:
    Screen('Close',win(2:end));
    expt.PTBwin=win(1);
else
    % win was empty: we need to open a window again
    [expt.PTBwin,rect]=Screen('OpenWindow',expt.screenID , expt.blankcol );
end

Screen(expt.PTBwin,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in images to display in between trials, for boy & for girl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = ['..' filesep 'intertrialimage_girl.jpg'];
img=imread(file);
expt.intertrialtex_girl = Screen('MakeTexture',expt.PTBwin,img);
file = ['..' filesep 'intertrialimage_boy.jpg'];
img=imread(file);
expt.intertrialtex_boy = Screen('MakeTexture',expt.PTBwin,img);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in the sound files to use during calibration:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
directory = '../calibrationtargets';
d=dir([directory filesep '*.wav']);
for j=1:length(d)
    expt.audfiles{j} = [directory filesep d(j).name];
end
d=dir([directory filesep 'hellos' filesep '*.wav']);
for j=1:length(d)
    expt.hellofiles{j} = [directory filesep 'hellos' filesep d(j).name];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select and read-in an animation to use as a calibration target (if
% eyetracking is on)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this version, the program assumes caltgt animtions are stored as
% animated gif of the format CalibTargetN.gif. matlab's imread does not appear to handle transparency, so to get round this, all pixels which are the
% same colour as the top-left pixel in the first frame (assumed to be
% background) will be replaced with transparency.
d=dir([directory filesep 'CalibTarget*.gif']);
for jim = 1:length(d)
    [img,map,alpha]=imread(sprintf('%s%s%s',directory,filesep,d(jim).name),'gif','frames','all');
    % See how many frames we have
    [n,m,tmp,nframes] = size(img);
    % Read colour of top-left pixel in the first frame :
    BGval = img(1);
    
    % Read in images and repalce white background with transparency:
    for jframe=1:nframes
        imgframe = ones(n,m,4)*255;
        for jn=1:n
            for jm=1:m
                val = img(jn,jm,1,jframe);
                imgframe(jn,jm,1:3) = map(val+1,:)*255;
                % Replace [255 255 255 255] with [255 255 255 0]
                if val==BGval
                    imgframe(jn,jm,4) = 0;
                end
            end
        end
        expt.caltgttex{jim}(jframe) = Screen('MakeTexture',expt.PTBwin,imgframe);
    end
end

expt.eyetracking=0; % by default eye-tracking is off.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read-in an animation to display as a "thank you!" after the
% child has touched the screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this version, the program assumes caltgt animtions are stored as
% animated gif of the format CalibTargetN.gif. matlab's imread does not appear to handle transparency, so to get round this, all pixels which are the
% same colour as the top-left pixel in the first frame (assumed to be
% background) will be replaced with transparency.
[img,map,alpha]=imread(sprintf('%s%s%s',directory,filesep,'OnTouch.gif'),'gif','frames','all');
% See how many frames we have
[n,m,tmp,nframes] = size(img);
% Read colour of top-left pixel in the first frame :
BGval = img(1);
% Read in images and repalce white background with transparency:
for jframe=1:nframes
    imgframe = ones(n,m,4)*255;
    for jn=1:n
        for jm=1:m
            val = img(jn,jm,1,jframe);
            imgframe(jn,jm,1:3) = map(val+1,:)*255;
            % Replace [255 255 255 255] with [255 255 255 0]
            if val==BGval
                imgframe(jn,jm,4) = 0;
            end
        end
    end
    expt.animtex(jframe) = Screen('MakeTexture',expt.PTBwin,imgframe);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See if there is an image available to use for "not present" response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = ['..' filesep 'notpresentimage.jpg'];
img=imread(file);
expt.notpresenttex = Screen('MakeTexture',expt.PTBwin,img);

% Handle sound:
InitializePsychSound;
% Assume freq and channels are the same in all .wav files as in
% thankyou.wav
[y, freq, nbits] = wavread(['..' filesep 'sounds' filesep 'thankyou.wav']);
expt.soundNchannels =  size(y',1);
expt.soundfreq = freq;
% Open the default audio device:
expt.soundhandle = PsychPortAudio('Open', [], [], 0, expt.soundfreq, expt.soundNchannels);


% Default (stops errors if testing with no subject)
expt.subject = 'test';
