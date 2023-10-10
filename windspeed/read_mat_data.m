clc;clear;close all
addpath("F:\git\xihoumen_inverse_force_estimation\20231005 first version")
wind_dir = "F:\test\result_wind_10min";
start_time = datetime('2013-01-01 00:00:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
end_time = datetime('2013-01-30 00:00:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
[Wind_Data] = read_wind_data(start_time, end_time, wind_dir);
t = Wind_Data.resultsTable_UA5.Time_Start;

Ua = Wind_Data.resultsTable_UA3.U;
Ub = Wind_Data.resultsTable_UA4.U;

beta_deg_mean_a = Wind_Data.resultsTable_UA3.beta_deg_mean;
beta_deg_mean_b = Wind_Data.resultsTable_UA4.beta_deg_mean;

alpha_deg_mean_a = Wind_Data.resultsTable_UA3.alpha_deg_mean;
alpha_deg_mean_b = Wind_Data.resultsTable_UA4.alpha_deg_mean;

figure;

subplot(3,1,1);
plot(t, Ua, '-');
hold on
plot(t, Ub, '-');
legend('UA3, 45°-225°', 'UA4, 225°-360°, 0°-45°');
title('Wind Speed (U) vs. Time');
xlabel('Date');
ylabel('Wind Speed (m/s)');

subplot(3,1,2);
plot(t, beta_deg_mean_a, '-');
hold on
plot(t, beta_deg_mean_b, '-');
legend('UA, 45°-225°', 'UA, 225°-360°, 0°-45°');
title('Wind Direction (beta) vs. Time');
xlabel('Date');
ylabel('Direction (Degrees)');

subplot(3,1,3);
plot(t, alpha_deg_mean_a, '-');
hold on
plot(t, alpha_deg_mean_b, '-');
legend('UA, 45°-225°', 'UA, 225°-360°, 0°-45°');
title('Wind Attack Angle (alpha) vs. Time');
xlabel('Date');
ylabel('Angle (Degrees)');


