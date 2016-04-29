function [ ChosenFeatures ] = ExtractChosenFeatures( StepSizeFeatures, LikelihoodFeatures, WindowSize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Chosen Features = [ 9 3 11 13 ]
stimstepsizeArray = [];
stimTSIRZArray = [];
stimLBRZArray = [];
stimCntr = 1;

nostimstepsizeArray = [];
nostimTSIRZArray = [];
nostimLBRZArray = [];
nostimCntr = 1;
size_t = (size(StepSizeFeatures.RawData.StepSizeArrays,2));
for k = 1:size_t
    if(StepSizeFeatures.RawData.TrueStateArray(k))
        stimstepsizeArray{stimCntr} = StepSizeFeatures.RawData.StepSizeArrays{k};
        stimTSIRZArray{stimCntr} = LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray{k};
        stimLBRZArray{stimCntr} = LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent{k};
        stimCntr = stimCntr + 1;
    else
        nostimstepsizeArray{nostimCntr} = StepSizeFeatures.RawData.StepSizeArrays{k};
        nostimTSIRZArray{nostimCntr} = LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray{k};
        nostimLBRZArray{nostimCntr} = LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent{k};
        nostimCntr = nostimCntr + 1;
    end
end
alphaArray = [];
gamArray = [];
SuccessArray = [];
LBRZArray = [];
ATSIRZArray = [];
if((size(stimstepsizeArray,2)) < WindowSize )
    Window = size(stimstepsizeArray,2);
else
    Window = WindowSize;
end
for m = 1:(size(stimstepsizeArray,2) - Window + 1);
    stepsizebuf = [];
    TSIRZbuf = [];
    ATSIRZArraybuf = [];
    LBRZArraybuf = [];
    for b = m:m+Window-1
        stepsizebuf = [ stepsizebuf stimstepsizeArray{b}];
        TSIRZbuf = [ TSIRZbuf stimTSIRZArray{b} ];
        ATSIRZArraybuf = [ ATSIRZArraybuf stimTSIRZArray{m} ];
        LBRZArraybuf = [LBRZArraybuf stimLBRZArray{m} ];
    end
    try
        stepsizedist = fitdist(double(stepsizebuf)','stable');
        TSIRZdist = fitdist(double(TSIRZbuf)','stable');
        alphaArray = [ alphaArray stepsizedist.alpha ];
        gamArray = [ gamArray TSIRZdist.gam ];
        ATSIRZArray = [ ATSIRZArray mean(ATSIRZArraybuf)];
        LBRZArray = [ LBRZArray mean(LBRZArraybuf)];
        SuccessArray = [ SuccessArray m ];
    catch ME
    end
end
ChosenFeatures.alphaArray = alphaArray;
ChosenFeatures.AverageTSIRZArray = ATSIRZArray;
ChosenFeatures.TSIRZgammaArray = gamArray;
ChosenFeatures.LBRZ = LBRZArray;
ChosenFeatures.trueStateArray = ones(1,size(SuccessArray,2));
alphaArray = [];
gamArray = [];
SuccessArray = [];
LBRZArray = [];
ATSIRZArray = [];
if((size(nostimstepsizeArray,2)) < WindowSize )
    Window = size(nostimstepsizeArray,2);
else
    Window = WindowSize;
end
for m = 1:(size(nostimstepsizeArray,2) - Window + 1);
    stepsizebuf = [];
    TSIRZbuf = [];
    ATSIRZArraybuf = [];
    LBRZArraybuf = [];
    for b = m:m+Window-1
        stepsizebuf = [ stepsizebuf nostimstepsizeArray{b}];
        TSIRZbuf = [ TSIRZbuf nostimTSIRZArray{b} ];
        ATSIRZArraybuf = [ ATSIRZArraybuf nostimTSIRZArray{m} ];
        LBRZArraybuf = [LBRZArraybuf nostimLBRZArray{m} ];
    end
    try
        stepsizedist = fitdist(double(stepsizebuf)','stable');
        TSIRZdist = fitdist(double(TSIRZbuf)','stable');
        alphaArray = [ alphaArray stepsizedist.alpha ];
        gamArray = [ gamArray TSIRZdist.gam ];
        ATSIRZArray = [ ATSIRZArray mean(ATSIRZArraybuf)];
        LBRZArray = [ LBRZArray mean(LBRZArraybuf)];
        SuccessArray = [ SuccessArray m ];
    catch ME
    end
end
ChosenFeatures.alphaArray = [ChosenFeatures.alphaArray alphaArray];
ChosenFeatures.AverageTSIRZArray = [ChosenFeatures.AverageTSIRZArray ATSIRZArray];
ChosenFeatures.TSIRZgammaArray = [ChosenFeatures.TSIRZgammaArray gamArray];
ChosenFeatures.LBRZ = [ ChosenFeatures.LBRZ LBRZArray];
ChosenFeatures.trueStateArray = [ChosenFeatures.trueStateArray 2*ones(1,size(SuccessArray,2))];
end


