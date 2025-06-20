function [result] = cal_wind_property(x,y,z,bridge_deg)

 % 如果没有输入参数，执行以下测试或调试代码
        if nargin == 0
            disp('Running tests...');
    
            clc; clear; close all;

            fs = 32;
            %  create test data
            t = 0:1/fs:10*60-1/fs;
            x = 10*ones(1,length(t))+0.1*randn(1,length(t));
            y = 10*ones(1,length(t))+0.1*randn(1,length(t));
            z = sqrt(10)*ones(1,length(t))+0.1*randn(1,length(t));
            
            bridge_deg = 45;
            result = cal_wind_property(x,y,z,bridge_deg);
            U = result.U;
            beta_deg_mean = result.beta_deg_mean;
            alpha_deg_mean = result.alpha_deg_mean;
            % TI_u = result.TI_u;
            % TI_v = result.TI_v;
            % TI_w = result.TI_w;
            % L_u = result.L_u;
            % L_v = result.L_v;
            % L_w = result.L_w;
            alpha_bridge_deg_mean = result.alpha_bridge_deg_mean;
            u_bridge_mean = result.u_bridge_mean;
            v_bridge_mean = result.v_bridge_mean;
            w_bridge_mean = result.w_bridge_mean;
            
            % display as a table 
            T = table(U, beta_deg_mean, alpha_deg_mean, TI_u, TI_v, TI_w, L_u, L_v, L_w, alpha_bridge_deg_mean, u_bridge_mean, v_bridge_mean, w_bridge_mean);
            disp(T);
            
            % % visualize the wind speed x is north, y is west, z is up
            % figure(1);
            % subplot(3,1,1);
            % plot(t,x);
            % xlabel('time (s)');
            % ylabel('wind speed (m/s)');
            % title('wind speed in x direction');
            % subplot(3,1,2);
            % plot(t,y);
            % xlabel('time (s)');
            % ylabel('wind speed (m/s)');
            % title('wind speed in y direction');
            % subplot(3,1,3);
            % plot(t,z);
            % xlabel('time (s)');
            % ylabel('wind speed (m/s)');
            % title('wind speed in z direction');
            % 

            figure(2);

            % 用quiver3绘制风速向量。考虑到x, y, z都是时间序列数据，这里我们只画一个平均的风速箭头
            quiver3(0, 0, 0, mean(x), mean(y), mean(z), 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5);
            hold on;
            
            % 绘制表示桥方向的线
            bridge_length = 20; % 你可以根据需要设置桥的长度
            half_length = bridge_length / 2; % 桥梁长度的一半
            
            % 计算桥的两个端点
            bridge_x = [half_length * cosd(bridge_deg), -half_length * cosd(bridge_deg)];
            bridge_y = [half_length * sind(-bridge_deg), -half_length * sind(-bridge_deg)];

            
            % 绘制桥梁
            plot3(bridge_x, bridge_y, [0, 0], 'r', 'LineWidth', 2);

            
            xlabel('X (North)');
            ylabel('Y (West)');
            zlabel('Z (Up)');
            title('Wind Speed and Bridge Direction');
            legend('Wind Direction', 'Bridge Direction');
            axis equal;
            grid on;
            xlim([-10, 10]);
            ylim([-10, 10]);
            zlim([-10, 10]);
            
            view(-90, 90);
            disp('Tests completed.');
        end


    % 检查x、y、z是否为空或者全为0
    if isempty(x) || isempty(y) || isempty(z) || (all(x == 0) && all(y == 0) && all(z == 0))
        table_temp = struct('U', NaN, 'beta_deg_mean', NaN, 'alpha_deg_mean', NaN, ...
                        'TI_u', NaN, 'TI_v', NaN, 'TI_w', NaN, 'L_u', NaN, ...
                        'L_v', NaN, 'L_w', NaN, 'alpha_bridge_deg_mean', NaN, ...
                        'u_bridge_mean', NaN, 'v_bridge_mean', NaN, 'w_bridge_mean', NaN, ...
                        'x_mean', NaN, 'y_mean', NaN, 'z_mean', NaN, 'u_mean', NaN, ...
                        'v_mean', NaN, 'w_mean', NaN);

            result.U = table_temp.U;
            result.beta_deg_mean = table_temp.beta_deg_mean;
            result.alpha_deg_mean = table_temp.alpha_deg_mean;
            result.TI_u = table_temp.TI_u;
            result.TI_v = table_temp.TI_v;
            result.TI_w = table_temp.TI_w;
            % result.L_u =table_temp.L_u;
            % result.L_v = table_temp.L_v;
            % result.L_w = table_temp.L_w;
            result.alpha_bridge_deg_mean = table_temp.alpha_bridge_deg_mean;
            result.u_bridge_mean = table_temp.u_bridge_mean;
            result.v_bridge_mean = table_temp.v_bridge_mean;
            result.w_bridge_mean = table_temp.w_bridge_mean;
            result.x_mean = table_temp.x_mean;
            result.y_mean = table_temp.y_mean;
            result.z_mean = table_temp.z_mean;
            result.u_mean = table_temp.u_mean;
            result.v_mean = table_temp.v_mean;
            result.w_mean = table_temp.w_mean;
        return;
    end

    
    outliers_x = isoutlier(x);
    outliers_y = isoutlier(y);
    outliers_z = isoutlier(z);
    x(outliers_x) = NaN;
    y(outliers_y) = NaN;
    z(outliers_z) = NaN;
    x = fillmissing(x,'linear');
    y = fillmissing(y,'linear');
    z = fillmissing(z,'linear');

    x_mean = mean(x);         % 平均风速
    y_mean = mean(y);         % 平均风速
    z_mean = mean(z);         % 平均风速
    
    U = sqrt(x_mean^2 + y_mean^2);  % 风速大小

    % x_mean = mean(x);         % 平均风速
    % y_mean = mean(y);         % 平均风速
    % z_mean = mean(z);         % 平均风速

    beta_rad_mean = atan2(-y_mean, x_mean);  % 计算弧度值
    beta_deg_mean = rad2deg(beta_rad_mean);  % 将弧度值转换为度

    % 如果得到的角度是负值，将其转换为正值
    beta_deg_mean(beta_deg_mean < 0) = beta_deg_mean(beta_deg_mean < 0) + 360;



    u = x .* cos(beta_rad_mean) - y .* sin(beta_rad_mean);
    v = x .* sin(beta_rad_mean) + y .* cos(beta_rad_mean);
    w = z;

    u_mean = mean(u);         % 平均风速
    v_mean = mean(v);         % 平均风速
    w_mean = mean(w);         % 平均风速

    alpha_rad_mean = atan2(mean(w), U);  % 计算弧度值
    alpha_deg_mean = rad2deg(alpha_rad_mean);  % 将弧度值转换为度

    u_avg = mean(u);         % 平均风速
    sigma_u = std(u);        % u方向的风速标准偏差
    TI_u = sigma_u / U;  % 湍流强度

    v_avg = mean(v);         % 平均风速
    sigma_v = std(v);        % v方向的风速标准偏差
    TI_v = sigma_v / U;  % 湍流强度

    w_avg = mean(w);         % 平均风速
    sigma_w = std(w);        % w方向的风速标准偏差
    TI_w = sigma_w / U;  % 湍流强度


    % % 计算自相关函数
    % % 只考虑正的滞后值，并归一化自相关函数
    % [R_u, lag] = xcorr(u, 'biased');
    % R_u = R_u(lag >= 0);
    % R_u = R_u / R_u(1);
    % [R_v, lag] = xcorr(v, 'biased');
    % R_v = R_v(lag >= 0);
    % R_v = R_v / R_v(1);
    % [R_w, lag] = xcorr(w, 'biased');
    % R_w = R_w(lag >= 0);
    % R_w = R_w / R_w(1);
    % 
    % 
    % 
    % % 使用梯形法进行数值积分
    % L_u = trapz(R_u);
    % L_v = trapz(R_v);
    % L_w = trapz(R_w);


    % 假设x和y是您的风速数据向量
    % bridge是结构的方向，单位是度
    
    bridge_deg = bridge_deg; %NOTE:目前是假定的
    bridge_rad = deg2rad(bridge_deg); % 将bridge_deg从度转换为弧度

    u_bridge_mean = x_mean * cos(bridge_rad) + y_mean * sin(bridge_rad);
    v_bridge_mean = -x_mean * sin(bridge_rad) + y_mean * cos(bridge_rad);
    w_bridge_mean = z_mean;

    alpha_bridge_rad_mean = atan2(w_bridge_mean, u_bridge_mean);  % 计算弧度值
    alpha_bridge_deg_mean = rad2deg(alpha_bridge_rad_mean);  % 将弧度值转换为度

    
    result.U = U;
    result.beta_deg_mean = beta_deg_mean;
    result.alpha_deg_mean = alpha_deg_mean;
    result.TI_u = TI_u;
    result.TI_v = TI_v;
    result.TI_w = TI_w;
    % result.L_u = L_u;
    % result.L_v = L_v;
    % result.L_w = L_w;
    result.alpha_bridge_deg_mean = alpha_bridge_deg_mean;
    result.u_bridge_mean = u_bridge_mean;
    result.v_bridge_mean = v_bridge_mean;
    result.w_bridge_mean = w_bridge_mean;
    result.x_mean = x_mean;
    result.y_mean = y_mean;
    result.z_mean = z_mean;
    result.u_mean = u_mean;
    result.v_mean = v_mean;
    result.w_mean = w_mean;
    
   
end



