clc;clear; close all
addpath(genpath("C:\Users\shengyix\Documents\GitHub\Function_shengyi_package"))



create_calendar(2023,9)


function create_calendar(year, month)
    % Input validation
    if month < 1 || month > 12
        error('Month should be between 1 and 12');
    end

    % Find the number of days in the given month
    num_days = eomday(year, month);

    % Find the day of the week for the 1st of the month
    first_day = weekday(datetime(year, month, 1));
    
    % Create a figure
    fig = figure('Name', sprintf('Calendar for %d-%02d', year, month), 'NumberTitle', 'off', 'units', 'normalized', 'outerposition', [0 0 1 1], 'Color', [1 1 1]);

    % Days of the week
    days_of_week = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'};
    
    % Define the dimensions for the subplots
    width = 1/7;
    num_weeks = ceil((num_days + first_day - 1) / 7);
    subplot_height = 0.88 / num_weeks;
    height_offset = 1 - 0.07 - subplot_height * num_weeks;
    
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
        
        % Plot a simple curve (modify this part to plot your data)
        plot(ax, sin(0:0.1:2*pi), 'LineWidth', 1.5);
        
        % Remove x and y ticks
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'on', 'LineWidth', 0.5, 'XColor', [0.7 0.7 0.7], 'YColor', [0.7 0.7 0.7]);

        % Place the day at the top left side of the subplot
        text(ax, 0.02, 0.98, sprintf('%d', day), 'VerticalAlignment', 'top', 'FontSize', 10);
    end

    % Add centralized title with the month and year
    monthNames = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};
    mainTitle = sprintf('%s %d', monthNames{month}, year);
    annotation(fig,'textbox', [0.3, 1-0.03, 0.4, 0.03], 'String', mainTitle, 'FontSize', 18, 'FontWeight', 'bold', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');
end
