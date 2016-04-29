function [ x1, f1, rr1 ] = CreateStepBasedHistograms(StepSizeArray, Armed, ArenaNumber, ClosePlot )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
StepSizeArray(isnan(StepSizeArray))=[];

rr1 = sort((StepSizeArray),'descend');
%optN = sshist(rr1);
%[f1,x1] = hist(rr1,optN);
%[f1,x1] = hist(rr1,nbins);

edges = [ 0:0.1:round(max(StepSizeArray)) ];

Sfig = figure;
h = histogram(rr1,edges,'Normalization','probability');
x1 = h.BinEdges;
f1 = h.Values;
%histbar1 = bar(x1,f1/trapz(x1,f1));
if(Armed == 2)
    title(['Unknown Behaviour for fly number ' num2str(ArenaNumber) ])
elseif(Armed == 1)
    title(['Stimulated Behaviour for fly number ' num2str(ArenaNumber) ])
else
    title(['Non-stimulated Behaviour for fly number ' num2str(ArenaNumber) ])
end
set(gca,'XLim',[0 max(edges)]);
if(ClosePlot)
    close(Sfig)
end
end

