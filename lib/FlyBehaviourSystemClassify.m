function [ FBS ] = FlyBehaviourSystemClassify( FBS, opts )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
arenalist = FBS.settings.arenalist;
FlyStruct = FBS.FlyStruct;
if nargin < 2 || isempty(opts)
    opts = {'usegoodset';};
end
test = 0;
if(any(strcmp('test',opts)))
    idx = find(opts == 'test');
    load(opts(idx+1));
    test = 1;
end
Both = 0;
if(any(strcmp('usegoodset',opts)))
    load('270316_epochCount14hours_dataset_Robustmysvm_1');
    load('270316_epochCount14hours_dataset_mysvm_44');
    test = 1;
end
Performance = struct;
if(any(strcmp('train',opts)))
    Both = 1;
end
if(any(strcmp('robustonly',opts)) || Both)
    Robustmysvm = trainRobustClassifier( FlyStruct, arenalist );
end
if(any(strcmp('fullfeaturesonly',opts)) || Both)
    mysvm = trainClassifier( FlyStruct, arenalist );
end

if(any(strcmp('robustonly',opts)) || Both || any(strcmp('usegoodset',opts)))
[ robustestimate, Performance.robustsuccessrate ] = validateRobustClassifier( Robustmysvm, FlyStruct, arenalist );
end
if(any(strcmp('fullfeaturesonly',opts)) || Both || any(strcmp('usegoodset',opts)))
[ estimate, Performance.successrate ] = validateClassifier( mysvm, FlyStruct, arenalist );
end
if(test)
    try
        [ estimate, Performance.testsuccessrate ] = testClassifier( mysvm, FlyStruct, arenalist);
    catch ME
    end
    try
        [ estimate, Performance.robusttestsuccessrate ] = testRobustClassifier( Robustmysvm, FlyStruct, arenalist);
    catch ME
    end
end
if(Both)
    FBS.Classifier.MyPerformance = Performance;
    FBS.Classifier.svm = mysvm;
    FBS.Classifier.robustsvm = Robustmysvm;
else
    FBS.Classifier.BasePerformance = Performance;
end
end