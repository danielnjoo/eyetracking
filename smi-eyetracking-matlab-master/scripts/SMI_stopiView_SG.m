function SMI_stopiView_SG(iView_outdir,udp,host,hport)

%Stop Recoding
commandstring = sprintf('ET_STP\n');
pnet(udp,'write',commandstring);    % Put into write buffer
pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet

% Save data
commandstring = sprintf('ET_SAV %s\n',iView_outdir);
pnet(udp,'write',commandstring);    % Put into write buffer
pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet

% Clear internal buffer
commandstring = sprintf('ET_CLR\n');
pnet(udp,'write',commandstring);    % Put into write buffer
pnet(udp,'writepacket',host,hport); % Send buffer as UDP packet