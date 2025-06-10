%% write
% 假设每秒采集一次数据，一年总共有 365 天
total_seconds = 365 * 24 * 60 * 60; % 一年秒数

% 生成模拟数据：每秒3维加速度数据和1维风速数据
acceleration_data = rand(total_seconds, 3); % 3维加速度数据
windspeed_data = rand(total_seconds, 1);    % 风速数据

% 定义起始时间
start_time = datetime('2023-01-01 00:00:00');

% 生成相对秒数（从0开始）
elapsed_seconds = (0:total_seconds-1)'; % 每秒一个数据点

% HDF5 文件名
filename = 'sensor_data_with_time.h5';

% 保存起始时间作为HDF5文件的属性
h5create(filename, '/time/elapsed_seconds', size(elapsed_seconds), 'Datatype', 'double');
h5write(filename, '/time/elapsed_seconds', elapsed_seconds);

% 添加起始时间作为文件的属性
h5writeatt(filename, '/', 'start_time', datestr(start_time, 'yyyy-mm-dd HH:MM:SS'));

% 保存加速度数据
h5create(filename, '/acceleration/data', size(acceleration_data), 'ChunkSize', [1e6, 3], 'Deflate', 9);
h5write(filename, '/acceleration/data', acceleration_data);

% 保存风速数据
h5create(filename, '/windspeed/data', size(windspeed_data), 'ChunkSize', [1e6, 1], 'Deflate', 9);
h5write(filename, '/windspeed/data', windspeed_data);

disp('数据已成功保存到 HDF5 文件中。');

%% read
% 从 HDF5 文件中读取起始时间属性
filename = 'sensor_data_with_time.h5';
start_time_str = h5readatt(filename, '/', 'start_time');
start_time = datetime(start_time_str, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

% 读取相对秒数
elapsed_seconds = h5read(filename, '/time/elapsed_seconds');

% 恢复完整的时间戳
time_stamps = start_time + seconds(elapsed_seconds);

% 读取加速度数据
acceleration_data = h5read(filename, '/acceleration/data');

% 读取风速数据
windspeed_data = h5read(filename, '/windspeed/data');

% 打印结果
disp('第一个时间戳:');
disp(time_stamps(1));

disp('最后一个时间戳:');
disp(time_stamps(end));

disp('加速度数据示例:');
disp(acceleration_data(1:5, :));

disp('风速数据示例:');
disp(windspeed_data(1:5));

