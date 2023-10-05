clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

%% data path
resultPath = 'H:\xihoumen_data\acceleration\2013\';

% Get the file list of dat files
fileList = dir([resultPath '*-VIB.mat']); % 仅列出其中一种txt文件来获取文件列表

nFiles = length(fileList);
allMergedData = cell(nFiles, 1);
allFileNames = cell(nFiles, 1);