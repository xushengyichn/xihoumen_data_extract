
%% write day
clc
clear
close all

% 定义文件夹路径和保存的h5文件名称
folder_path = 'H:\xihoumen_data\2013\wind'; % 替换为您的文件夹路径
h5_filename = 'H:\xihoumen_data\2013\xihoumen2013.h5'; % H5文件的名称

% 检查H5文件是否存在，如果不存在则创建
if ~isfile(h5_filename)
    create_h5_file(h5_filename);
    disp(['H5 文件 ', h5_filename, ' 已创建。']);
end

% 创建 wind 组
group_name = '/wind';  % 定义组名称
if ~is_group_exist(h5_filename, group_name)
    create_h5_group(h5_filename, group_name);
    disp(['组 ', group_name, ' 已创建。']);
end

% 获取文件夹中所有的txt文件
txt_files = dir(fullfile(folder_path, '*.txt'));

% 遍历每个txt文件并逐个写入h5文件中
for i = 1:length(txt_files)
% for i = 17344:length(txt_files)
    % 获取完整的文件路径
    file_path = fullfile(folder_path, txt_files(i).name);
    
    % 读取txt文件的数据 (假设数据是数值型的)
    % file_data = dlmread(file_path);
    try
        file_data = dlmread(file_path);
    catch
        disp(['文件读取出错，跳过文件: ', file_path]);
        continue;  % 跳过当前文件，继续下一个文件的处理
    end
    % 根据文件名生成数据集名称，移除文件扩展名
    [~, dataset_name, ~] = fileparts(txt_files(i).name);
    dataset_path = ['/wind/', dataset_name];  % 数据集路径，放在 wind 组下
    % 
    % % 检查数据集是否已存在
    % if ~is_dataset_exist(h5_filename, dataset_path)
    %     % 如果数据集不存在，创建并写入
        h5create(h5_filename, dataset_path, size(file_data));
    %     disp(['数据集 ', dataset_path, ' 已创建。']);
    % end
    % 
    % 将数据写入到h5文件中的数据集
    h5write(h5_filename, dataset_path, file_data);
    
    % 添加属性（例如：年月日、小时、传感器编号、方向等）
    file_date = dataset_name(1:10);  % 假设文件名的前10个字符是日期信息
    file_hour = dataset_name(12:13); % 假设文件名的第12和13个字符是小时
    sensor_name = dataset_name(end); % 假设文件名的最后一位字符是传感器

    % 添加属性信息
    h5writeatt(h5_filename, dataset_path, 'Date', file_date);       % 添加日期属性
    h5writeatt(h5_filename, dataset_path, 'Hour', file_hour);       % 添加小时属性
    h5writeatt(h5_filename, dataset_path, 'Sensor', sensor_name);   % 添加传感器属性
    h5writeatt(h5_filename, dataset_path, 'Columns', 'Time, North, West, Up'); % 列的方向说明
    h5writeatt(h5_filename, dataset_path, 'Units', 's, m/s, m/s, m/s');  % 每列的单位信息
    
    disp(['文件 ' txt_files(i).name ' 已写入到 H5 文件，并添加了属性。']);
end

disp('所有文件已成功写入 wind 组，并添加了属性。');

% 函数：创建H5文件
function create_h5_file(h5_filename)
    % 创建H5文件
    file_id = H5F.create(h5_filename, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
    H5F.close(file_id);
end

% 函数：检查组是否存在
function exists = is_group_exist(h5_filename, group_name)
    exists = false;
    if isfile(h5_filename)
        info = h5info(h5_filename);
        for i = 1:length(info.Groups)
            if strcmp(info.Groups(i).Name, group_name)
                exists = true;
                return;
            end
        end
    end
end

% 函数：创建组
function create_h5_group(h5_filename, group_name)
    file_id = H5F.open(h5_filename, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
    gid = H5G.create(file_id, group_name, 'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
    H5G.close(gid);
    H5F.close(file_id);
end
% 
% % 函数：检查数据集是否存在（递归遍历组）
% function exists = is_dataset_exist(h5_filename, dataset_path)
%     exists = false;
%     if isfile(h5_filename)
%         info = h5info(h5_filename);
%         exists = check_dataset_in_group(info, dataset_path);
%     end
% end
% 
% % 辅助函数：递归检查组中的数据集
% function exists = check_dataset_in_group(group_info, dataset_path)
%     exists = false;
%     % 检查当前组中的数据集
%     for i = 1:length(group_info.Datasets)
%         if strcmp(['/wind/',group_info.Datasets(i).Name], dataset_path(1:end)) % 去掉 '/' 比较
%             exists = true;
%             return;
%         end
%     end
%     % 如果存在子组，递归遍历子组
%     for j = 1:length(group_info.Groups)
%         exists = check_dataset_in_group(group_info.Groups(j), dataset_path);
%         if exists
%             return;
%         end
%     end
% end


%% read part
