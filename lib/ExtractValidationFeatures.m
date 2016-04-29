function [ ValidationFeatures ] = ExtractValidationFeatures( StepSizeFeatures, LikelihoodFeatures )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Chosen Features = [ 9 3 11 13 ]
size_t = size(StepSizeFeatures.validation,2);
for m = 1:size_t
    try
        stepsizedist = fitdist(double(StepSizeFeatures.validation{m}.StepSizes)','stable');
        TSIRZdist = fitdist(double(LikelihoodFeatures.validation{m}.TimeSpentInRewardZoneArray)','stable');
        alphaArray = stepsizedist.alpha;
        gamArray = TSIRZdist.gam;
    catch ME
        alphaArray = [];
        gamArray = [];
    end
ValidationFeatures{m}.alpha = alphaArray;
ValidationFeatures{m}.AverageTSIRZ = mean(LikelihoodFeatures.validation{m}.TimeSpentInRewardZoneArray);
ValidationFeatures{m}.TSIRZgamma = gamArray;
ValidationFeatures{m}.LBRZ = LikelihoodFeatures.validation{m}.LikelihoodOfBeingInRewardZonePercent;
ValidationFeatures{m}.trueState = LikelihoodFeatures.validation{m}.TrueStateArray;
end
end


