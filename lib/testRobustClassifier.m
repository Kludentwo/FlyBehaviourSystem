function [ estimate, successrate ] = testRobustClassifier( mysvm, FlyStruct, arenalist);
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
features = [];
t_class = [];
for i = arenalist
    features = [ features; FlyStruct(i).Features.AverageTSIRZArray' FlyStruct(i).Features.LBRZ'];
    t_class = [ t_class; FlyStruct(i).Features.trueStateArray' ];
end

for i = 1:2
    estimate(i,:) = svmclassify(mysvm{i}, features)';
end

for i = 1:length(estimate)
    if(sum(estimate(:,i) ==1) >1)
        estimate(:,i) = 2*ones(2,1);
    end
end

Classification = [ estimate(1,:); t_class' ]; 
successcount = 0;
for p = 1:size(Classification,2)
    if Classification(1,p) == Classification(2,p)
        successcount = successcount + 1;
    end
end

successrate = successcount/size(Classification,2);

end

