function RuniView(udp,host,hport)
% This function starts iView recording data from SMI Hi-Speed eye tracker.
%
% The following functions are used, and should be downloaded;
%
% UDP connection, pnet():
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=345.
% -------------------------------------------------------------------------

% if the udp connection has been established appropriately, proceed with
% streaming data
if udp ~= -1
    disp('Make sure Eye-tracker is calibrated!');
    % Cancel a possible ongoing calibration
    %commandstring = sprintf('ET_BRK\n');
    %pnet(udp,'write',commandstring);    % Put into write buffer
    %pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet
    
    % Clear internal buffer
    %commandstring = sprintf('ET_CLR\n');
    %pnet(udp,'write',commandstring);    % Put into write buffer
    %pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet
    
    % Send command to set up acquisition format -- not really necessary
    % unless getting info from ET for Matlab
    % Get timestamp, gaze pos, pupil diameter
    commandstring = ['ET_FRM "%TS: %SX, %SY, %DX, %DY"' sprintf('\n')];
    pnet(udp,'write',commandstring);     % Write to write buffer
    pnet(udp,'writepacket',host,hport);  % Send buffer as UDP packet
    
    % Start Recording w/iView 
    commandstring = sprintf('ET_REC\n');
    pnet(udp,'write',commandstring);    % Put into write buffer
    pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet

    SMI_incrementTrial_SG(udp,host,hport);
else
    disp('Eye-tracker not connected!');
end
