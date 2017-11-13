function IVXsend(sendstr,ivx)
% Send string 'sendstr' to the eyetracker, over the connection specified in ivx
pnet(ivx.udp,'write',[sendstr char(10)]);pnet(ivx.udp,'writepacket',ivx.host,ivx.port);