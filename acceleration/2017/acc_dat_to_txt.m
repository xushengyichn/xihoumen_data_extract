%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: xushengyichn 54436848+xushengyichn@users.noreply.github.com
%Date: 2023-10-04 22:13:37
%LastEditors: Shengyi Xu 54436848+xushengyichn@users.noreply.github.com
%LastEditTime: 2024-10-13 18:23:29
%FilePath: \xihoumen_data_extract\acceleration\2011\acc_dat_to_txt.m
%Description: 将dat文件转换为txt文件
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("D:\Github\Function_shengyi_package"))

% 定义路径


dataPath = 'I:\2017\VIB\';
exePath = 'H:\exe\';
outputPath = 'H:\xihoumen_data\2017\acc\';

% set if showing the message
showMessages = true;

% whether to show parfor progress bar
showProgressBar = false;

% Get the file list of dat files
fileList = dir([dataPath '*-VIB.dat']);


numIterations = length(fileList);

% if showProgressBar
%     if isempty(gcp('nocreate'))
%         parpool();
%     end

%     b = ProgressBar(numIterations, ...
%         'IsParallel', true, ...
%         'WorkerDirectory', pwd(), ...
%         'Title', 'Parallel 2' ...
%         );
%     b.setup([], [], []);
% end

% for loop
% for  k1 = 1
for  k1 = 1:numIterations
    % Get the file name
    datFile = [dataPath fileList(k1).name];

    % Construct the output filename
    % remove extension
    [~,baseName,~] = fileparts(datFile);
    % baseName='2013-01-19 21-UAN';
    txtac2File = [outputPath baseName '-ac2.txt'];
    txtac3File = [outputPath baseName '-ac3.txt'];
    txtac4File = [outputPath baseName '-ac4.txt'];

    % Construct the command
    command1 = [exePath 'vib2txtac2.exe "' datFile '" "' txtac2File '"'];
    command2 = [exePath 'vib2txtac3.exe "' datFile '" "' txtac3File '"'];
    command3 = [exePath 'vib2txtac4.exe "' datFile '" "' txtac4File '"'];
    
    % Run the command
    % 如果文件不存在则运行命令
    fileInfo = dir(txtac2File);
    if isempty(fileInfo)
        if showMessages
            disp(['Executing command for: ' txtac2File]);
        end
        system(command1);
        % break
    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA1File]);
        end
    end

    fileInfo = dir(txtac3File);
    if isempty(fileInfo)
        if showMessages
            disp(['Executing command for: ' txtac3File]);
        end
        system(command2);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA2File]);
        end
    end
    
    fileInfo = dir(txtac4File);
    if isempty(fileInfo)
        if showMessages
            disp(['Executing command for: ' txtac4File]);
        end
        system(command3);

    else
        if showMessages
            % disp(['Skipping existing file: ' txtUA3File]);
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

    % if showProgressBar
    %     % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    %     updateParallel([], pwd);
    % end

end



% if showProgressBar
%     b.release();
% end