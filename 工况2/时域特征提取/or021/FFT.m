close all;
clear all;
clc;

load B007_002;
load B014_002;
load B021_002;
load IR007_002;
load IR014_002;
load IR021_002;
load OR007_6_002;
load OR014_6_002;
load OR021_6_002;
load Normal_002;


data = OR021_6_002;
data_all = reshape(data', 1, []); % 转置并重塑数据 

last_data = data(1:110, :);%——————————————————————————
new_data = last_data';

% 可视化信号
figure;
plot(data_all);
title('合成信号');
xlabel('时间 (s)');
ylabel('幅值');

% 启动计时器
tic;

% 信号采集频率Hz,西储采样频率
fs = 12000; %——————————————————————————————

row = size(last_data, 1); % 获得2765
cols = size(last_data, 2); % 获得2560
% 初始化结果矩阵
featureMatrix = zeros(row, 6);%——————————————————————————————



for i = 1:row
    % 对第i行信号进行快速傅里叶变换（FFT）
    fft_result = fft(last_data(i, :));
    
    % 获取前半部分的频域幅值（不包括对称部分）
    magnitude = abs(fft_result(1:cols/2+1));  % 注意这里假设 cols 是偶数
    
    % 生成频率轴（只取前半部分）
    freq_axis = (0:cols/2)*(fs/cols);  % 包括奈奎斯特频率
    
    % 计算 PSD
    psd = magnitude.^2;
    
    % 计算总能量
    total_energy = sum(psd);
    
    % 计算均值频率
    mean_frequencies = sum(freq_axis .* psd) / total_energy;
    
    % 计算 RMS 频率
    rms_frequencies = sqrt(sum(freq_axis.^2 .* psd) / total_energy);
    
    % 计算标准差频率
    std_frequencies = sqrt(rms_frequencies^2 - mean_frequencies^2);
    
    % 计算谱频率标准差（频率分布的标准差）
    std_spectral_frequencies = sqrt(sum((freq_axis - mean_frequencies).^2 .* psd) / total_energy);
    
    % 计算谱幅值峭度
    amplitude = magnitude;
    mu = mean(amplitude);
    sigmaSquared = var(amplitude);
    spectral_kurtosis = mean(((amplitude - mu).^4) ./ (sigmaSquared^2));
    
    % 计算频谱峰值频率
    [~, peak_index] = max(psd);
    peak_frequencies = freq_axis(peak_index);
    
    
    featureMatrix(i, :) = [mean_frequencies, rms_frequencies, std_frequencies, std_spectral_frequencies, spectral_kurtosis, peak_frequencies];
    
end

pinjie = 'OR021_6_002';
% 生成变量名
variablename = ['pinyu_feature_FFT_' pinjie];
% 将数据存储在结构体中
pinyu_feature_FFT_OR021_6_002 = featureMatrix;

filename = ['pinyu_feature_FFT_' pinjie '.mat'];
% 保存数据
save(filename, variablename);


% 
% 读取并显示经过的时间
elapsedTime = toc;
disp(['特定代码段运行时间: ', num2str(elapsedTime), ' 秒']);


%% 

% 获取数据尺寸
[num_samples, num_features] = size(featureMatrix);

% 定义特征名称数组
feature_names = {'均值频率', '均方根频率', '标准差频率', '谱幅值峭度', '谱频率标准差', '频谱峰值'};

% 创建一个新的图形窗口
figure;

subplot_rows = 2;
subplot_cols = 3;

for i = 1:num_features
    % 计算当前子图的位置
    subplot(subplot_rows, subplot_cols, i);
    
    % 绘制当前特征列
    plot(1:num_samples, featureMatrix(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('样本点', 'FontSize', 14);
    ylabel('特征值 ','FontSize', 14);
    grid on;
end

% 调整子图之间的间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);




