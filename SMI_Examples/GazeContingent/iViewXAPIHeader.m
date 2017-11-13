function [methodinfo,structs,enuminfo,ThunkLibName]=iViewXAPIHeader
%IVIEWXAPIHEADER Create structures to define interfaces found in 'iViewXAPI'.

%This function was generated by loadlibrary.m parser version 1.1.6.36 on Thu Jun  4 14:38:14 2015
%perl options:'iViewXAPI.i -outfile=iViewXAPIHeader.m'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival);
ThunkLibName=[];
% extern " C " int iV_AbortCalibration (); 
fcns.name{fcnNum}='iV_AbortCalibration'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_AbortCalibrationPoint (); 
fcns.name{fcnNum}='iV_AbortCalibrationPoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_AcceptCalibrationPoint (); 
fcns.name{fcnNum}='iV_AcceptCalibrationPoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_Calibrate (); 
fcns.name{fcnNum}='iV_Calibrate'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ChangeCalibrationPoint ( int number , int positionX , int positionY ); 
fcns.name{fcnNum}='iV_ChangeCalibrationPoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'int32', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_ClearAOI (); 
fcns.name{fcnNum}='iV_ClearAOI'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ClearRecordingBuffer (); 
fcns.name{fcnNum}='iV_ClearRecordingBuffer'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ConfigureFilter ( enum FilterType filter , enum FilterAction action , void * data ); 
fcns.name{fcnNum}='iV_ConfigureFilter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FilterType', 'FilterAction', 'voidPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_Connect ( char * sendIPAddress , int sendPort , char * recvIPAddress , int receivePort ); 
fcns.name{fcnNum}='iV_Connect'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring', 'int32', 'cstring', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_ConnectLocal (); 
fcns.name{fcnNum}='iV_ConnectLocal'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ContinueEyetracking (); 
fcns.name{fcnNum}='iV_ContinueEyetracking'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ContinueRecording ( char * etMessage ); 
fcns.name{fcnNum}='iV_ContinueRecording'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_DefineAOI ( struct AOIStruct * aoiData ); 
fcns.name{fcnNum}='iV_DefineAOI'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'AOIStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_DefineAOIPort ( int port ); 
fcns.name{fcnNum}='iV_DefineAOIPort'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_DeleteREDGeometry ( char * setupName ); 
fcns.name{fcnNum}='iV_DeleteREDGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_DisableAOI ( char * aoiName ); 
fcns.name{fcnNum}='iV_DisableAOI'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_DisableAOIGroup ( char * aoiGroup ); 
fcns.name{fcnNum}='iV_DisableAOIGroup'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_DisableGazeDataFilter (); 
fcns.name{fcnNum}='iV_DisableGazeDataFilter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_DisableProcessorHighPerformanceMode (); 
fcns.name{fcnNum}='iV_DisableProcessorHighPerformanceMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_Disconnect (); 
fcns.name{fcnNum}='iV_Disconnect'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_EnableAOI ( char * aoiName ); 
fcns.name{fcnNum}='iV_EnableAOI'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_EnableAOIGroup ( char * aoiGroup ); 
fcns.name{fcnNum}='iV_EnableAOIGroup'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_EnableGazeDataFilter (); 
fcns.name{fcnNum}='iV_EnableGazeDataFilter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_EnableProcessorHighPerformanceMode (); 
fcns.name{fcnNum}='iV_EnableProcessorHighPerformanceMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_GetAccuracy ( struct AccuracyStruct * accuracyData , int visualization ); 
fcns.name{fcnNum}='iV_GetAccuracy'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'AccuracyStructPtr', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_GetAccuracyImage ( struct ImageStruct * imageData ); 
fcns.name{fcnNum}='iV_GetAccuracyImage'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ImageStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetAOIOutputValue ( int * aoiOutputValue ); 
fcns.name{fcnNum}='iV_GetAOIOutputValue'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetAvailableLptPorts ( char * buffer , int * bufferSize ); 
fcns.name{fcnNum}='iV_GetAvailableLptPorts'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring', 'int32Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCalibrationParameter ( struct CalibrationStruct * calibrationData ); 
fcns.name{fcnNum}='iV_GetCalibrationParameter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'CalibrationStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCalibrationPoint ( int calibrationPointNumber , struct CalibrationPointStruct * calibrationPoint ); 
fcns.name{fcnNum}='iV_GetCalibrationPoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'CalibrationPointStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCalibrationQuality ( int calibrationPointNumber , struct CalibrationPointQualityStruct * left , struct CalibrationPointQualityStruct * right ); 
fcns.name{fcnNum}='iV_GetCalibrationQuality'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'CalibrationPointQualityStructPtr', 'CalibrationPointQualityStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCalibrationQualityImage ( struct ImageStruct * imageData ); 
fcns.name{fcnNum}='iV_GetCalibrationQualityImage'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ImageStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCalibrationStatus ( enum CalibrationStatusEnum * calibrationStatus ); 
fcns.name{fcnNum}='iV_GetCalibrationStatus'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'CalibrationStatusEnumPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCurrentCalibrationPoint ( struct CalibrationPointStruct * currentCalibrationPoint ); 
fcns.name{fcnNum}='iV_GetCurrentCalibrationPoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'CalibrationPointStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCurrentREDGeometry ( struct REDGeometryStruct * redGeometry ); 
fcns.name{fcnNum}='iV_GetCurrentREDGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'REDGeometryStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetCurrentTimestamp ( long long * currentTimestamp ); 
fcns.name{fcnNum}='iV_GetCurrentTimestamp'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int64Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetDeviceName ( char deviceName [ 64 ]); 
fcns.name{fcnNum}='iV_GetDeviceName'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int8Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetEvent ( struct EventStruct * eventDataSample ); 
fcns.name{fcnNum}='iV_GetEvent'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'EventStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetEvent32 ( struct EventStruct32 * eventDataSample ); 
fcns.name{fcnNum}='iV_GetEvent32'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'EventStruct32Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetEyeImage ( struct ImageStruct * imageData ); 
fcns.name{fcnNum}='iV_GetEyeImage'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ImageStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetFeatureKey ( long long * featureKey ); 
fcns.name{fcnNum}='iV_GetFeatureKey'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int64Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetGazeChannelQuality ( struct GazeChannelQualityStruct * qualityData ); 
fcns.name{fcnNum}='iV_GetGazeChannelQuality'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'GazeChannelQualityStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetGeometryProfiles ( int maxSize , char * profileNames ); 
fcns.name{fcnNum}='iV_GetGeometryProfiles'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_GetLicenseDueDate ( struct DateStruct * licenseDueDate ); 
fcns.name{fcnNum}='iV_GetLicenseDueDate'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'DateStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetREDGeometry ( char * profileName , struct REDGeometryStruct * redGeometry ); 
fcns.name{fcnNum}='iV_GetREDGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring', 'REDGeometryStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSample ( struct SampleStruct * rawDataSample ); 
fcns.name{fcnNum}='iV_GetSample'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'SampleStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSample32 ( struct SampleStruct32 * rawDataSample ); 
fcns.name{fcnNum}='iV_GetSample32'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'SampleStruct32Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSceneVideo ( struct ImageStruct * imageData ); 
fcns.name{fcnNum}='iV_GetSceneVideo'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ImageStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSerialNumber ( char serialNumber [ 64 ]); 
fcns.name{fcnNum}='iV_GetSerialNumber'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int8Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSpeedModes ( struct SpeedModeStruct * speedModes ); 
fcns.name{fcnNum}='iV_GetSpeedModes'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'SpeedModeStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetSystemInfo ( struct SystemInfoStruct * systemInfoData ); 
fcns.name{fcnNum}='iV_GetSystemInfo'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'SystemInfoStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetTrackingMonitor ( struct ImageStruct * imageData ); 
fcns.name{fcnNum}='iV_GetTrackingMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ImageStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetTrackingStatus ( struct TrackingStatusStruct * trackingStatus ); 
fcns.name{fcnNum}='iV_GetTrackingStatus'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'TrackingStatusStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetUseCalibrationKeys ( int * enableKeys ); 
fcns.name{fcnNum}='iV_GetUseCalibrationKeys'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_HideAccuracyMonitor (); 
fcns.name{fcnNum}='iV_HideAccuracyMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_HideEyeImageMonitor (); 
fcns.name{fcnNum}='iV_HideEyeImageMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_HideSceneVideoMonitor (); 
fcns.name{fcnNum}='iV_HideSceneVideoMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_HideTrackingMonitor (); 
fcns.name{fcnNum}='iV_HideTrackingMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_IsConnected (); 
fcns.name{fcnNum}='iV_IsConnected'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_LoadCalibration ( char * name ); 
fcns.name{fcnNum}='iV_LoadCalibration'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_Log ( char * logMessage ); 
fcns.name{fcnNum}='iV_Log'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_PauseEyetracking (); 
fcns.name{fcnNum}='iV_PauseEyetracking'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_PauseRecording (); 
fcns.name{fcnNum}='iV_PauseRecording'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_Quit (); 
fcns.name{fcnNum}='iV_Quit'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_RecalibrateOnePoint ( int number ); 
fcns.name{fcnNum}='iV_RecalibrateOnePoint'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_ReleaseAOIPort (); 
fcns.name{fcnNum}='iV_ReleaseAOIPort'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_RemoveAOI ( char * aoiName ); 
fcns.name{fcnNum}='iV_RemoveAOI'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_ResetCalibrationPoints (); 
fcns.name{fcnNum}='iV_ResetCalibrationPoints'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_SaveCalibration ( char * name ); 
fcns.name{fcnNum}='iV_SaveCalibration'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_SaveData ( char * filename , char * description , char * user , int overwrite ); 
fcns.name{fcnNum}='iV_SaveData'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring', 'cstring', 'cstring', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_SelectREDGeometry ( char * profileName ); 
fcns.name{fcnNum}='iV_SelectREDGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_SendCommand ( char * etMessage ); 
fcns.name{fcnNum}='iV_SendCommand'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_SendImageMessage ( char * etMessage ); 
fcns.name{fcnNum}='iV_SendImageMessage'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetAOIHitCallback ( pDLLSetAOIHit pAOIHitCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetAOIHitCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetCalibrationCallback ( pDLLSetCalibrationPoint pCalibrationCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetCalibrationCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% extern " C " int iV_SetConnectionTimeout ( int time ); 
fcns.name{fcnNum}='iV_SetConnectionTimeout'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetEventCallback ( pDLLSetEvent pEventCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetEventCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% extern " C " int iV_SetEventDetectionParameter ( int minDuration , int maxDispersion ); 
fcns.name{fcnNum}='iV_SetEventDetectionParameter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'int32'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetEyeImageCallback ( pDLLSetEyeImage pEyeImageCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetEyeImageCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% extern " C " int iV_SetLicense ( const char * licenseKey ); 
fcns.name{fcnNum}='iV_SetLicense'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_SetLogger ( int logLevel , char * filename ); 
fcns.name{fcnNum}='iV_SetLogger'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_SetREDGeometry ( struct REDGeometryStruct * redGeometry ); 
fcns.name{fcnNum}='iV_SetREDGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'REDGeometryStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetResolution ( int stimulusWidth , int stimulusHeight ); 
fcns.name{fcnNum}='iV_SetResolution'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'int32'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetSampleCallback ( pDLLSetSample pSampleCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetSampleCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetSceneVideoCallback ( pDLLSetSceneVideo pSceneVideoCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetSceneVideoCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% extern " C " int iV_SetSpeedMode ( int speedMode ); 
fcns.name{fcnNum}='iV_SetSpeedMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;

% DEACTIVATED -> Callbacks are not possible with loadlibrary
% extern " C " int iV_SetTrackingMonitorCallback ( pDLLSetTrackingMonitor pTrackingMonitorCallbackFunction ); 
% fcns.name{fcnNum}='iV_SetTrackingMonitorCallback'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'FcnPtr'};fcnNum=fcnNum+1;

% extern " C " int iV_SetTrackingParameter ( int ET_PARAM_EYE , int ET_PARAM , int value ); 
fcns.name{fcnNum}='iV_SetTrackingParameter'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32', 'int32', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupCalibration ( struct CalibrationStruct * calibrationData ); 
fcns.name{fcnNum}='iV_SetupCalibration'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'CalibrationStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupDebugMode ( int enableDebugMode ); 
fcns.name{fcnNum}='iV_SetupDebugMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupLptRecording ( const char * portName , int enableRecording ); 
fcns.name{fcnNum}='iV_SetupLptRecording'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring', 'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_SetUseCalibrationKeys ( int enableKeys ); 
fcns.name{fcnNum}='iV_SetUseCalibrationKeys'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_ShowAccuracyMonitor (); 
fcns.name{fcnNum}='iV_ShowAccuracyMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ShowEyeImageMonitor (); 
fcns.name{fcnNum}='iV_ShowEyeImageMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ShowSceneVideoMonitor (); 
fcns.name{fcnNum}='iV_ShowSceneVideoMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_ShowTrackingMonitor (); 
fcns.name{fcnNum}='iV_ShowTrackingMonitor'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_Start ( enum ETApplication etApplication ); 
fcns.name{fcnNum}='iV_Start'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'ETApplication'};fcnNum=fcnNum+1;
% extern " C " int iV_StartRecording (); 
fcns.name{fcnNum}='iV_StartRecording'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_StopRecording (); 
fcns.name{fcnNum}='iV_StopRecording'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_TestTTL ( int value ); 
fcns.name{fcnNum}='iV_TestTTL'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int32'};fcnNum=fcnNum+1;
% extern " C " int iV_Validate (); 
fcns.name{fcnNum}='iV_Validate'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% extern " C " int iV_SetupMonitorAttachedGeometry ( struct MonitorAttachedGeometryStruct * monitorAttachedGeometry ); 
fcns.name{fcnNum}='iV_SetupMonitorAttachedGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupStandAloneMode ( struct StandAloneModeGeometryStruct * standAloneModeGeometry ); 
fcns.name{fcnNum}='iV_SetupStandAloneMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupREDMonitorAttachedGeometry ( struct REDMonitorAttachedGeometryStruct * attachedModeGeometry ); 
fcns.name{fcnNum}='iV_SetupREDMonitorAttachedGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'REDMonitorAttachedGeometryStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetupREDStandAloneMode ( struct REDStandAloneModeStruct * standAloneModeGeometry ); 
fcns.name{fcnNum}='iV_SetupREDStandAloneMode'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'REDStandAloneModeStructPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_GetMonitorAttachedGeometry ( char profileName [ 256 ], struct MonitorAttachedGeometryStruct * monitorAttachedGeometry ); 
fcns.name{fcnNum}='iV_GetMonitorAttachedGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int8Ptr', 'voidPtr'};fcnNum=fcnNum+1;
% extern " C " int iV_SetGeometryProfile ( char * profileName ); 
fcns.name{fcnNum}='iV_SetGeometryProfile'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'cstring'};fcnNum=fcnNum+1;
% extern " C " int iV_DeleteMonitorAttachedGeometry ( char setupName [ 256 ]); 
fcns.name{fcnNum}='iV_DeleteMonitorAttachedGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int8Ptr'};fcnNum=fcnNum+1;
% extern " C " int iV_DeleteStandAloneGeometry ( char setupName [ 256 ]); 
fcns.name{fcnNum}='iV_DeleteStandAloneGeometry'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'int8Ptr'};fcnNum=fcnNum+1;
structs.SystemInfoStruct.members=struct('samplerate', 'int32', 'iV_MajorVersion', 'int32', 'iV_MinorVersion', 'int32', 'iV_Buildnumber', 'int32', 'API_MajorVersion', 'int32', 'API_MinorVersion', 'int32', 'API_Buildnumber', 'int32', 'iV_ETDevice', 'ETDevice');
structs.SpeedModeStruct.members=struct('version', 'int32', 'speedMode', 'int32', 'numberOfSpeedModes', 'int32', 'speedModes', 'int32#16');
structs.CalibrationPointStruct.members=struct('number', 'int32', 'positionX', 'int32', 'positionY', 'int32');
structs.CalibrationPointQualityStruct.members=struct('number', 'int32', 'positionX', 'int32', 'positionY', 'int32', 'correctedPorX', 'double', 'correctedPorY', 'double', 'standardDeviationX', 'double', 'standardDeviationY', 'double', 'usageStatus', 'CalibrationPointUsageStatusEnum', 'qualityIndex', 'double');
structs.EyeDataStruct.members=struct('gazeX', 'double', 'gazeY', 'double', 'diam', 'double', 'eyePositionX', 'double', 'eyePositionY', 'double', 'eyePositionZ', 'double');
structs.SampleStruct.members=struct('timestamp', 'int64', 'leftEye', 'EyeDataStruct', 'rightEye', 'EyeDataStruct', 'planeNumber', 'int32');
structs.SampleStruct32.members=struct('timestamp', 'double', 'leftEye', 'EyeDataStruct', 'rightEye', 'EyeDataStruct', 'planeNumber', 'int32');
structs.EventStruct.members=struct('eventType', 'int8', 'eye', 'int8', 'startTime', 'int64', 'endTime', 'int64', 'duration', 'int64', 'positionX', 'double', 'positionY', 'double');
structs.EventStruct32.members=struct('startTime', 'double', 'endTime', 'double', 'duration', 'double', 'positionX', 'double', 'positionY', 'double', 'eventType', 'int8', 'eye', 'int8');
structs.EyePositionStruct.members=struct('validity', 'int32', 'relativePositionX', 'double', 'relativePositionY', 'double', 'relativePositionZ', 'double', 'positionRatingX', 'double', 'positionRatingY', 'double', 'positionRatingZ', 'double');
structs.TrackingStatusStruct.members=struct('timestamp', 'int64', 'leftEye', 'EyePositionStruct', 'rightEye', 'EyePositionStruct', 'total', 'EyePositionStruct');
structs.AccuracyStruct.members=struct('deviationLX', 'double', 'deviationLY', 'double', 'deviationRX', 'double', 'deviationRY', 'double');
structs.GazeChannelQualityStruct.members=struct('gazeChannelQualityLeft', 'double', 'gazeChannelQualityRight', 'double', 'gazeChannelQualityBinocular', 'double');
structs.CalibrationStruct.members=struct('method', 'uint32', 'visualization', 'int32', 'displayDevice', 'int32', 'speed', 'int32', 'autoAccept', 'int32', 'foregroundBrightness', 'int32', 'backgroundBrightness', 'int32', 'targetShape', 'int32', 'targetSize', 'int32', 'targetFilename', 'int8#256');
structs.REDGeometryStruct.members=struct('redGeometry', 'REDGeometryEnum', 'monitorSize', 'int32', 'setupName', 'int8#256', 'stimX', 'int32', 'stimY', 'int32', 'stimHeightOverFloor', 'int32', 'redHeightOverFloor', 'int32', 'redStimDist', 'int32', 'redInclAngle', 'int32', 'redStimDistHeight', 'int32', 'redStimDistDepth', 'int32');
structs.ImageStruct.members=struct('imageHeight', 'int32', 'imageWidth', 'int32', 'imageSize', 'int32', 'imageBuffer', 'uint8Ptr');
structs.DateStruct.members=struct('day', 'int32', 'month', 'int32', 'year', 'int32');
structs.AOIRectangleStruct.members=struct('x1', 'int32', 'x2', 'int32', 'y1', 'int32', 'y2', 'int32');
structs.AOIStruct.members=struct('enabled', 'int32', 'aoiName', 'int8#256', 'aoiGroup', 'int8#256', 'position', 'AOIRectangleStruct', 'fixationHit', 'int32', 'outputValue', 'int32', 'outputMessage', 'int8#256', 'eye', 'int8');
structs.REDStandAloneModeStruct.members=struct('stimX', 'int32', 'stimY', 'int32', 'stimHeightOverFloor', 'int32', 'redHeightOverFloor', 'int32', 'redStimDist', 'int32', 'redInclAngle', 'int32');
structs.REDMonitorAttachedGeometryStruct.members=struct('stimX', 'int32', 'stimY', 'int32', 'redStimDistHeight', 'int32', 'redStimDistDepth', 'int32', 'redInclAngle', 'int32');
enuminfo.CalibrationPointUsageStatusEnum=struct('calibrationPointUsed',0,'calibrationPointUnused',1,'calibrationPointUnusedBecauseOfTimeout',2,'calibrationPointUnusedBecauseOfBadQuality',3,'calibrationPointIgnored',4);
enuminfo.ETDevice=struct('NONE',0,'RED',1,'REDm',2,'HiSpeed',3,'MRI',4,'HED',5,'Custom',7,'REDn',8);
enuminfo.FilterAction=struct('Query',0,'Set',1);
enuminfo.ETApplication=struct('iViewX',0,'iViewXOEM',1,'iViewNG',2);
enuminfo.FilterType=struct('Average',0);
enuminfo.REDGeometryEnum=struct('monitorIntegrated',0,'standalone',1);
enuminfo.CalibrationStatusEnum=struct('calibrationUnknown',0,'calibrationInvalid',1,'calibrationValid',2,'calibrationInProgress',3);
methodinfo=fcns;