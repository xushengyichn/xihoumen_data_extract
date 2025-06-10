clc
clear
close all

h5_filename = 'H:\xihoumen_data\2014\xihoumen2014.h5';  % 替换为您的H5文件路径

output_filename = 'H:\xihoumen_data\2014\xihoumen2014_h5_directory.txt';  % 输出文本文件路径

% 导出目录
export_h5_directory(h5_filename, output_filename);



function export_h5_directory(h5_filename, output_filename)
    % 获取 HDF5 文件的结构信息
    info = h5info(h5_filename);
    
    % 打开文本文件，用于写入目录信息
    fid = fopen(output_filename, 'w');
    
    % 递归遍历 HDF5 文件的结构，写入到文件
    fprintf(fid, 'HDF5 File: %s\n\n', h5_filename);
    traverse_h5_structure(fid, info, '/');
    
    % 关闭文件
    fclose(fid);
    disp(['HDF5 目录导出完成，保存到: ', output_filename]);
end

% 辅助函数：递归遍历组和数据集
function traverse_h5_structure(fid, group_info, group_path)
    % 遍历当前组中的数据集
    for i = 1:length(group_info.Datasets)
        dataset_name = group_info.Datasets(i).Name;
        fprintf(fid, 'Dataset: %s/%s\n', group_path, dataset_name);
    end
    
    % 递归遍历当前组中的子组
    for j = 1:length(group_info.Groups)
        subgroup_name = group_info.Groups(j).Name;
        subgroup_path = [group_path, '/', subgroup_name];
        fprintf(fid, 'Group: %s\n', subgroup_path);
        % 递归处理子组
        traverse_h5_structure(fid, group_info.Groups(j), subgroup_path);
    end
end
