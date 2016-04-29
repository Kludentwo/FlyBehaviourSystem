function [ StepSizeFeatures ] = ExtractStepSizeFeatures( Epochs, NumberOfEpochs, Validations, anglethreshold, jitterthreshold )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 5)
    jitterthreshold = 2;
end
if (nargin < 4)
    anglethreshold = 27;
end
ValidationCnt = 1;
DataCnt = 1;
StepSizeFeatures = struct;
StepSizeFeatures.RawData.StepSizeArrays = [];
StepSizeFeatures.RawData.TrueStateArray = [];
for m = 1:NumberOfEpochs
    [ dataContainer, Armed ] = GetDataFromEpoch( Epochs{m} );
    % dataContainer = [X; Y; Triggered; Timestamps; InResetZone; InTriggerZone; Bin];
    [ newvect, ivect ] = AngleBasedPathBuilder( dataContainer(1,:), dataContainer(2,:), anglethreshold, jitterthreshold);
    %SavePathBuiltAndFigures( datalist{itemindex}, [x; y] , newvect, ivect, anglethreshold, jitterthreshold, 2, 30 )
    
    StepSizeArray = CalcSteps(newvect(1,:),newvect(2,:));
    if(any(m == Validations))
        StepSizeFeatures.validation{ValidationCnt}.StepSizes = StepSizeArray;
        StepSizeFeatures.validation{ValidationCnt}.Armed = Armed;
        ValidationCnt = ValidationCnt + 1;
    else
        StepSizeFeatures.RawData.StepSizeArrays{DataCnt} = StepSizeArray(1,:);
        StepSizeFeatures.RawData.TrueStateArray(DataCnt) = Armed;
        DataCnt = DataCnt + 1;
    end
end
end

