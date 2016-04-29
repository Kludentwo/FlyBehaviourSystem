function [ Epochs, NumberOfEpochs ] = PartitionEpochData( dataContainer, FilterEnabled )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% RelabelingThreshold serves to relabel "stim paradigmes" to non-stim if
% insufficient stimulations were done.

X = dataContainer(1,:);
Y = dataContainer(2,:);
Triggered = dataContainer(3,:);
Timestamps = dataContainer(4,:);
InResetZone = dataContainer(5,:);
InTriggerZone = dataContainer(6,:);
Bin = dataContainer(7,:); 

OldSample = Bin(1);
EpochStarts = 1;
%EpochStarts = [];

wut = [];
wutx = [];

for i = 2:size(X,2)
    if(OldSample ~= Bin(i))
        OldSample = Bin(i);
        EpochStarts = [ EpochStarts i ];
    end
    if(Bin(i) == 0 && Triggered(i) == 1)
        wut = [wut i ];
        wutx = [wutx X(i) ];
    end
end

EpochStarts = [ EpochStarts size(X,2) ];
NumberOfEpochs = size(EpochStarts,2);
ErrorArray = [];
m = 1;

for k = 1:NumberOfEpochs-1
    Start = EpochStarts(k);
    End = EpochStarts(k+1)-1;
    if(FilterEnabled && (Bin(Start) == 0) )
        Diff = End-Start;
        if Diff >= 4658
            Start = Start + 4658; % This number will have to be determined but patches must be made to the data first
        end
    end
    if(FilterEnabled && (Bin(Start) == 1) )
        m = Start+1;
        while(sum(Triggered(Start:m)) <= 5)
            m = m + 1;
            if (m == size(Triggered,2))
                break;
            end
        end
        Start = m;
    end
    if(k+1 == NumberOfEpochs)
        End = EpochStarts(k+1);
    end
    Armed = Bin(Start);
    if(size(X(Start:End),2) < 10)
        break;
    end
    Epochs{k} = {X(Start:End); Y(Start:End); Triggered(Start:End); Timestamps(Start:End); InResetZone(Start:End); InTriggerZone(Start:End);  Bin(Start:End); Armed};
end
%dataContainer = [X; Y; Triggered; Timestamps; InResetZone; InTriggerZone; Bin];
NumberOfEpochs = size(Epochs,2);
end