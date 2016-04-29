function [ StepSizeModel, TSIRZModel, LBRZModel ] = CreateArraysForShow( FBS )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
stimvar = [];
stimmean = [];
nostimvar  = [];
nostimmean = [];
for i = 1:size(FBS.Models,2)
    if(~isempty(FBS.Models(i).stimulated))
    stimvar = [ stimvar ((pi()^2)/6 )*( (1/(FBS.Models(i).stimulated.StepAlpha^2)) + 1/2) ];
    stimmean = [ stimmean FBS.Models(i).stimulated.StepDelta ];
    nostimvar = [ nostimvar ((pi()^2)/6 )*( (1/(FBS.Models(i).nonstimulated.StepAlpha^2)) + 1/2) ];
    nostimmean = [ nostimmean FBS.Models(i).nonstimulated.StepDelta  ];
    end
end

StepSizeModel = [stimmean; stimvar; nostimmean; nostimvar ];

stimvar2 = [];
stimmean2 = [];
nostimvar2  = [];
nostimmean2 = [];
for i = 1:size(FBS.Models,2)
    if(~isempty(FBS.Models(i).stimulated))
    stimvar2 = [ stimvar2 ((pi()^2)/6 )*( (1/(FBS.Models(i).stimulated.TSIRZAlpha^2)) + 1/2) ];
    stimmean2 = [ stimmean2 FBS.Models(i).stimulated.TSIRZDelta ];
    nostimvar2 = [ nostimvar2 ((pi()^2)/6 )*( (1/(FBS.Models(i).nonstimulated.TSIRZAlpha^2)) + 1/2) ];
    nostimmean2 = [ nostimmean2 FBS.Models(i).nonstimulated.TSIRZDelta  ];
    end
end

TSIRZModel = [stimmean2; stimvar2; nostimmean2; nostimvar2 ];

stimvar3 = [];
stimmean3 = [];
nostimvar3  = [];
nostimmean3 = [];
for i = 1:size(FBS.Models,2)
    if(~isempty(FBS.Models(i).stimulated))
    stimvar3 = [ stimvar3 FBS.Models(i).stimulated.LBRZvar ];
    stimmean3 = [ stimmean3 FBS.Models(i).stimulated.LBRZmean ];
    nostimvar3 = [ nostimvar3 FBS.Models(i).nonstimulated.LBRZvar ];
    nostimmean3 = [ nostimmean3 FBS.Models(i).nonstimulated.LBRZmean  ];
    end
end

LBRZModel = [stimmean3; stimvar3; nostimmean3; nostimvar3 ];


end

