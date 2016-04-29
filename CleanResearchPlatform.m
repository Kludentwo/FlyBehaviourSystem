%List of Options
% 'delete'
% Classify:
% 'usegoodset'
% 'train'
% 'robustonly'
% 'fullfeaturesonly'
% 'validaterobust'
% 'validateallfeatures'
% 'validateboth'
% 'test'
% Modelling: 
% 'redomodels'

% name = '270316_epochCount14hours.mat';
% '300316_epochCount14hours.mat'
% '190416_epochCount2hoursControl'
addpath('lib')
%FBS = FlyBehaviourSystem('name', '190416_epochCount2hoursControl.mat', 'arenalist', [ 1 2 3 4 5 6 7 8 9 10 11 ], 'validation', [ 20 21 22],'endofdata',241386, 'opts', 'usegoodset');
%FBS = FlyBehaviourSystem('name', '300316_epochCount14hours.mat');

%[ StepSizeModel, TSIRZModel, LBRZModel ] = CreateArraysForShow( FBS );

% figure,
% scatter(FBS.FlyStruct(1).RobustFeatures.AverageTSIRZArray(find(FBS.FlyStruct(1).RobustFeatures.trueStateArray == 1)),FBS.FlyStruct(1).RobustFeatures.LBRZ(find(FBS.FlyStruct(1).RobustFeatures.trueStateArray == 1)))
% hold on
% scatter(FBS.FlyStruct(1).RobustFeatures.AverageTSIRZArray(find(FBS.FlyStruct(1).RobustFeatures.trueStateArray == 2)),FBS.FlyStruct(1).RobustFeatures.LBRZ(find(FBS.FlyStruct(1).RobustFeatures.trueStateArray == 2)),'rx')
% title('Mean TSIRZ vs LBRZ')
% ylabel('LBRZ probability')
% xlabel('Mean TSIRZ [s]')
% legend('stimulated','nonstimulated')
cd('img')

h = figure;
set(h,'PaperType','A4', ...
         'paperOrientation', 'portrait', ...
         'paperunits','CENTIMETERS', ...
         'PaperPosition',[.63, .63, 28.41, 19.72]);
for k = 1:9
subplot(3,3,k)
xaxe = 0:0.1:50;
maxe = 0:0.01:50;
pd1 = makedist('Stable','alpha',FBS.Models(k).stimulated.StepAlpha,'beta',1,'gam',FBS.Models(k).stimulated.StepGamma,'delta',FBS.Models(k).stimulated.StepDelta);
pd2 = makedist('Stable','alpha',FBS.Models(k).nonstimulated.StepAlpha,'beta',1,'gam',FBS.Models(k).nonstimulated.StepGamma,'delta',FBS.Models(k).nonstimulated.StepDelta);
stimpdf = pdf(pd1,maxe);
nostimpdf = pdf(pd2,maxe);
histogram(FBS.Models(k).stimulated.stepsizeArray,xaxe,'Normalization','pdf')
hold on
histogram(FBS.Models(k).nonstimulated.stepsizeArray,xaxe,'Normalization','pdf')
plot(maxe,stimpdf,'Linewidth',2);
plot(maxe,nostimpdf,'Linewidth',2);
set(gca,'xlim',[0 10])
title(['Distribution of Step size for fly #' mat2str(k)])
ylabel('Step size probability')
xlabel('Step size [mm]')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
end
print(['9FlyStep'],'-depsc')

figure,
maxe = 0:0.01:50;
xaxe = 0:0.1:50;
k = 10;
pd1 = makedist('Stable','alpha',FBS.Models(k).stimulated.StepAlpha,'beta',1,'gam',FBS.Models(k).stimulated.StepGamma,'delta',FBS.Models(k).stimulated.StepDelta);
pd2 = makedist('Stable','alpha',FBS.Models(k).nonstimulated.StepAlpha,'beta',1,'gam',FBS.Models(k).nonstimulated.StepGamma,'delta',FBS.Models(k).nonstimulated.StepDelta);
stimpdf = pdf(pd1,maxe);
nostimpdf = pdf(pd2,maxe);
histogram(FBS.Models(10).stimulated.stepsizeArray,xaxe,'Normalization','pdf')
hold on
histogram(FBS.Models(10).nonstimulated.stepsizeArray,xaxe,'Normalization','pdf')
plot(maxe,stimpdf,'Linewidth',2);
plot(maxe,nostimpdf,'Linewidth',2);
set(gca,'xlim',[0 10])
title(['Distribution of Step size for fly #' mat2str(10)])
ylabel('Step size probability')
xlabel('Step size [mm]')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
print(['10sFlyStep'],'-depsc')


h = figure;
set(h,'PaperType','A4', ...
         'paperOrientation', 'portrait', ...
         'paperunits','CENTIMETERS', ...
         'PaperPosition',[.63, .63, 28.41, 19.72]);
