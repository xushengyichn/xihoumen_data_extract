%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: ShengyiXu xushengyichn@outlook.com
%Date: 2023-10-06 23:11:34
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-08 00:23:21
%FilePath: \Exercises-for-Techniques-for-estimation-in-dynamics-systemsf:\git\xihoumen_data_extract\windspeed\analyze_mat.m
%Description: 
%
%Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% datepath
dataPath = "F:\test\result_wind";

% load data
month = 3;
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

resultsTable = table();




for k1 = 1:num_days
    for k2 = 1:24

        filePath = fullfile(dataPath, fileName{k1, k2});

        % 检查文件是否存在
        if ~exist(filePath, 'file')
            disp(['Warning: File not found - ' filePath]); % 显示警告消息，可以根据需要删除或保留
            continue; % 跳过当前循环迭代
        end


        importedData = load(filePath);
        windData = importedData.mergedData;

        for k3 = 1:num4timeInterval
            baseName = sprintf("%d-%02d-%02d", year, month, k1);
            startTime =  datetime(baseName, 'InputFormat', 'yyyy-MM-dd') + hours(k2-1)+(k3-1)*timeInterval;
            startTime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
            endTime = startTime + timeInterval;
            

            mask = (windData.Time >= startTime) & (windData.Time < endTime);
            segment_temp = windData(mask,:);

            time_series = segment_temp.Time;
            U_x = segment_temp.UA1_x;%north
            U_y = segment_temp.UA1_y;%west
            U_z = segment_temp.UA1_z;%up

            result=cal_wind_property(U_x,U_y,U_z,45);

            tempTable = struct2table(result); % Convert struct result to table
            tempTable.Time_Start = repmat(startTime, size(tempTable, 1), 1); % Add start time column
            tempTable.Time_End = repmat(endTime, size(tempTable, 1), 1); % Add end time column
            % Reorder columns to move Time_Start and Time_End to the front
            reorderedVars = [{'Time_Start', 'Time_End'}, setdiff(tempTable.Properties.VariableNames, {'Time_Start', 'Time_End'})];
            tempTable = tempTable(:, reorderedVars);

            resultsTable = [resultsTable; tempTable]; % Append to the main table
    
        end
    end
end


figure;

subplot(3,1,1);
plot(resultsTable.Time_Start, resultsTable.U, '-');
title('Wind Speed (U) vs. Time');
xlabel('Date');
ylabel('Wind Speed (m/s)');

subplot(3,1,2);
plot(resultsTable.Time_Start, resultsTable.beta_deg_mean, '-');
title('Wind Direction (beta) vs. Time');
xlabel('Date');
ylabel('Direction (Degrees)');

subplot(3,1,3);
plot(resultsTable.Time_Start, resultsTable.alpha_deg_mean, '-');
title('Wind Attack Angle (alpha) vs. Time');
xlabel('Date');
ylabel('Angle (Degrees)');


figure;

scatter(resultsTable.U, resultsTable.alpha_deg_mean, 'o');
title('Wind Speed (U) vs. Wind Attack Angle (alpha)');
xlabel('Wind Speed (m/s)');
ylabel('Wind Attack Angle (Degrees)');

figure;

hist(resultsTable.U, 50); % Using 50 bins for illustration
title('Histogram of Wind Speed (U)');
xlabel('Wind Speed (m/s)');
ylabel('Frequency');

figure;

hist(resultsTable.alpha_bridge_deg_mean, 50); % Using 50 bins for illustration
title('Histogram of AOA');
xlabel('AOA');
ylabel('Frequency');



corrMatrix = corr(resultsTable{:,3:end}); % Assuming the first two columns are dates
imagesc(corrMatrix);
colorbar;
title('Correlation Matrix');
xticks(1:size(resultsTable,2)-2);
yticks(1:size(resultsTable,2)-2);
xticklabels(resultsTable.Properties.VariableNames(3:end));
yticklabels(resultsTable.Properties.VariableNames(3:end));


