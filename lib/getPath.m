function [ itemList, path ] = getPath()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
path = 'J:\Dropbox\IHA\Speciale\Data\';
var = exist(path,'dir');
if (var)
else
    path = 'C:\Users\Nicolai\Dropbox\IHA\Speciale\Data\';
end
itemList = dir(path);
end

