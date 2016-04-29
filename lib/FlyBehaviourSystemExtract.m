function [ FBS ] = FlyBehaviourSystemExtract( name, arenalist, Validations, opts, windowsize, LastSampleNr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[~,fname,~] = fileparts(name);
savename = [char(fname) '_dataset'];
filename = [savename '.mat'];

if ( strcmp(name,'300316_epochCount14hours.mat' ) )
    arenalist = [ 1 2 3 4 5 6 7 9 10 11];
end

if ( strcmp(name,'170416_epochCount14hours.mat' ) )
    arenalist = [ 1 2 3 4 5 6 7 9 10 11];
end

if ( strcmp(name,'270316_epochCount14hours.mat' ) )
    arenalist = [ 1 2 3 4 6 7 8 9 10 11];
end

if( strcmp(name,'310316_epochCount5hours.mat' ) )
    arenalist = [ 2 5 6 ];
end


if nargin < 6 || (LastSampleNr == 0)
    LastSampleNr = 560000;
end
if nargin < 5 || (windowsize == 0)
    windowsize = 44;
    %windowsizes: 22 is 82%
    % 36 is 86%
    % 44 is 89%
end
if nargin < 3 || (size(Validations,2) == 0)
    Validations = [ 20 21 22 ];
end
if nargin < 2 || (size(arenalist,2) == 0)
    arenalist = [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
end

if(any(strcmp('delete',opts)))
    delete(['data/' filename ])
end
if(exist(filename))
    load(filename);
else
    FBS = struct;
    FlyStruct = struct;
    h = waitbar(0,'Extracting...');
    for j = arenalist %StartArena:StartArena-1+NumberOfArenas
        waitbar(j / size(arenalist,2));
        [ dataContainer ] = extractEpochData( name, j, LastSampleNr );
        [ data ] = NaiveFilter( dataContainer );
        [ Epochs, NumberOfEpochs ] = PartitionEpochData( data, 1 );
        
        [ StepSizeFeatures ] = ExtractStepSizeFeatures( Epochs, NumberOfEpochs, Validations );
        [ LikelihoodFeatures ] = ExtractLikelihoodFeatures( Epochs, NumberOfEpochs, Validations );
        FlyStruct(j).RawData.StepSizeArrays = StepSizeFeatures.RawData.StepSizeArrays;
        FlyStruct(j).RawData.TrueStateArray = StepSizeFeatures.RawData.TrueStateArray;
        FlyStruct(j).RawData.TSIRZ = LikelihoodFeatures.RawData.TimeSpentInRewardZoneArray;
        FlyStruct(j).RawData.LBRZ = LikelihoodFeatures.RawData.LikelihoodOfBeingInRewardZonePercent;
        
        FlyStruct(j).Features = ExtractChosenFeatures(StepSizeFeatures, LikelihoodFeatures,  windowsize );
        FlyStruct(j).RobustFeatures = ExtractRobustFeatures(StepSizeFeatures, LikelihoodFeatures,  1 );
        FlyStruct(j).Validation = ExtractValidationFeatures(StepSizeFeatures, LikelihoodFeatures);
        
    end
    FBS.FlyStruct = FlyStruct;
    FBS.settings.arenalist = arenalist;
    FBS.settings.savename = savename;
    FBS.settings.validations = Validations;
    cd('data')
    save(savename,'FBS')
    cd ..
    close(h);
end
end

