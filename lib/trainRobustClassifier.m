function [ mysvm ] = trainRobustClassifier( FlyStruct, arenalist )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
features = [];
t_class = [];
for i = arenalist
    features = [ features; FlyStruct(i).RobustFeatures.AverageTSIRZArray' FlyStruct(i).RobustFeatures.LBRZ'];
    t_class = [ t_class; FlyStruct(i).RobustFeatures.trueStateArray' ];
end
% using Matlab function "svmtrain"
C = 1e3; % soft-margin parameter ("regularisation") - automatisk rescaled for imbalanced classes
mykernel = 'linear'; %'rbf'; % 'linear', 'quadratic', 'rbf_sigma', 0.15,
%opts = statset();
opts = optimset;
for i = 1:2
    t_class = abs(t_class-((i-1)*3));
    mysvm{i} = svmtrain(features, t_class, 'boxconstraint', C, 'kernel_function', mykernel, 'method', 'QP', 'options', opts, 'ShowPlot', 'true');
end
    


end

