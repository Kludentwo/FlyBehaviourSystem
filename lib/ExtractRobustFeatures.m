function [ RobustFeatures ] = ExtractRobustFeatures( StepSizeFeatures, LikelihoodFeatures, WindowSize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Chosen Features = [ 9 3 11 13 ]
stimTSIRZArray = [];
stimLBRZArray = [];
stimCntr = 1;
nostimTSIRZArray = [];
nostimLBRZArray = [];
nostimCntr = 1;
size_t = (size(LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray,2));
for k = 1:size_t
    if(StepSizeFeatures.RawData.TrueStateArray(k))
        stimTSIRZArray{stimCntr} = LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray{k};
        stimLBRZArray{stimCntr} = LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent{k};
        stimCntr = stimCntr + 1;
    else
        nostimTSIRZArray{nostimCntr} = LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray{k};
        nostimLBRZArray{nostimCntr} = LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent{k};
        nostimCntr = nostimCntr + 1;
    end
end
SuccessArray = [];
LBRZArray = [];
ATSIRZArray = [];
if((size(stimTSIRZArray,2)) < WindowSize )
    Window = size(stimTSIRZArray,2);
else
    Window = WindowSize;
end
for m = 1:(size(stimTSIRZArray,2) - Window + 1);
    ATSIRZArraybuf = [];
    LBRZArraybuf = [];
    for b = m:m+Window-1
        ATSIRZArraybuf = [ ATSIRZArraybuf stimTSIRZArray{m} ];
        LBRZArraybuf = [LBRZArraybuf stimLBRZArray{m} ];
    end
    try
        ATSIRZArray = [ ATSIRZArray mean(ATSIRZArraybuf)];
        LBRZArray = [ LBRZArray mean(LBRZArraybuf)];
        SuccessArray = [ SuccessArray m ];
    catch ME
    end
end
RobustFeatures.AverageTSIRZArray = ATSIRZArray;
RobustFeatures.LBRZ = LBRZArray;
RobustFeatures.trueStateArray = ones(1,size(SuccessArray,2));
SuccessArray = [];
LBRZArray = [];
ATSIRZArray = [];
if((size(nostimTSIRZArray,2)) < WindowSize )
    Window = size(nostimTSIRZArray,2);
else
    Window = WindowSize;
end
for m = 1:(size(nostimTSIRZArray,2) - Window + 1);
    ATSIRZArraybuf = [];
    LBRZArraybuf = [];
    for b = m:m+Window-1
        ATSIRZArraybuf = [ ATSIRZArraybuf nostimTSIRZArray{m} ];
        LBRZArraybuf = [LBRZArraybuf nostimLBRZArray{m} ];
    end
    try
        ATSIRZArray = [ ATSIRZArray mean(ATSIRZArraybuf)];
        LBRZArray = [ LBRZArray mean(LBRZArraybuf)];
        SuccessArray = [ SuccessArray m ];
    catch ME
    end
end
RobustFeatures.AverageTSIRZArray = [RobustFeatures.AverageTSIRZArray ATSIRZArray];
RobustFeatures.LBRZ = [ RobustFeatures.LBRZ LBRZArray];
RobustFeatures.trueStateArray = [RobustFeatures.trueStateArray 2*ones(1,size(SuccessArray,2))];
end


