function [FBS] = FlyBehaviourSystemModels( FBS, opts )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
arenalist = FBS.settings.arenalist;
FlyStruct = FBS.FlyStruct;

try
    domodels = isempty(FBS.Models(1).stimulated);
catch ME
    domodels = 1;
end

if(any(strcmpi('redomodels',opts)) || domodels)
    for i = arenalist
        stimstepsizeArray = [];
        stimTSIRZArray = [];
        stimLBRZArray = [];
        
        nostimstepsizeArray = [];
        nostimTSIRZArray = [];
        nostimLBRZArray = [];
        
        size_t = (size(FlyStruct(i).RawData.StepSizeArrays,2));
        for k = 1:size_t
            if(FlyStruct(i).RawData.TrueStateArray(k))
                stimstepsizeArray = [ stimstepsizeArray FlyStruct(i).RawData.StepSizeArrays{k}];
                stimTSIRZArray = [ stimTSIRZArray FlyStruct(i).RawData.TSIRZ{k}];
                stimLBRZArray = [ stimLBRZArray FlyStruct(i).RawData.LBRZ{k}];
            else
                nostimstepsizeArray = [ nostimstepsizeArray FlyStruct(i).RawData.StepSizeArrays{k}];
                nostimTSIRZArray = [ nostimTSIRZArray FlyStruct(i).RawData.TSIRZ{k}];
                nostimLBRZArray = [ nostimLBRZArray FlyStruct(i).RawData.LBRZ{k}];
            end
        end
        
        Models(i).stimulated.stepsizeArray = stimstepsizeArray;
        Models(i).stimulated.TSIRZArray = stimTSIRZArray;
        Models(i).stimulated.LBRZArray = stimLBRZArray;
        
        stimulatedStep = fitdist(double(Models(i).stimulated.stepsizeArray)','stable');
        stimulatedTSIRZ = fitdist(double(Models(i).stimulated.TSIRZArray)','stable');
        Models(i).stimulated.StepAlpha = stimulatedStep.alpha;
        Models(i).stimulated.StepGamma = stimulatedStep.gam;
        Models(i).stimulated.StepDelta = stimulatedStep.delta;
        Models(i).stimulated.TSIRZAlpha = stimulatedTSIRZ.alpha;
        Models(i).stimulated.TSIRZGamma = stimulatedTSIRZ.gam;
        Models(i).stimulated.TSIRZDelta = stimulatedTSIRZ.delta;
        Models(i).stimulated.LBRZmean = mean(Models(i).stimulated.LBRZArray);
        Models(i).stimulated.LBRZvar = var(Models(i).stimulated.LBRZArray);
        
        Models(i).nonstimulated.stepsizeArray = nostimstepsizeArray;
        Models(i).nonstimulated.TSIRZArray = nostimTSIRZArray;
        Models(i).nonstimulated.LBRZArray = nostimLBRZArray;
        
        nonstimulatedStep = fitdist(double(Models(i).nonstimulated.stepsizeArray)','stable');
        nonstimulatedTSIRZ = fitdist(double(Models(i).nonstimulated.TSIRZArray)','stable');
        Models(i).nonstimulated.StepAlpha = nonstimulatedStep.alpha;
        Models(i).nonstimulated.StepGamma = nonstimulatedStep.gam;
        Models(i).nonstimulated.StepDelta = nonstimulatedStep.delta;
        Models(i).nonstimulated.TSIRZAlpha = nonstimulatedTSIRZ.alpha;
        Models(i).nonstimulated.TSIRZGamma = nonstimulatedTSIRZ.gam;
        Models(i).nonstimulated.TSIRZDelta = nonstimulatedTSIRZ.delta;
        Models(i).nonstimulated.LBRZmean = mean(Models(i).nonstimulated.LBRZArray);
        Models(i).nonstimulated.LBRZvar = var(Models(i).nonstimulated.LBRZArray);      
    end
    FBS.Models = Models;
    cd('data')
    save(FBS.settings.savename,'FBS')
    cd ..
end
end

