%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%Date: 2023-10-04 22:13:37
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-05 12:54:01
%FilePath: \Exercises-for-Techniques-for-estimation-in-dynamics-systemsf:\git\xihoumen_data_extract\windspeed\wind_txt_to_mat.m
%Description: 将txt文件转换为matlab table文件方便后续读取
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% 定义路径
outputPath = 'F:\test\output\';
resultPath = 'F:\test\result\';

% set whether to show the message
showMessages = true;

% whether to show parfor progress bar
showProgressBar = false;

% Get the file list of dat files
fileList = dir([outputPath '*-UA1.txt']); % 仅列出其中一种txt文件来获取文件列表


numIterations = length(fileList);


if showProgressBar
    if isempty(gcp('nocreate'))
        parpool();
    end

    b = ProgressBar(numIterations, ...
        'IsParallel', true, ...
        'WorkerDirectory', pwd(), ...
        'Title', 'Parallel 2' ...
        );
    b.setup([], [], []);
end


% for loop
for k1 = 1
% parfor k1 = 1:numIterations
    baseName = fileList(k1).name(1:end-8); % 去掉 '-vibac2.txt' 后缀
    % baseName = '2013-08-05 09-VIB'
    dateStr = baseName(1:10);
    timeStr = baseName(12:13);
    startTime = datetime(dateStr, 'InputFormat', 'yyyy-MM-dd') + hours(str2double(timeStr));
    startTime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    % read the txt file
    dataUA1 = load([outputPath baseName '-UA1.txt']);
    dataUA2 = load([outputPath baseName '-UA2.txt']);
    dataUA3 = load([outputPath baseName '-UA3.txt']);
    dataUA4 = load([outputPath baseName '-UA4.txt']);
    dataUA5 = load([outputPath baseName '-UA5.txt']);
    dataUA6 = load([outputPath baseName '-UA6.txt']);

    

    % Check if any of the loaded data files are empty
    if isempty(dataUA1) || isempty(dataUA2) || isempty(dataUA3) || isempty(dataUA4) || isempty(dataUA5) || isempty(dataUA6)
        if showMessages
            disp(['Data files for ' baseName ' are empty. Saving an empty table.']);
        end
    
        % Create an empty table with appropriate variable names
        mergedData = table('Size', [0 7], ...
                           'VariableNames', {'Time', 'UA1_x', 'UA1_y', 'UA1_z', 'UA2_x', 'UA2_y', 'UA2_z', 'UA3_x', 'UA3_y', 'UA3_z', 'UA4_x', 'UA4_y', 'UA4_z', 'UA5_x', 'UA5_y', 'UA5_z', 'UA6_x', 'UA6_y', 'UA6_z'}, ...
                            'VariableTypes', {'datetime', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double','double', 'double', 'double','double', 'double', 'double','double', 'double', 'double'});

        % Save the empty table
        matFileName = [resultPath baseName '.mat'];
        parsave(matFileName, 'mergedData');
        if showProgressBar
            updateParallel([], pwd);
        end
        continue;  % Skip the current iteration and move to the next file
    end
    

    % calculate time stamps
    timeStamps = startTime + seconds(dataUA1(:,1));

    % mergedData
    mergedData = table(timeStamps, dataUA1(:,2), dataUA1(:,3), dataUA1(:,4), dataUA2(:,2), dataUA2(:,3), dataUA2(:,4), dataUA3(:,2), dataUA3(:,3), dataUA3(:,4), dataUA4(:,2), dataUA4(:,3), dataUA4(:,4), dataUA5(:,2), dataUA5(:,3), dataUA5(:,4), dataUA6(:,2), dataUA6(:,3), dataUA6(:,4), ...
        'VariableNames', {'Time', 'UA1_x', 'UA1_y', 'UA1_z', 'UA2_x', 'UA2_y', 'UA2_z', 'UA3_x', 'UA3_y', 'UA3_z', 'UA4_x', 'UA4_y', 'UA4_z', 'UA5_x', 'UA5_y', 'UA5_z', 'UA6_x', 'UA6_y', 'UA6_z'});

    % NOTE: x means the north direction, y means the up direction, z means the west direction
    % save the mergedData

    matFileName = [resultPath baseName '.mat'];

    if exist(matFileName, 'file')
        oldData = load(matFileName);
        if isequal(oldData.mergedData, mergedData)
            if showMessages
                disp(['Skipping ' matFileName ' because it is identical.']);
            end
            continue;
        else
            answer = input(['File ' matFileName ' is different from the new data. Do you want to overwrite? (yes/no): '], 's');
            if ~strcmpi(answer, 'yes')
                continue;
            end
        end
    end

    if showMessages
        disp(['Saving data to: ' matFileName]);
    end

    
    if showProgressBar
        updateParallel([], pwd);
    end
    
    parsave(matFileName, mergedData);
end

if showProgressBar
    b.release();
end


function parsave(fname, mergedData)
  save(fname, 'mergedData')
end
