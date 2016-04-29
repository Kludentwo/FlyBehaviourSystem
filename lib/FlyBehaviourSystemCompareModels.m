function [Equalness] = FlyBehaviourSystemCompareModels( models, models2, method, methodparameter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
hest = 1;

compareMatrix = zeros(size(models,2),size(models2.models,2));

if strcmpi(method,'parametric')
    for i = 1:size(models,2)
        for k = 1:size(models2.models,2)
            if(~isempty(models(i).stimulated) && ~isempty(models2.models(k).stimulated))
               compareMatrix(i,k) = (models(i).stimulated.parameters-models2.models(k).stimulated.parameters).^2
            end
        end
    end
end

if strcmpi(method,'percentile')
    
end

end

