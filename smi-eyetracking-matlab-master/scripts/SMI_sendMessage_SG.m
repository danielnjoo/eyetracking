function SMI_sendMessage_SG(message,udp,host,hport)

    commandstring = sprintf('ET_REM %s\n',message);
    pnet(udp,'write',commandstring);    % Put into write buffer
    pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet