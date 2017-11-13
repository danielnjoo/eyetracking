function ivx=IVXPrepareForExpt(ivx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ' Make sure we are not streaming data yet:'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IVXsend('ET_EST',ivx);
% See if we can read a response:
data = IVXreceive(ivx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read off any data outstanding from the eyetracker:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = IVXreceive(ivx);
while ~isempty(data)
    data = IVXreceive(ivx);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
' Ask for current sample rate'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IVXsend('ET_SRT',ivx);
data = IVXreceive(ivx);
% Write sample into ivx structure:
if length(data)>6
    srt = str2num(data(7:end));
    ivx.samplerate = srt;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify format of IVX data'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IVXsend('ET_FRM "%TS %SX %SY"',ivx);
data = IVXreceive(ivx);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'Set screen size'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sendstr = sprintf('ET_CSZ %d %d',ivx.nx,ivx.ny);
IVXsend(sendstr,ivx);
data = IVXreceive(ivx);
% Haven't figured out when this sends a response.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
' Make sure we are not streaming data yet:'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sendstr = 'ET_EST';
IVXsend(sendstr,ivx);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
' Clear buffer of eye movement recording data'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sendstr = 'ET_CLR'
IVXsend(sendstr,ivx);
data = IVXreceive(ivx)