for k = 1:9
subplot(3,3,k)
stimmean = mean(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100);
stimvar = var(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100);
stimx = 0:0.01:100;
nostimmean = mean(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100);
nostimvar = var(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100);
nostimx = 0:0.01:100;
stimpdf = normpdf(stimx,stimmean,sqrt(stimvar));
histogram(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100,0:1:100,'Normalization','pdf')
hold on
histogram(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100,0:1:100,'Normalization','pdf')
plot(stimx,stimpdf,'Linewidth',2);
plot(nostimx,normpdf(nostimx,nostimmean,sqrt(nostimvar)),'Linewidth',2)
title(['Distribution of LBRZ for fly #' mat2str(k)])
ylabel('LBRZ probability')
xlabel('LBRZ in %')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
end
print(['9FlyLBRZ'],'-depsc')

figure,
k = 10;
stimmean = mean(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100);
stimvar = var(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100);
stimx = 0:0.01:100;
nostimmean = mean(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100);
nostimvar = var(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100);
nostimx = 0:0.01:100;
stimpdf = normpdf(stimx,stimmean,sqrt(stimvar));
histogram(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 1)).*100,0:1:100,'Normalization','probability')
hold on
histogram(FBS.FlyStruct(k).RobustFeatures.LBRZ(find(FBS.FlyStruct(k).RobustFeatures.trueStateArray == 2)).*100,0:1:100,'Normalization','probability')
plot(stimx,stimpdf,'Linewidth',2);
plot(nostimx,normpdf(nostimx,nostimmean,sqrt(nostimvar)),'Linewidth',2)
title(['Distribution of LBRZ for fly #' mat2str(k)])
ylabel('LBRZ probability')
xlabel('LBRZ in %')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
print(['10sFlyLBRZ'],'-depsc')

h = figure;
set(h,'PaperType','A4', ...
         'paperOrientation', 'portrait', ...
         'paperunits','CENTIMETERS', ...
         'PaperPosition',[.63, .63, 28.41, 19.72]);
for k = 1:9
subplot(3,3,k)
xaxe = 0:0.1:25;
pd1 = makedist('Stable','alpha',FBS.Models(k).stimulated.TSIRZAlpha,'beta',0,'gam',FBS.Models(k).stimulated.TSIRZGamma,'delta',FBS.Models(k).stimulated.TSIRZDelta);
pd2 = makedist('Stable','alpha',FBS.Models(k).nonstimulated.TSIRZAlpha,'beta',0,'gam',FBS.Models(k).nonstimulated.TSIRZGamma,'delta',FBS.Models(k).nonstimulated.TSIRZDelta);
stimpdf = pdf(pd1,xaxe);
nostimpdf = pdf(pd2,xaxe);
histogram(FBS.Models(k).stimulated.TSIRZArray,xaxe,'Normalization','pdf')
hold on
histogram(FBS.Models(k).nonstimulated.TSIRZArray,xaxe,'Normalization','pdf')
plot(xaxe,stimpdf,'Linewidth',2);
plot(xaxe,nostimpdf,'Linewidth',2)
title(['Distribution of TSIRZModel for fly #' mat2str(k)])
ylabel('TSIRZ probability')
xlabel('TSIRZ')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
end
print(['9FlyTSIRZ'],'-depsc')

figure,
k = 10;
xaxe = 0:0.1:25;
pd1 = makedist('Stable','alpha',FBS.Models(k).stimulated.TSIRZAlpha,'beta',0,'gam',FBS.Models(k).stimulated.TSIRZGamma,'delta',FBS.Models(k).stimulated.TSIRZDelta);
pd2 = makedist('Stable','alpha',FBS.Models(k).nonstimulated.TSIRZAlpha,'beta',0,'gam',FBS.Models(k).nonstimulated.TSIRZGamma,'delta',FBS.Models(k).nonstimulated.TSIRZDelta);
stimpdf = pdf(pd1,xaxe);
nostimpdf = pdf(pd2,xaxe);
histogram(FBS.Models(k).stimulated.TSIRZArray,xaxe,'Normalization','pdf')
hold on
histogram(FBS.Models(k).nonstimulated.TSIRZArray,xaxe,'Normalization','pdf')
plot(xaxe,stimpdf,'Linewidth',2);
plot(xaxe,nostimpdf,'Linewidth',2)
title(['Distribution of TSIRZModel for fly #' mat2str(k)])
ylabel('TSIRZ probability')
xlabel('TSIRZ')
legend('stimulated','nonstimulated','stimulated','nonstimulated')
print(['10sTSIRZ'],'-depsc')
cd ..


figure,
for k = 1:10
th = text(LBRZModel(1,k),LBRZModel(2,k),num2str(k));
set(th,'color',[1 0 0]);
hold on 
th1 = text(LBRZModel(3,k),LBRZModel(4,k),num2str(k));
set(th1,'color',[0 0 1]);
end
set(gca,'xlim',[0 0.4]);
set(gca,'ylim',[0 0.025]);


hest = 1;