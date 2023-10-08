%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: ShengyiXu xushengyichn@outlook.com
%Date: 2023-10-06 23:11:34
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-08 10:36:21
%FilePath: \Exercises-for-Techniques-for-estimation-in-dynamics-systemsf:\git\xihoumen_data_extract\windspeed\analyze_mat.m
%Description: 
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% datepath
dataPath = "F:\test\result_wind";
outputPath = "F:\test\result_wind_10min";

% load data
month = 1;
year = 2013;

for month_k =3:12
    month = month_k
    year = 2013;
tic
% Find the number of days in the given month
num_days = eomday(year, month);

fileName = cell(num_days, 24); % Initialize a cell array


for k1 = 1:num_days
    baseName = sprintf("%d-%02d-%02d", year, month, k1);
    for k2 = 1:24
        % file name like this 2013-01-01 00.mat
        fileName{k1,k2}= sprintf("%s %02d-UANua.mat", baseName, k2-1);
    end
end




timeInterval = minutes(10);
num4timeInterval = floor(minutes(60)/timeInterval);

resultsTable_UA1 = table();
resultsTable_UA2 = table();
resultsTable_UA3 = table();
resultsTable_UA4 = table();
resultsTable_UA5 = table();
resultsTable_UA6 = table();



% for k1 = 22
for k1 = 1:num_days
    baseName = sprintf("%d-%02d-%02d", year, month, k1);
    for k2 = 1:24
    % for k2 = 15

        filePath = fullfile(dataPath, fileName{k1, k2});

        % 检查文件是否存在
        if ~exist(filePath, 'file')
            disp(['Warning: File not found - ' filePath]); % 显示警告消息，可以根据需要删除或保留
            continue; % 跳过当前循环迭代
        end


        importedData = load(filePath);
        windData = importedData.mergedData;

        for k3 = 1:num4timeInterval
        % for k3 = 4
            startTime =  datetime(baseName, 'InputFormat', 'yyyy-MM-dd') + hours(k2-1)+(k3-1)*timeInterval;
            startTime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
            endTime = startTime + timeInterval;
            

            mask = (windData.Time >= startTime) & (windData.Time < endTime);
            segment_temp = windData(mask,:);

            time_series = segment_temp.Time;
            U_x_1 = segment_temp.UA1_x;%north
            U_y_1 = segment_temp.UA1_y;%west
            U_z_1 = segment_temp.UA1_z;%up

            U_x_2 = segment_temp.UA2_x;%north
            U_y_2 = segment_temp.UA2_y;%west
            U_z_2 = segment_temp.UA2_z;%up

            U_x_3 = segment_temp.UA3_x;%north
            U_y_3 = segment_temp.UA3_y;%west
            U_z_3 = segment_temp.UA3_z;%up

            U_x_4 = segment_temp.UA4_x;%north
            U_y_4 = segment_temp.UA4_y;%west
            U_z_4 = segment_temp.UA4_z;%up

            U_x_5 = segment_temp.UA5_x;%north
            U_y_5 = segment_temp.UA5_y;%west
            U_z_5 = segment_temp.UA5_z;%up

            U_x_6 = segment_temp.UA6_x;%north
            U_y_6 = segment_temp.UA6_y;%west
            U_z_6 = segment_temp.UA6_z;%up

            % UA3是靠南安装的（假定西堠门桥45°走向，测量风向为45°-225°），UA4是靠北安装的（假定西堠门桥45°走向，测量风向为225°-360°，0°-45°）

            result_1=cal_wind_property(U_x_1,U_y_1,U_z_1,45);
            tempTable_1 = struct2table(result_1); % Convert struct result to table
            tempTable_1.Time_Start = repmat(startTime, size(tempTable_1, 1), 1); % Add start time column
            tempTable_1.Time_End = repmat(endTime, size(tempTable_1, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_1.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_1 = tempTable_1(:, reorderedVars);
            resultsTable_UA1 = [resultsTable_UA1; tempTable_1]; % Append to the main table

            result_2=cal_wind_property(U_x_2,U_y_2,U_z_2,45);
            tempTable_2 = struct2table(result_2); % Convert struct result to table
            tempTable_2.Time_Start = repmat(startTime, size(tempTable_2, 1), 1); % Add start time column
            tempTable_2.Time_End = repmat(endTime, size(tempTable_2, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_2.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_2 = tempTable_2(:, reorderedVars);
            resultsTable_UA2 = [resultsTable_UA2; tempTable_2]; % Append to the main table

            result_3=cal_wind_property(U_x_3,U_y_3,U_z_3,45);
            tempTable_3 = struct2table(result_3); % Convert struct result to table
            tempTable_3.Time_Start = repmat(startTime, size(tempTable_3, 1), 1); % Add start time column
            tempTable_3.Time_End = repmat(endTime, size(tempTable_3, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_3.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_3 = tempTable_3(:, reorderedVars);
            resultsTable_UA3 = [resultsTable_UA3; tempTable_3]; % Append to the main table

            result_4=cal_wind_property(U_x_4,U_y_4,U_z_4,45);
            tempTable_4 = struct2table(result_4); % Convert struct result to table
            tempTable_4.Time_Start = repmat(startTime, size(tempTable_4, 1), 1); % Add start time column
            tempTable_4.Time_End = repmat(endTime, size(tempTable_4, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_4.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_4 = tempTable_4(:, reorderedVars);
            resultsTable_UA4 = [resultsTable_UA4; tempTable_4]; % Append to the main table

            result_5=cal_wind_property(U_x_5,U_y_5,U_z_5,45);
            tempTable_5 = struct2table(result_5); % Convert struct result to table
            tempTable_5.Time_Start = repmat(startTime, size(tempTable_5, 1), 1); % Add start time column
            tempTable_5.Time_End = repmat(endTime, size(tempTable_5, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_5.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_5 = tempTable_5(:, reorderedVars);
            resultsTable_UA5 = [resultsTable_UA5; tempTable_5]; % Append to the main table

            result_6=cal_wind_property(U_x_6,U_y_6,U_z_6,45);
            tempTable_6 = struct2table(result_6); % Convert struct result to table
            tempTable_6.Time_Start = repmat(startTime, size(tempTable_6, 1), 1); % Add start time column
            tempTable_6.Time_End = repmat(endTime, size(tempTable_6, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable_6.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable_6 = tempTable_6(:, reorderedVars);
            resultsTable_UA6 = [resultsTable_UA6; tempTable_6]; % Append to the main table

    
        end
    end
end

% 定义文件名
outputFileName = sprintf('%s_results_%d_%02d_10min.mat', 'windData', year, month);

% 合并所有的resultsTable
allResults = struct();
allResults.resultsTable_UA1 = resultsTable_UA1;
allResults.resultsTable_UA2 = resultsTable_UA2;
allResults.resultsTable_UA3 = resultsTable_UA3;
allResults.resultsTable_UA4 = resultsTable_UA4;
allResults.resultsTable_UA5 = resultsTable_UA5;
allResults.resultsTable_UA6 = resultsTable_UA6;

% 保存到指定的.mat文件中
save(fullfile(outputPath, outputFileName), '-struct', 'allResults');

disp(['Data saved to: ' fullfile(outputPath, outputFileName)]);
toc
end
% 
% 
% figure;
% 
% subplot(4,1,1);
% plot(resultsTable_UA1.Time_Start, resultsTable_UA1.U, '-');
% hold on
% plot(resultsTable_UA2.Time_Start, resultsTable_UA2.U, '-');
% legend('UA3, 45°-225°', 'UA4, 225°-360°, 0°-45°');
% title('Wind Speed (U) vs. Time');
% xlabel('Date');
% ylabel('Wind Speed (m/s)');
% 
% subplot(4,1,2);
% plot(resultsTable_UA1.Time_Start, resultsTable_UA1.beta_deg_mean, '-');
% hold on
% plot(resultsTable_UA2.Time_Start, resultsTable_UA2.beta_deg_mean, '-');
% legend('UA3, 45°-225°', 'UA4, 225°-360°, 0°-45°');
% title('Wind Direction (beta) vs. Time');
% xlabel('Date');
% ylabel('Direction (Degrees)');
% 
% subplot(4,1,3);
% plot(resultsTable_UA1.Time_Start, resultsTable_UA1.alpha_deg_mean, '-');
% hold on
% plot(resultsTable_UA2.Time_Start, resultsTable_UA2.alpha_deg_mean, '-');
% legend('UA3, 45°-225°', 'UA4, 225°-360°, 0°-45°');
% title('Wind Attack Angle (alpha) vs. Time');
% xlabel('Date');
% ylabel('Angle (Degrees)');
% 
% subplot(4,1,4);
% plot(resultsTable_UA1.Time_Start, resultsTable_UA1.z_mean, '-');
% hold on
% plot(resultsTable_UA2.Time_Start, resultsTable_UA2.z_mean, '-');
% legend('UA3, 45°-225°', 'UA4, 225°-360°, 0°-45°');
% title('Wind speed in z direction (z) vs. Time');
% xlabel('Date');
% ylabel('Wind speed (m/s)');
% 


% figure;

% scatter(resultsTable_UA1.U, resultsTable_UA1.alpha_deg_mean, 'o');
% title('Wind Speed (U) vs. Wind Attack Angle (alpha)');
% xlabel('Wind Speed (m/s)');
% ylabel('Wind Attack Angle (Degrees)');

% figure;

% hist(resultsTable_UA1.U, 50); % Using 50 bins for illustration
% title('Histogram of Wind Speed (U)');
% xlabel('Wind Speed (m/s)');
% ylabel('Frequency');

% figure;

% hist(resultsTable_UA1.alpha_bridge_deg_mean, 50); % Using 50 bins for illustration
% title('Histogram of AOA');
% xlabel('AOA');
% ylabel('Frequency');


% 
% corrMatrix = corr(resultsTable{:,3:end}); % Assuming the first two columns are dates
% imagesc(corrMatrix);
% colorbar;
% title('Correlation Matrix');
% xticks(1:size(resultsTable,2)-2);
% yticks(1:size(resultsTable,2)-2);
% xticklabels(resultsTable.Properties.VariableNames(3:end));
% yticklabels(resultsTable.Properties.VariableNames(3:end));
% 

