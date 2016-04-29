function [FBS] = FlyBehaviourSystem(varargin)
%FlyBehaviourSystem Quantify Behaviour from flies participating in the
%epochCount system trials.
% Example use: FBS = FlyBehaviourSystem('name', '270316_epochCount14hours.mat', 'arenalist', [], 'validation', [ 20 21 22], 'customwindow', 0, 'endofdata', 0,  'opts', 'usegoodset', 'validateboth', 'test');
% This use will take the 270316_epochCount14hours dataset and extract
% training features and validation features. 
% The parameters are: 
% 'name' - This parameter is the name of the dataset that is to be
% analysed.
% 'arenalist' - This parameter is a vector of the arenas that will be
% included in the analysis an example is [ 1 2 3 4 5 6 7 8 9 10 ] if the
% first 10 arenas are to be investigated.
% 'validation' - Validation is a vector containing the epochs used for
% validation. An example could be [ 20 21 22 ].
% 'customwindow' - custom window has to do with "all features". To improve
% the performance of the distribution fitting, a window function is used to
% combine data into better distributions. If 0 is specified it will default
% to 44.
% 'endofdata' - endofdata specified the last sample of the dataset that is
% to be included. This enables using the first 500000 samples if the flies
% start  getting tired afterwards. If set to 0 it will default to 560000.
% 'opts' - opts is options and the following options can be input:
% The Extraction method has the option 'delete' that deletes the saved data
% for that dataset. This is useful if you want to redo the whole analysis.
% The Classify method has the options to use the good set
% (270316_epochCount14hours) for testing. Otherwise it is possible to train
% using both "all features" and "robust features". If specified the
% classification can be "all features" only or "robust features" only. The
% validation follows the training. "test" is given to test the dataset
% against the "good set".
% The Modelling method has the option 'redomodels'. This enables
% recalculation of the models for the given dataset. A full list of options
% is given:
% Extraction:
% 'delete'
% Classify:
% 'usegoodset'
% 'train'
% 'robustonly'
% 'fullfeaturesonly'
% 'test'
% Modelling: 
% 'redomodels'
% 
% The output of the FlyBehaviourSystem is a Fly Behaviour Struct or FBS.
% This struct contains the extracted features, the settings, classifier
% results and the models for that dataset.
% The output of the classifier is based upon the given options.
% "BasePerformance" is when the dataset is classified using the good set
% (270316_epochCount14hours). "MyPerformance" is when training and
% validating on the given dataset. The performance is given as:
% 'robustsuccessrate' - how good the robust classification performs.
% 'successrate' - how good the "all features" classification performs.
% 'testsuccessrate' - how good the test classification performs
% 'robusttestsuccessrate' - how good the robust test classification
% performs.
% The models are based upon quantifiable parameters from the features. Step
% size feature parameters are: Stable distribution alpha, gamma & delta.
% TSIRZ parameters are: Stable distribution alpha, gamma & delta. LBRZ
% parameters are mean and variance.

warning off
opts = [];
options = false;
validation = [];
arenalist = [];
window = 0;
endofdata = 0;
for k = 1:length(varargin)
    if strcmpi(varargin{k},'name')
        name = varargin{k+1}; 
    end
    if strcmpi(varargin{k},'arenalist')
        arenalist = varargin{k+1};
    end
    if strcmpi(varargin{k},'validation')
        validation = varargin{k+1};
    end
    if strcmpi(varargin{k},'customwindow')
        window = varargin{k+1};
    end
    if strcmpi(varargin{k},'endofdata')
        endofdata = varargin{k+1};
    end
    if options == true
        opts = [ opts; varargin(k) ];
    end
    if strcmpi(varargin{k},'opts')
        options = true;
    end
end
addpath('data');
addpath('lib');
if(~exist(name))
    error('no or wrong name specified. Dataset does not exist.');
end

[ FBS ] = FlyBehaviourSystemExtract(name,arenalist,validation,opts,window,endofdata);
[ FBS ] = FlyBehaviourSystemClassify( FBS , opts );
if (FBS.Classifier.BasePerformance.testsuccessrate < 0.5 )
    try
        [ FBS ] = FlyBehaviourSystemClassify( FBS , 'train' );
    catch ME
        disp('This data set is not classifiable by the base set and its own classifier does not converge')
    end
end
[ FBS ] = FlyBehaviourSystemModels( FBS, opts );


end