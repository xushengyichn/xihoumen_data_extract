%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%Date: 2023-10-04 22:13:37
%LastEditors: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%LastEditTime: 2023-10-04 22:35:24
%FilePath: \xihoumen_inverse_force_estimationc:\Users\shengyix\Documents\GitHub\xihoumen_data_extract\acceleration\dat_to_txt.m
%Description: 将dat文件转换为txt文件
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% 定义路径


dataPath = 'D:\2013\allVIB\';
exePath = 'C:\temp\exe\';
outputPath = 'C:\temp\output\';

% set if showing the message
showMessages = false;

% Get the file list of dat files
fileList = dir([dataPath '*-VIB.dat']);


numIterations = length(fileList);

if isempty(gcp('nocreate'))
    parpool();
end

b = ProgressBar(numIterations, ...
    'IsParallel', true, ...
    'WorkerDirectory', pwd(), ...
    'Title', 'Parallel 2' ...
    );
b.setup([], [], []);

% for loop
parfor  k1 = 1:numIterations
    % Get the file name
    datFile = [dataPath fileList(k1).name];

    % Construct the output filename
    % remove extension
    [~,baseName,~] = fileparts(datFile);
    txtac2File = [outputPath baseName '-vibac2.txt'];
    txtac3File = [outputPath baseName '-vibac3.txt'];
    txtac4File = [outputPath baseName '-vibac4.txt'];

    % Construct the command
    command1 = [exePath 'vib2txtac2.exe "' datFile '" "' txtac2File '"'];
    command2 = [exePath 'vib2txtac3.exe "' datFile '" "' txtac3File '"'];
    command3 = [exePath 'vib2txtac4.exe "' datFile '" "' txtac4File '"'];
    
    % Run the command
    % 如果文件不存在则运行命令

    if ~exist(txtac2File, 'file')
        if showMessages
            disp(['Executing command for: ' txtac2File]);
        end
        system(command1);
    else
        if showMessages
            disp(['Skipping existing file: ' txtac2File]);
        end
    end

    if ~exist(txtac3File, 'file')
        if showMessages
            disp(['Executing command for: ' txtac3File]);
        end
        system(command2);
    else
        if showMessages
            disp(['Skipping existing file: ' txtac3File]);
        end
    end

    if ~exist(txtac4File, 'file')
        if showMessages
            disp(['Executing command for: ' txtac4File]);
        end
        system(command3);
    else
        if showMessages
            disp(['Skipping existing file: ' txtac4File]);
        end
    end

        % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    updateParallel([], pwd);
end
b.release();