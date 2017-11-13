function ivx=IVXOpenup(ivx)
% Close any existing connections:
pnet('closeall');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open connection:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ivx.udp=pnet('udpsocket',ivx.localport);
pnet(ivx.udp,'setreadtimeout',ivx.udpreadtimeout);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ping IviewX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sendstr = 'ET_PNG';
pnet(ivx.udp,'write',[sendstr char(10)]);pnet(ivx.udp,'writepacket',ivx.host,ivx.port);
len=pnet(ivx.udp,'readpacket'); data=pnet(ivx.udp,'read',ivx.udpmaxread)
if ~strncmp(data,sendstr,6)
    'cannot establish contact with iViewX!'
    ivx.connected=0;
    return
else 
    ivx.connected=1;
end
