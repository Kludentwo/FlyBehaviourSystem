function [ x1, f1, rr1 ] = CreateVelocityBasedHistograms( veloc, Armed, ArenaNumber, ClosePlot )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rr1 = sort((veloc),'descend');

edges = [ 1:1:round(max(veloc)) ];

Vfig  = figure;
h = histogram(rr1,edges,'Normalization','probability');
x1 = h.BinEdges;
f1 = h.Values;
if(Armed == 2)
    title(['Velocity: Unknown Behaviour for fly number ' num2str(ArenaNumber) ])
elseif(Armed == 1)
    title(['Velocity: Stimulated Behaviour for fly number ' num2str(ArenaNumber) ])
else
    title(['Velocity: Non-stimulated Behaviour for fly number ' num2str(ArenaNumber) ])
end
xlabel('Velocity [mm/s]') % x-axis label
ylabel('Probability P(v)') % y-axis label
set(gca,'XLim',[0 50]);
if(ClosePlot)
    close(Vfig)
end
end

