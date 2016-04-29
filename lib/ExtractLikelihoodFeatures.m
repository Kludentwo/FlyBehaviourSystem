function [ LikelihoodFeatures ] = ExtractLikelihoodFeatures( Epochs, NumberOfEpochs, Validations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

LikelihoodFeatures = struct;
ValidationCnt = 1;
DataCnt = 1;
for m = 1:NumberOfEpochs
    [ dataContainer, Armed ] = GetDataFromEpoch( Epochs{m} );
    % dataContainer = [X; Y; Triggered; Timestamps; InResetZone; InTriggerZone; Bin];
    dt = [ 0 diff(dataContainer(4,:))];
    IncludeResetZoneVar = 0;
    TimeAccumulator = 0;
    TimeCounter = 1;
    TimeAccumulaterArray = [];
    activated  = 0;
    Likelihood = 0;
    for i = 1:size(dataContainer(5,:),2)
        if(IncludeResetZoneVar)
            if(dataContainer(6,i) || dataContainer(5,i))
                Likelihood = Likelihood + 1;
                TimeAccumulator = TimeAccumulator + dt(i);
                activated = 1;
            else
                if(activated)
                    TimeAccumulaterArray(TimeCounter) = TimeAccumulator;
                    TimeCounter = TimeCounter + 1;
                    TimeAccumulator = 0;
                    activated = 0;
                end
            end
        else
            if(dataContainer(6,i))
                Likelihood = Likelihood + 1;
                TimeAccumulator = TimeAccumulator + dt(i);
                activated = 1;
            else
                if(activated)
                    TimeAccumulaterArray(TimeCounter) = TimeAccumulator;
                    TimeCounter = TimeCounter + 1;
                    TimeAccumulator = 0;
                    activated = 0;
                end
            end
        end
    end
    if(any(m == Validations))
        LikelihoodFeatures.validation{ValidationCnt}.TimeSpentInRewardZoneArray = TimeAccumulaterArray;
        LikelihoodFeatures.validation{ValidationCnt}.LikelihoodOfBeingInRewardZonePercent = Likelihood/size(dataContainer(6,:),2);
        LikelihoodFeatures.validation{ValidationCnt}.TrueStateArray = Armed;
        ValidationCnt = ValidationCnt +1 ;
    else
        LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray{DataCnt} = TimeAccumulaterArray;
        LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent{DataCnt} = Likelihood/size(dataContainer(6,:),2);
        LikelihoodFeatures.RawData.TrueStateArray(DataCnt) = Armed;
        DataCnt = DataCnt +1 ;
    end
end
end

