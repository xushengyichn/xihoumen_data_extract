% 用法示例
% 用法示例
h5_filename = 'D:\xihoumen_data\2011\xihoumen2011.h5';  % 替换为您的H5文件路径
group_name = '/wind';  % wind组路径
start_time_str = '2011-04-01 00:00:00';  % 起始时间
end_time_str = '2011-04-02 00:15:00';    % 结束时间
sensor_id = 1;  % 选择传感器编号

% 调用函数提取数据
filtered_data = extract_data_by_time(h5_filename, group_name, start_time_str, end_time_str, sensor_id);

function filtered_data = extract_data_by_time(h5_filename, group_name, start_time_str, end_time_str, sensor_id)
    % 输入的时间格式为 'yyyy-MM-dd HH:mm:ss'
    start_time = datetime(start_time_str, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    end_time = datetime(end_time_str, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

    % 初始化空表格存放合并后的数据
    filtered_data = table();

    % 推测传感器数据集的命名规则，构造可能的日期时间范围
    time_interval = start_time:hours(1):end_time;  % 逐小时生成日期时间范围

    % 遍历生成的时间范围，拼接出可能的数据集路径
    for t = time_interval
        % 构造数据集的名称（假设文件名格式为 'yyyy-MM-dd HH-UAx'）
        dataset_name = [datestr(t, 'yyyy-mm-dd HH'), '-UAN-UA', num2str(sensor_id)];
        dataset_path = [group_name, '/', dataset_name];  % 构造完整路径

        % 尝试直接读取数据集，避免加载整个 H5 文件
        try
            % 读取数据集
            data = h5read(h5_filename, dataset_path);
            attribute_name = 'Columns';  % 属性名称
            column_names = h5readatt(h5_filename, dataset_path,attribute_name);
            column_names = strsplit(column_names, ', ');  % 将属性值分割成单元数组
            
            % 提取数据集的日期时间
            file_datetime = t;  % 因为我们根据日期时间生成的路径，所以直接使用 t
            
            % 获取每行数据中的秒数（第一列为时间）
            time_column = data(:, 1);
            full_time_column = file_datetime + seconds(time_column);  % 将秒数转为完整的 datetime 时间

            % 设置 datetime 格式，显示毫秒
            full_time_column.Format = 'yyyy-MM-dd HH:mm:ss.SSS';

            % 根据输入的起止时间筛选数据
            valid_rows = full_time_column >= start_time & full_time_column <= end_time;
            filtered_rows = data(valid_rows, :);

            % 创建临时表格，包含时间列和其他数据列
                temp_table = table(full_time_column(valid_rows), filtered_rows(:, 2), ...
                                   filtered_rows(:, 3), filtered_rows(:, 4), ...
                                   'VariableNames', column_names);

            % 合并数据
            filtered_data = [filtered_data; temp_table];
        catch
            % 如果路径不存在，跳过该时间段
            disp(['数据集 ', dataset_name, ' 不存在，跳过']);
        end
    end

    % 最后按时间列排序，确保输出数据按时间顺序排列
    if ~isempty(filtered_data)
        filtered_data = sortrows(filtered_data, 'Time');
    end
end
