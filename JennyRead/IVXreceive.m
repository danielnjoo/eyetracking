function data = IVXreceive(ivx)
% Read data in from the eyetracker, over the connection specified in ivx
len=pnet(ivx.udp,'readpacket'); 
data=pnet(ivx.udp,'read',ivx.udpmaxread);
% For some god-only-knows reason, I have found that, when sending back ET_VLS, the RED
% sends back a space which is ASCII character 26 instead of 32. This terminates the string
% and screws up my code. I will therefore replace ASCII 26 with 32:
jj = find(double(data)<32 | double(data)>127);
data(jj)=32;