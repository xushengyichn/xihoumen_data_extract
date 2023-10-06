clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))

% datepath
dataPath = "F:\test\result_wind";
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

% 初始化一个 cell 数组来存储每天的数据
dailyDataTables = cell(num_days, 1);
dailyDataDurations = hours(0) + minutes(0) + seconds(0);
dailyDataDurations = repmat(dailyDataDurations, num_days,1);

fs = 32; % 采样频率

for k1 = 1:num_days
    dailyTable = table(); % 每天初始化一个空表格
    
    for k2 = 1:24
        % 检查数据是否存在并读取数据
        filePath = fullfile(dataPath, fileName{k1, k2});
        if isfile(filePath)
            loadedData = load(filePath);
            dataLength_temp(k2) = seconds(length(loadedData.mergedData.Time)/fs);
            if height(loadedData.mergedData) > 0
                loadedData.mergedData = downsample(loadedData.mergedData, 10000);
            end
            % 确保mergedData字段存在于loadedData结构中
            if isfield(loadedData, 'mergedData')
                % 垂直连接到当天的表格
                dailyTable = [dailyTable; loadedData.mergedData];
            end
        else
            dataLength_temp(k2) = seconds(0);
        end
    end
    dailyDataDurations(k1) = sum(dataLength_temp);
    
    % 存储当天的表格到 cell 数组中
    dailyDataTables{k1} = dailyTable;
end


% axHandles = create_calendar(2023, 9);
plotFns = cell(num_days, 1); 

for k1 = 1:num_days
    if ~isempty(dailyDataTables{k1})
        % Assuming you want to plot AC2_1 and AC2_2 columns for each day
        timeSeries = dailyDataTables{k1}.Time;
        yData1 = dailyDataTables{k1}.UA6_y;

        plotFns{k1} = {
            @(ax) scatter(ax,timeSeries,yData1), ...
        };
    end
end


additionalText = string(dailyDataDurations);

axHandles = create_calendar(year, month, plotFns,additionalText);

toc

set(gcf, 'unit', 'centimeters', 'position', [5 5 40 30]);

outputDir = 'F:\git\xihoumen_data_extract\images'; % 您想保存的目录
outputFileName = sprintf('Winddata for %d-%02d.png', year, month);
fullOutputPath = fullfile(outputDir, outputFileName);
print(gcf, fullOutputPath, '-r300', '-dpng');


% print(gcf, sprintf('Winddata for %d-%02d', year, month),'-r300','-dpng');
% exportgraphics(gcf, 'test2.png','Resolution',300);
% copygraphics(gcf)


function axHandles = create_calendar(year, month, plotFunctions,additionalText)
    % Input validation
    if month < 1 || month > 12
        error('Month should be between 1 and 12');
    end

    % Check if additionalText was provided, if not set a default
    if nargin < 4
        additionalText = [];
    end

    % Find the number of days in the given month
    num_days = eomday(year, month);

    % Find the day of the week for the 1st of the month
    first_day = weekday(datetime(year, month, 1));
    
    % Create a figure
    % fig = figure('Name', sprintf('Calendar for %d-%02d', year, month), 'NumberTitle', 'off', 'units', 'normalized', 'outerposition', [0 0 1 1], 'Color', [1 1 1]);
    fig = figure('Name', sprintf('Calendar for %d-%02d', year, month), ...
                 'NumberTitle', 'off', ...
                 'units', 'centimeters', ...
                 'Position', [5 5 40 30], ...
                 'Color', [1 1 1]);

    % Days of the week
    days_of_week = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'};
    
    % Define the dimensions for the subplots
    width = 1/7;
    num_weeks = ceil((num_days + first_day - 1) / 7);
    subplot_height = 0.88 / num_weeks;
    height_offset = 1 - 0.07 - subplot_height * num_weeks;
    
    % Initialize matrix to store axis handles
    axHandles = gobjects(num_days, 1);
    
    % Place the days of the week above each column
    for i = 1:7
        annotation(fig, 'textbox', [(i-1)*width, height_offset + subplot_height*num_weeks, width, 0.02], ...
            'String', days_of_week{i}, ...
            'FontSize', 12, 'FontWeight', 'bold', ...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle');
    end

    % Loop over all the days in the month
    for day = 1:num_days
        % Calculate subplot position
        week_num = ceil((day + first_day - 1) / 7);
        day_num = mod(day + first_day - 2, 7) + 1;

        % Calculate the position of the subplot
        left = (day_num - 1) * width;
        bottom = height_offset + (num_weeks - week_num) * subplot_height;
        
        % Create axes for the day
        ax = axes('Position', [left bottom width subplot_height]);

        % Set explicit axis limits
        % xlim(ax, [0, 1]);
        ylim(ax, [-15, 15]);
        
        % % Execute plotting function if provided
        % if day <= length(plotFunctions) && ~isempty(plotFunctions{day})
        %     plotFunction = plotFunctions{day};
        %     plotFunction(ax);
        % end

        % Execute plotting function if provided and if data exists
        if day <= length(plotFunctions) && ~isempty(plotFunctions{day})
            hold(ax, 'on'); % Hold the current plots
            for k = 1:length(plotFunctions{day})
                plotFunction = plotFunctions{day}{k};
                plotFunction(ax);
            end
            hold(ax, 'off'); % Release the hold after plotting all datasets for the day
        end
        % Store the axis handle
        axHandles(day) = ax;
        
        % Set properties for the axes (without plotting any data)
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'on', 'LineWidth', 0.5, 'XColor', [0.7 0.7 0.7], 'YColor', [0.7 0.7 0.7]);

        % Place the day at the top left side of the subplot
        % text(ax, 0.02, 0.98, sprintf('%d', day), 'VerticalAlignment', 'top', 'FontSize', 10);
        % This is your current position calculation for the axes
        left = (day_num - 1) * width;
        bottom = height_offset + (num_weeks - week_num) * subplot_height;
        
        % Use the following to position the day number using annotation
        dayPosition = [left + 0.002, bottom + subplot_height - 0.05, 0.05, 0.05];
        annotation(fig, 'textbox', dayPosition, 'String', sprintf('%d', day), ...
            'VerticalAlignment', 'top', ...
            'HorizontalAlignment', 'left', ...
            'EdgeColor', 'none', ...
            'FontSize', 10.5, ...
            'BackgroundColor', 'none');


        if ~isempty(additionalText)
            textPosition = [left + 0.002, bottom + subplot_height - 0.08, 0.05, 0.05];
            annotation(fig, 'textbox', textPosition, ...
                'String', additionalText(day), ...
                'VerticalAlignment', 'top', ...
                'HorizontalAlignment', 'left', ...
                'EdgeColor', 'none', ...
                'FontSize', 10.5, ...
                'BackgroundColor', 'none');
        end
    end

    % Add centralized title with the month and year
    monthNames = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};
    mainTitle = sprintf('%s %d', monthNames{month}, year);
    annotation(fig,'textbox', [0.3, 1-0.03, 0.4, 0.03], 'String', mainTitle, 'FontSize', 18, 'FontWeight', 'bold', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');

    % Return the axis handles at the end of the function
    % axHandles = flipud(axHandles); % To make sure the order is correct

end



