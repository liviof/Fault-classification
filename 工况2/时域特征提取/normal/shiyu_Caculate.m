close all;
clear all;
clc;


load B007_001;
load B014_001;
load B021_001;
load IR007_001;
load IR014_001;
load IR021_001;
load OR007_6_001;
load OR014_6_001;
load OR021_6_001;
load Normal_001;


load IMF1;
load IMF2;
% load IMF3;
% load IMF4;
load IMF5;


% % IMF分量都是在频域提取时处理好的了，所以不需要再裁剪
% data_ll = bear1(1:2765, :);
% 
% 
% %原始数据信息
% oneLongVector = reshape(data_ll', 1, []); % 转置并重塑数据 
% 
% 
% figure;
% plot(oneLongVector);
% title('Bear1 原始信号', 'FontSize', 22);
% xlabel('样本点', 'FontSize', 20);
% ylabel('振幅', 'FontSize', 20);
% grid on;



data = IMF5; %————————————————————————————

% 定义所需的行数，去处失效阶段
row = size(data, 1);
new_data = data(1:row, :);

% 用于存储最终特征结果的矩阵初始化
features = zeros(row, 12);


for i = 1:size(new_data, 1)
    
    segment = new_data(i, :); % 获取当前段的数据
% 计算各特征
    abs_mean = mean(abs(segment));            % 绝对均值
    peak_value = max(abs(segment));           % 峰值 (绝对值)
    var_value = var(segment);                 % 方差
    peak_to_peak = max(segment) - min(segment); % 峰峰值
    kurtosis_factor = kurtosis(segment);      % 峰度因子
    rms_value = sqrt(mean(segment.^2));       % 均方根 (RMS)

    kurtosisValue = kurtosis(segment); %峭度      
    stdValue = std(segment); %标准差
    kurtosisFactor = kurtosisValue / stdValue;  % 峭度因子  
    
    shape_factor = rms_value / mean(abs(segment));    % 形状因子
    impulse_factor = peak_value / mean(abs(segment)); % 脉冲因子
    root_amplitude = sqrt(mean(sqrt(abs(segment))));  % 根振幅
    crest_factor = peak_value / rms_value;      % 波峰因子
    skewness_factor = skewness(segment);        % 偏度因子
    
    % 将当前段的各特征依次存入结果矩阵的对应行
    features(i, :) = [abs_mean, peak_value, var_value, peak_to_peak, ...
                      kurtosis_factor, rms_value, kurtosisFactor, ...
                      shape_factor, impulse_factor, root_amplitude, ...
                      crest_factor, skewness_factor];
end


% shiyu_features = features;
% % 将 'features' 变量保存到当前目录下的 'features.mat' 文件中
% save('shiyu_features_bear1.mat', 'shiyu_features');

% features_Normal_001 = features;
% % 将 'features' 变量保存到当前目录下的 'features.mat' 文件中
% save('shiyu_Normal_001_features.mat', 'features_Normal_001');


pinjie = 'Normal_002_IMF5';%————————————————————————————
% 生成变量名
variablename = ['shiyu_feature_' pinjie];
% 将数据存储在结构体中
shiyu_feature_Normal_002_IMF5 = features;%————————————————————————————

filename = ['shiyu_feature_' pinjie '.mat'];
% 保存数据
save(filename, variablename);



% 获取数据尺寸
[num_samples, num_features] = size(features);

% 定义特征名称数组
feature_names = {
    '绝对均值', '峰值', '方差', '峰峰值', '峰度因子', ...
    '均方根', '峭度因子', '形状因子', '脉冲因子', ...
    '根振幅', '波峰因子', '偏度因子', '变异系数'
};

% 创建一个新的图形窗口
figure;

% 定义子图布局（4行4列，最后一行可能不满）
subplot_rows = 3;
subplot_cols = 4;

for i = 1:num_features
    % 计算当前子图的位置
    subplot(subplot_rows, subplot_cols, i);
    
    % 绘制当前特征列
    plot(1:num_samples, features(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('样本点', 'FontSize', 14);
    ylabel('特征值 ','FontSize', 14);
    grid on;
end

% 调整子图之间的间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
