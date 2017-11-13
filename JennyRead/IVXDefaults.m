function ivx = IVXDefaults(expt);
% Set up an IVX structure suitable for Frans Cornelissen's IVXToolbox
% here are Frans' defaults:
ivx=iViewXInitDefaults;
% and I'll overwrite some values with my own:
ivx.window = expt.PTBwin;
% Parameters for the connection:
ivx.host= '10.10.10.1';
ivx.port= 4444;
ivx.localport= 5555;


ivx.nx = expt.visstimxsize;
ivx.ny = expt.visstimysize;
% I need it to be called nx,ny for my subsequent code, but Frans needs it
% to be called screenH,VSize
ivx.screenHSize = ivx.nx;
ivx.screenVSize = ivx.ny;

ivx.nCalPoints = 9;

%  Put this in my own code...
ivx.calTimeOut = 4;