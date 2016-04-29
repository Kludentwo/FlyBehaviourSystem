function [ dataContainer, Armed ] = GetDataFromEpoch( Epoch )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     Epochs{k} = {X(Start:End); 
%                  Y(Start:End); 
%                  Triggered(Start:End); 
%                  Timestamps(Start:End); 
%                  InResetZone(Start:End); 
%                  InTriggerZone(Start:End);  
%                  Bin(Start:End); 
%                  Armed};


currE = cell2mat(Epoch(1:7));
x = currE(1,:);
y = currE(2,:);
triggered = currE(3,:);
Timestamps = currE(4,:);
InResetZone = currE(5,:);
InTriggerZone = currE(6,:);
Bin = currE(7,:);

if(Epoch{8} == 1)
    Armed = true;
else
    Armed = false;
end

dataContainer = [x; y; triggered; Timestamps; InResetZone; InTriggerZone; Bin];

end

