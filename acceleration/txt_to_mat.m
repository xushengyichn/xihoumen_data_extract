%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%Date: 2023-10-04 22:13:37
%LastEditors: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%LastEditTime: 2023-10-04 22:35:24
%FilePath: \xihoumen_inverse_force_estimationc:\Users\shengyix\Documents\GitHub\xihoumen_data_extract\acceleration\dat_to_txt.m
%Description: 将txt文件转换为matlab table文件方便后续读取
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% 定义路径
outputPath = 'G:\2013\allVIB\';
resultPath = 'F:\test\result\';

% set whether to show the message
showMessages = true;

% whether to show parfor progress bar
showProgressBar = false;

% Get the file list of dat files
fileList = dir([outputPath '*-vibac2.txt']); % 仅列出其中一种txt文件来获取文件列表


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
for k1 = 314
% for k1 = 1:numIterations
    baseName = fileList(k1).name(1:end-11); % 去掉 '-vibac2.txt' 后缀
    % baseName = '2013-09-20 03'
    dateStr = baseName(1:10);
    timeStr = baseName(12:13);
    startTime = datetime(dateStr, 'InputFormat', 'yyyy-MM-dd') + hours(str2double(timeStr));
    startTime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    % read the txt file
    dataAc2 = load([outputPath baseName '-vibac2.txt']);
    dataAc3 = load([outputPath baseName '-VIBac3.txt']);
    dataAc4 = load([outputPath baseName '-VIBac4.txt']);


    % Check if any of the loaded data files are empty
    if isempty(dataAc2) || isempty(dataAc3) || isempty(dataAc4)
        if showMessages
            disp(['Data files for ' baseName ' are empty. Saving an empty table.']);
        end
    
        % Create an empty table with appropriate variable names
        mergedData = table('Size', [0 10], ...
                           'VariableNames', {'Time', 'AC2_1', 'AC2_2', 'AC2_3', 'AC3_1', 'AC3_2', 'AC3_3', 'AC4_1', 'AC4_2', 'AC4_3'}, ...
                           'VariableTypes', {'datetime', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'});
    
        % Save the empty table
        matFileName = [resultPath baseName '.mat'];
        parsave(matFileName, mergedData);
        if showProgressBar
            updateParallel([], pwd);
        end
        continue;  % Skip the current iteration and move to the next file
    end
    % check the rows of three files are the same
    if size(dataAc2, 1) ~= size(dataAc3, 1) || size(dataAc2, 1) ~= size(dataAc4, 1)
        error('Mismatched row counts in files for %s', baseName);
    end

    % calculate time stamps
    timeStamps = startTime + seconds(dataAc2(:,1));

    % mergedData
    mergedData = table(timeStamps, dataAc2(:,2), dataAc2(:,3), dataAc2(:,4), ...
                       dataAc3(:,2), dataAc3(:,3), dataAc3(:,4), ...
                       dataAc4(:,2), dataAc4(:,3), dataAc4(:,4), ...
                       'VariableNames', {'Time', 'AC2_1', 'AC2_2', 'AC2_3', 'AC3_1', 'AC3_2', 'AC3_3', 'AC4_1', 'AC4_2', 'AC4_3'});

    % 检查重复时间戳
            % Find the unique timestamps and their first occurrence
        [~, ~, ic] = unique(mergedData.Time, 'stable');
        
        % Identify the duplicated timestamps
        counts = accumarray(ic, 1);
        duplicatedIndices = find(counts > 1);
        duplicatedTimestamps = find(ismember(ic, duplicatedIndices));

        % Loop through the duplicated timestamps
        rowsToDelete = []; % Store the rows to be deleted
        for idx = duplicatedTimestamps'
            if all(mergedData{idx, 2:end} == 0) % if all other columns except timestamp are zeros
                rowsToDelete = [rowsToDelete; idx];
            end
        end
        
        % Remove the rows
        mergedData(rowsToDelete, :) = [];
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

