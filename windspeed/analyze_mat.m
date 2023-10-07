%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: ShengyiXu xushengyichn@outlook.com
%Date: 2023-10-06 23:11:34
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-07 10:21:48
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
month = 1;
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


filePath = fullfile(dataPath, fileName{1, 1});

% load data

importedData = load(filePath);
windData = importedData.mergedData;
timeInterval = minutes(10);
num4timeInterval = floor(minutes(60)/timeInterval);
for k1 = 1:num_days
    for k2 = 1:24
        for k3 = 1:num4timeInterval
            baseName = sprintf("%d-%02d-%02d", year, month, k1);
            startTime =  datetime(baseName, 'InputFormat', 'yyyy-MM-dd') + (k3-1)*timeInterval;
            startTime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
            endTime = startTime + timeInterval;
            

            mask = (windData.Time >= startTime) & (windData.Time < endTime);
            segment_temp = windData(mask,:);

            time_series = segment_temp.Time;
            U_x = segment_temp.UA1_x;%north
            U_y = segment_temp.UA1_y;%west
            U_z = segment_temp.UA1_z;%up

            result=cal_wind_property(U_x,U_y,U_z);

        end
    end
end




    




