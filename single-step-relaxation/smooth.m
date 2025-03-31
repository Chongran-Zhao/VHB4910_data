% 数据读取
clc;clear;close all
ii = 2;
input_dir = './original_data/';
output_dir = './time_strain_stress/';

input_file_list = {
    '1d5.csv', ... % 1
    '2d0.csv', ... % 2
    '2d5.csv', ... % 3
    '3d0.csv', ... % 4
    '3d5.csv', ... % 5
    '4d0.csv', ... % 6
    '5d0.csv', ... % 7
    '6d0.csv', ... % 8
    };
output_file_list = {
    '1d5.xlsx', ... % 1
    '2d0.xlsx', ... % 2
    '2d5.xlsx', ... % 3
    '3d0.xlsx', ... % 4
    '3d5.xlsx', ... % 5
    '4d0.xlsx', ... % 6
    '5d0.xlsx', ... % 7
    '6d0.xlsx', ... % 8
    };
loading_rate = 0.25;

input_filename = fullfile(input_dir, input_file_list{ii});
output_filename = fullfile(output_dir, output_file_list{ii});

data = readmatrix(input_filename);
time = data(:,1);
force = data(:,3);

% 确定峰值位置
[~, peak_idx] = max(force);
peak_time = time(peak_idx);

% 分块参数配置
sg_window_sizes = [15, 150];    % SG滤波窗口[上升段，下降段]
sg_order = 2;                 % SG多项式阶数
ma_window_sizes = [5, 15];     % 移动平均窗口[上升段，下降段]

% 分块处理
blocks = {force(1:peak_idx), force(peak_idx+1:end)};
sg_blocks = cell(size(blocks));  % SG滤波结果
ma_blocks = cell(size(blocks));  % 最终结果

for i = 1:numel(blocks)
    current_block = blocks{i};
    N = length(current_block);
    
    %% 第一阶段：Savitzky-Golay滤波
    valid_sg_window = min(sg_window_sizes(i), N);
    valid_sg_window = valid_sg_window - mod(valid_sg_window,2) + 1;
    sg_smoothed = sgolayfilt(current_block, sg_order, valid_sg_window);
    sg_smoothed([1, end]) = current_block([1, end]);
    sg_blocks{i} = sg_smoothed;
    
    %% 第二阶段：移动平均
    valid_ma_window = min(ma_window_sizes(i), N);
    valid_ma_window = valid_ma_window - mod(valid_ma_window,2) + 1;
    ma_smoothed = smoothdata(sg_smoothed, 'movmean', valid_ma_window);
    ma_smoothed([1, end]) = current_block([1, end]);
    ma_blocks{i} = ma_smoothed;
end

% 合并各阶段结果
sg_force = [sg_blocks{1}; sg_blocks{2}];
final_force = [ma_blocks{1}; ma_blocks{2}];

%% 数据输出处理
% 筛选0-400秒数据
valid_indices = time >= 0 & time <= 400;
time_sub = time(valid_indices);
force_sub = final_force(valid_indices);

% 计算采样参数
original_dt = mean(diff(time_sub));
target_dt = 0.5;
n = round(target_dt / original_dt);
n = max(n, 1);

% 生成输出数据
output_idx = 1:n:length(time_sub);
output_table = table(...
    time_sub(output_idx),...
    force_sub(output_idx),...
    'VariableNames', {'Time_s', 'SmoothedForce_N'}...
);

% 分块处理新增列
is_rising = output_table.Time_s <= peak_time;
output_rising = output_table(is_rising, :);
output_falling = output_table(~is_rising, :);

% 处理上升段数据
output_rising.CalculatedValue = 1 + loading_rate * output_rising.Time_s;
output_rising.AdjustedForce = output_rising.SmoothedForce_N / 22 * 1000;

% 处理下降段数据
max_rising_value = max(output_rising.CalculatedValue);
output_falling.CalculatedValue = repmat(max_rising_value, height(output_falling), 1);
output_falling.AdjustedForce = output_falling.SmoothedForce_N / 22 * 1000;

% 重排列顺序并合并
output_rising = output_rising(:, {'Time_s', 'CalculatedValue', 'AdjustedForce'});
output_falling = output_falling(:, {'Time_s', 'CalculatedValue', 'AdjustedForce'});
combined_output = [output_rising; output_falling];  % 合并数据

% 保存合并结果
writetable(combined_output, output_filename);

%% 增强可视化
figure('Position', [100 100 1200 800], 'Color', 'w')
hold on

% 绘制原始数据
h_raw = plot(time_sub, force(valid_indices),...
    'Color', [0.2 0.4 0.8 0.3], 'LineWidth', 1.2,...
    'DisplayName', 'Raw Data');

% 绘制SG滤波结果
h_sg = plot(time_sub, sg_force(valid_indices),...
    'Color', [0 0.6 0.2], 'LineWidth', 2.5,...
    'LineStyle', '--', 'DisplayName', 'SG Filtered');

% 绘制最终结果
h_ma = plot(time_sub, final_force(valid_indices),...
    'Color', [1 0.2 0.1], 'LineWidth', 2.8,...
    'DisplayName', 'SG+MA Processed');

% 采样点标记
scatter(output_table.Time_s, output_table.SmoothedForce_N, 70,...
    'Marker', '^', 'MarkerFaceColor', [0.5 0 0.8],...
    'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.7,...
    'DisplayName', 'Sampled Points');

% 图形装饰
set(gca, 'FontSize', 12, 'LineWidth', 1.2)
grid on
xlabel('Time (s)', 'FontSize', 14)
ylabel('Force (N)', 'FontSize', 14)
title(sprintf('Dual-stage Smoothing Process\nSG Windows: [%d, %d] | MA Windows: [%d, %d]',...
    sg_window_sizes(1), sg_window_sizes(2),...
    ma_window_sizes(1), ma_window_sizes(2)),...
    'FontSize', 16, 'FontWeight', 'bold')
legend('Location', 'northwest', 'FontSize', 12)
xlim([0 8])
ylim([min(final_force(valid_indices))*0.95 max(final_force(valid_indices))*1.05])

% 添加参数标注
annotation('textbox', [0.18 0.78 0.2 0.12],...
    'String', sprintf('SG Order: %d\nPeak Time: %.1fs', sg_order, peak_time),...
    'FitBoxToText', 'on',...
    'BackgroundColor', 'w',...
    'EdgeColor', [0.5 0.5 0.5],...
    'FontSize', 11)

%% 输出统计信息
fprintf('[输出统计]\n')
fprintf('时间范围: %.1f - %.1f s\n', min(time_sub), max(time_sub))
fprintf('峰值时间: %.2f s\n', peak_time)
fprintf('上升段数据点: %d\n', sum(is_rising))
fprintf('下降段数据点: %d\n', sum(~is_rising))
fprintf('平均采样间隔: %.3f s\n', mean(diff(output_table.Time_s)))