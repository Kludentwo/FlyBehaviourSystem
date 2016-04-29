function [ dataContainer ] = extractEpochData( filename, number, lastSample )
%extractData Summary of this function goes here
%   filename is the folder inside FlyData and the file inside that folder
%   example is filename = 'DoubleArena\Round1_WT.mat';
load(filename)

if nargin < 3
    lastSample = size(SessionData.TrackData.Arena(number).Xpos,2);
end

x = SessionData.TrackData.Arena(number).Xpos(1:lastSample);
y = SessionData.TrackData.Arena(number).Ypos(1:lastSample);
triggered = SessionData.TrackData.Arena(number).Triggered(1,1:lastSample);
Timestamps = SessionData.TrackData.Timestamps(1:lastSample);
InResetZone = SessionData.TrackData.Arena(number).InResetZone(1,1:lastSample);
InTriggerZone = SessionData.TrackData.Arena(number).InTriggerZone(1,1:lastSample);
Bin = SessionData.TrackData.Arena(number).Bin(1:lastSample);

Bin(isnan(x)) = [];
InTriggerZone(isnan(x)) = [];
InResetZone(isnan(x)) = [];
Timestamps(isnan(x)) = [];
triggered(isnan(x)) = [];
y(isnan(x))= [];
x(isnan(x)) = [];

dataContainer = [x; y; triggered; Timestamps; InResetZone; InTriggerZone; Bin];

end

