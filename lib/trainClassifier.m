function [ mysvm ] = trainClassifier( FlyStruct, arenalist )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
features = [];
t_class = [];
for i = arenalist
    features = [ features; FlyStruct(i).Features.AverageTSIRZArray' FlyStruct(i).Features.alphaArray' FlyStruct(i).Features.LBRZ' FlyStruct(i).Features.TSIRZgammaArray'];
    t_class = [ t_class; FlyStruct(i).Features.trueStateArray' ];
end
% using Matlab function "svmtrain"
C = 1e4; % soft-margin parameter ("regularisation") - automatisk rescaled for imbalanced classes
mykernel = 'polynomial'; %'rbf'; % 'linear', 'quadratic',
opts = statset();
for i = 1:2
    t_class = abs(t_class-((i-1)*3));
    mysvm{i} = svmtrain(features, t_class, 'boxconstraint', C, 'kernel_function', mykernel, 'method', 'SMO', 'options', opts, 'ShowPlot', 'true');
end
    


end

