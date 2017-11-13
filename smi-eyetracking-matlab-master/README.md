smi-eyetracking-with-matlab
===========================

Run an SMI eye tracker from Matlab

Dependencies
-------------
- Matlab


Example code for setting up eyetracking
--------------------

```
subid = 'ap01'

numCalib = 9;   % number of calibration pts
ETfileName=[subid,'.idf'];
iView_outdir = ['"D:\MatlabFiles\Eyetracking&Matlab\SampleScript\Data\',ETfileName,'"'];

%% Eye tracker connection settings
hport = 4444;  % host port (iView)
cport = 5555;  % client port (Matlab)
host = '127.0.0.1';  % host address (if internal)

% UDP socket initialization
udp = pnet('udpsocket',cport);
```

Example code for starting/stopping eyetracking
--------------------

#### To start:
```
RuniView(udp,host,hport);
```

#### To stop:
```
SMI_stopiView_SG(iView_outdir,udp,host,hport);
```

Example code for incrementing the trial number
--------------------
```
SMI_incrementTrial_SG(udp,host,hport);
```

Example code for sending message to iView output
--------------------
```
message = 'indoor'
SMI_sendMessage_SG(message,udp,host,hport)
```
