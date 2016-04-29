function [ StepSizeArray ] = CalcSteps( X, Y )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    % 6.13 is the conversion from pixels to mm;
    for i = 2:size(X,2)
        StepSizeArray(i-1) = sqrt( ( X(i) - X(i-1))^2 + ( Y(i) - Y(i-1))^2 )/6.13;
    end
end

