function [ data  ] = NaiveFilter( dataContainer )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data = dataContainer;

errors = [];
for i = 1:size(data(1,:),2)
    if data(1,i) == 161 && data(2,i) == 26
        errors = [errors i ];
    end
end
    data(:,errors) = [];
    
%     filteredX = data(1,:);
%     filteredY = data(2,:);
%     filteredTriggered = data(3,:);
%     filteredTimestamps = data(4,:);
%     filteredInResetZone = data(5,:);
%     filteredInTriggerZone = data(6,:);
%     filteredBin = data(7,:); 
end

