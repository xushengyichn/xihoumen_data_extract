%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: ShengyiXu xushengyichn@outlook.com
%Date: 2023-10-06 23:11:34
%LastEditors: ShengyiXu xushengyichn@outlook.com
%LastEditTime: 2023-10-07 02:01:11
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

            result=cal_wind_propoty(time_series,U_x,U_y,U_z)

        end
    end
end


function [result] = cal_wind_propoty(time,x,y,z)
    outliers_x = isoutlier(x);
    outliers_y = isoutlier(y);
    outliers_z = isoutlier(z);
    x(outliers_x) = NaN;
    y(outliers_y) = NaN;
    z(outliers_z) = NaN;
    x = fillmissing(x,'linear');
    y = fillmissing(y,'linear');
    z = fillmissing(z,'linear');

    U = sqrt(x.^2 + y.^2);

    beta_rad = atan2(-y, x);  % 计算弧度值
    beta_deg = rad2deg(beta_rad);  % 将弧度值转换为度

    beta_deg(beta_deg < 0) = beta_deg(beta_deg < 0) + 360;

    u = x .* cos(beta_rad) + y .* sin(beta_rad);
    v = -x .* sin(beta_rad) + y .* cos(beta_rad);
    w = z;

    alpha_rad = atan2(w, u);  % 计算弧度值
    alpha_deg = rad2deg(alpha_rad);  % 将弧度值转换为度
    alpha_rad_mean = mean(alpha_rad);
    alpha_deg_mean = rad2deg(alpha_rad_mean);

    u_avg = mean(u);         % 平均风速
    sigma_u = std(u);        % u方向的风速标准偏差
    TI_u = sigma_u / u_avg;  % 湍流强度

    v_avg = mean(v);         % 平均风速
    sigma_v = std(v);        % v方向的风速标准偏差
    TI_v = sigma_v / v_avg;  % 湍流强度

    w_avg = mean(w);         % 平均风速
    sigma_w = std(w);        % w方向的风速标准偏差
    TI_w = sigma_w / w_avg;  % 湍流强度


    % 计算自相关函数
    [R_u, lag] = xcorr(u, 'biased');
    [R_v, lag] = xcorr(v, 'biased');
    [R_w, lag] = xcorr(w, 'biased');

    % 只考虑正的滞后值，并归一化自相关函数
    R_u = R_u(lag >= 0);
    R_u = R_u / R_u(1);
    R_v = R_v(lag >= 0);
    R_v = R_v / R_v(1);
    R_w = R_w(lag >= 0);
    R_w = R_w / R_w(1);

    % 使用梯形法进行数值积分
    L_u = trapz(R_u);
    L_v = trapz(R_v);
    L_w = trapz(R_w);


    % 假设x和y是您的风速数据向量
    % bridge是结构的方向，单位是度
    
    bridge = 40; %NOTE:假定
    bridge_rad = deg2rad(bridge); % 将bridge从度转换为弧度

    u_bridge = x .* cos(bridge_rad) + y .* sin(bridge_rad);
    v_bridge = -x .* sin(bridge_rad) + y .* cos(bridge_rad);
    w_bridge = z;

    alpha_bridge_rad = atan2(w_bridge, u_bridge);  % 计算弧度值
    alpha_bridge_rad_mean = mean(alpha_bridge_rad);
    alpha_bridge_deg_mean = rad2deg(alpha_bridge_rad_mean);
    result = 1;
end

    




