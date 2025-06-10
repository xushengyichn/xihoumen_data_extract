%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%Date: 2023-10-04 22:13:37
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-05 12:44:49
%FilePath: \Exercises-for-Techniques-for-estimation-in-dynamics-systemsf:\git\xihoumen_data_extract\windspeed\wind_dat_to_txt.m
%Description: 将dat文件转换为txt文件
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("D:\Github\Function_shengyi_package"))

% 定义路径


dataPath = 'I:\2016\UAN\';
exePath = 'H:\exe\';
outputPath = 'H:\xihoumen_data\2016\wind\';

% set if showing the message
showMessages = true;

% whether to show parfor progress bar
showProgressBar = false;

% Get the file list of dat files
fileList = dir([dataPath '*-UAN.dat']);


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
% for  k1 = 1
for  k1 = 1:numIterations
    % Get the file name
    datFile = [dataPath fileList(k1).name];

    % Construct the output filename
    % remove extension
    [~,baseName,~] = fileparts(datFile);
    % baseName='2013-01-19 21-UAN';
    txtUA1File = [outputPath baseName '-UA1.txt'];
    txtUA2File = [outputPath baseName '-UA2.txt'];
    txtUA3File = [outputPath baseName '-UA3.txt'];
    txtUA4File = [outputPath baseName '-UA4.txt'];
    txtUA5File = [outputPath baseName '-UA5.txt'];
    txtUA6File = [outputPath baseName '-UA6.txt'];

    % Construct the command
    command1 = [exePath 'uan2txtua1.exe "' datFile '" "' txtUA1File '"'];
    command2 = [exePath 'uan2txtua2.exe "' datFile '" "' txtUA2File '"'];
    command3 = [exePath 'uan2txtua3.exe "' datFile '" "' txtUA3File '"'];
    command4 = [exePath 'uan2txtua4.exe "' datFile '" "' txtUA4File '"'];
    command5 = [exePath 'uan2txtua5.exe "' datFile '" "' txtUA5File '"'];
    command6 = [exePath 'uan2txtua6.exe "' datFile '" "' txtUA6File '"'];
    
    % Run the command
    % 如果文件不存在则运行命令
    fileInfo = dir(txtUA1File);
    if isempty(fileInfo)
        % if isempty(fileInfo) || fileInfo.bytes < 5529600
        if showMessages
            disp(['Executing command for: ' txtUA1File]);
        end
        system(command1);
        % break
    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA1File]);
        end
    end

    fileInfo = dir(txtUA2File);
    if isempty(fileInfo)
        % if isempty(fileInfo) || fileInfo.bytes < 5529600
        if showMessages
            disp(['Executing command for: ' txtUA2File]);
        end
        system(command2);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA2File]);
        end
    end
    
    fileInfo = dir(txtUA3File);
    if isempty(fileInfo)
        % if isempty(fileInfo) || fileInfo.bytes < 5529600
        if showMessages
            disp(['Executing command for: ' txtUA3File]);
        end
        system(command3);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA3File]);
        end
    end
    
    fileInfo = dir(txtUA4File);
    if isempty(fileInfo)
    % if isempty(fileInfo) || fileInfo.bytes < 5529600
        if showMessages
            disp(['Executing command for: ' txtUA4File]);
        end
        system(command4);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA4File]);
        end
    end

    fileInfo = dir(txtUA5File);
    if isempty(fileInfo)
        % if isempty(fileInfo) || fileInfo.bytes < 5529600
        if showMessages
            disp(['Executing command for: ' txtUA5File]);
        end
        system(command5);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA5File]);
        end
    end

    fileInfo = dir(txtUA6File);
    % if isempty(fileInfo) || fileInfo.bytes < 5529600
    if isempty(fileInfo)
        if showMessages
            disp(['Executing command for: ' txtUA6File]);
        end
        system(command6);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA6File]);
        end
    end

%     % After running the commands for each file, check their sizes:
% filesToCheck = {txtUA1File, txtUA2File, txtUA3File, txtUA4File, txtUA5File, txtUA6File};
% for idx = 1:length(filesToCheck)
%     currentFile = filesToCheck{idx};
%     while true
%         fileInfo = dir(currentFile);
%         if ~isempty(fileInfo) && fileInfo.bytes == 5529600
%             break; % Exit the while loop if the condition is met
%         else
%             pause(5); % Wait for 5 seconds before checking again
%             disp('pause for 5 seconds')
%         end
%     end
% end

    if showProgressBar
        % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
        updateParallel([], pwd);
    end

end



if showProgressBar
    b.release();
end