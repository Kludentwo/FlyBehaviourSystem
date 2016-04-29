function [ estimate, successrate ] = validateClassifier( mysvm, FlyStruct, arenalist )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
testfeatures = [];
t_class = [];
for i = arenalist
    for m = 1:size(FlyStruct(i).Validation,2)
        if(~isempty(FlyStruct(i).Validation{m}.alpha))
            testfeatures = [ testfeatures; FlyStruct(i).Validation{m}.AverageTSIRZ' FlyStruct(i).Validation{m}.alpha' FlyStruct(i).Validation{m}.LBRZ' FlyStruct(i).Validation{m}.TSIRZgamma'];
            t_class = [ t_class 2-FlyStruct(i).Validation{m}.trueState ];
        end
    end
end
for i = 1:2
    estimate(i,:) = svmclassify(mysvm{i}, testfeatures)';
end

for i = 1:length(estimate)
    if(sum(estimate(:,i) ==1) >1)
        estimate(:,i) = 2*ones(2,1);
    end
end

Classification = [ estimate(1,:); t_class ]; 
successcount = 0;
for p = 1:size(Classification,2)
    if Classification(1,p) == Classification(2,p)
        successcount = successcount + 1;
    end
end

successrate = successcount/size(Classification,2);

end

