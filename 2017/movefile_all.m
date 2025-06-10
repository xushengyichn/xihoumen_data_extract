clc
clear
close all

% 源文件夹路径
dataPath = 'I:\1\data\2017\';
% 输出文件夹路径
outputPath = 'I:\2017\';

% 获取所有文件夹中的文件
fileList = dir(fullfile(dataPath, '**', '*'));  % 获取所有子文件夹中的文件
fileList = fileList(~[fileList.isdir]);  % 排除子文件夹，只保留文件

% 定义文件类型标识符
fileIdentifiers = {'CFT', 'DPM', 'GPS', 'RHS', 'RSG', 'TLT', 'TMP', 'UAN', 'ULT', 'VIB', 'VIC'};

% 循环处理每个文件
for i = 1:length(fileList)
    fileName = fileList(i).name;
    filePath = fullfile(fileList(i).folder, fileName);
    
    % 找到文件名中的标识符
    for j = 1:length(fileIdentifiers)
        if contains(fileName, fileIdentifiers{j})
            % 创建目标文件夹
            targetFolder = fullfile(outputPath, fileIdentifiers{j});
            if ~exist(targetFolder, 'dir')
                mkdir(targetFolder);  % 如果文件夹不存在，创建它
            end
            
            % 移动文件到相应的目标文件夹
            movefile(filePath, targetFolder);
            fprintf('文件 "%s" 已移动到文件夹 "%s"\n', fileName, targetFolder);
            break;  % 一旦找到匹配的标识符，跳出循环
        end
    end
end
