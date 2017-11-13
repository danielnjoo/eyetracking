function SMI_incrementTrial_SG(udp,host,hport)

    % Increments trialnumber
    commandstring = sprintf('ET_INC\n');
    pnet(udp,'write',commandstring);    % Put into write buffer
    pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet
    
    commandstring = sprintf('ET_REM %s\n','"IncrementTrial"');
    pnet(udp,'write',commandstring);    % Put into write buffer
    pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet