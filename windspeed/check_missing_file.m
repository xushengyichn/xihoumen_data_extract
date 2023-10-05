clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% 定义路径
outputPath = 'F:\test\output\';

% Get the file list of dat files
fileList = dir([outputPath '*-UA1.txt']); % 仅列出其中一种txt文件来获取文件列表

baseName = fileList(1).name(1:end-8); % 仅列出其中一种txt文件来获取文件列表

numIterations length(fileList); % 仅列出其中一种txt文件来获取文件列表

for k1 = 1: numIterations
    % check if file exists
    if ~exist([outputPath baseName '-UA1.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA1.txt']);
    end
    if ~exist([outputPath baseName '-UA2.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA2.txt']);
    end
    if ~exist([outputPath baseName '-UA3.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA3.txt']);
    end
    if ~exist([outputPath baseName '-UA4.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA4.txt']);
    end
    if ~exist([outputPath baseName '-UA5.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA5.txt']);
    end
    if ~exist([outputPath baseName '-UA6.txt'], 'file')
        error('File %s does not exist', [outputPath baseName '-UA6.txt']);
    end
end