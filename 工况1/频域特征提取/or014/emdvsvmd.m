close all;
clear all;
clc;

% 加载数据
load Normal_001;
load B007_001;
load B014_001;
load B021_001;
load IR007_001;
load IR014_001;
load IR021_001;
load OR007_6_001;
load OR014_6_001;
load OR021_6_001;

% 选择信号进行处理
data = OR014_6_001; %——————————————————————————————
data_all = reshape(data, 1, []); % 转置并重塑数据

% 提取信号的一部分
last_data = data(1:110, :); %——————————————————————————————
new_data = last_data';

% 可视化信号
figure;
plot(data_all);
title('合成信号');
xlabel('时间 (s)');
ylabel('幅值');

% 启动计时器
tic;

row = size(last_data, 1);
% 初始化结果矩阵
featureMatrix = zeros(row, 6); %——————————————————————————————

IMF1 = zeros(size(last_data));
IMF2 = zeros(size(last_data));
IMF3 = zeros(size(last_data));
IMF4 = zeros(size(last_data));
IMF5 = zeros(size(last_data));

% 对每个样本进行EMD分解
for i = 1:size(new_data, 2)
    % 提取当前样本
    sample = new_data(:, i);
    
    % 使用EMD进行分解
    [imf, res] = emd(sample);  % EMD分解，返回IMF分量和残差
    
    % 如果IMF数量大于5，取前5个IMF
    num_imfs = size(imf, 2);
    imf = imf(:, 1:min(num_imfs, 5));  % 只保留前5个分量
    
    % 将分解得到的IMF保存
    IMF1(i, :) = imf(:, 1)';
    IMF2(i, :) = imf(:, 2)';
    IMF3(i, :) = imf(:, 3)';
    IMF4(i, :) = imf(:, 4)';
    IMF5(i, :) = imf(:, 5)';
    
    % 计算频率相关特征
    freq_mean = mean(imf(:));  % 平均频率
    freq_rms = sqrt(mean(imf(:).^2));  % 均方根
    freq_std = std(imf(:));  % 标准差
    
    % 计算频谱峭度（从快速傅里叶变换（FFT）中提取）
    spectral_kurtosis = kurtosis(abs(fft(sample)).^2);  % 谱幅值峭度
    
    % 计算频率标准差
    freq_std_spectral = std(abs(fft(sample)));  % 谱频率标准差
    
    % 计算频谱峰值（选取能量最大的分量）
    modal_energies = sum(imf.^2, 1);  % 计算每个分量的能量
    [~, max_energy_index] = max(modal_energies);  % 选择最大能量分量
    peak_frequency = modal_energies(max_energy_index);  % 频谱峰值
    
    % 将特征保存到结果矩阵中
    featureMatrix(i, :) = [freq_mean, freq_rms, freq_std, spectral_kurtosis, freq_std_spectral, peak_frequency];
end

% 保存IMF分量
save('IMF1.mat', 'IMF1');
save('IMF2.mat', 'IMF2');
save('IMF3.mat', 'IMF3');
save('IMF4.mat', 'IMF4');
save('IMF5.mat', 'IMF5');

% 计算并显示运行时间
elapsedTime = toc;
disp(['特定代码段运行时间: ', num2str(elapsedTime), ' 秒']);

%% 可视化IMF分量
% 使用循环逐个绘制每列数据
figure;
for i = 1:5
    subplot(5, 1, i); % 创建5个子图，按5行1列布局，当前绘制第i个子图
    plot(imf(:, i)); % 绘制第i列数据
    title(['IMF ', num2str(i)]); % 给每个子图添加标题，显示是第几列数据
    xlabel('样本点');
    ylabel('幅值');
end

%% 绘制特征值
% 定义特征名称数组
feature_names = {'均值频率', '均方根频率', '标准差频率', '谱幅值峭度', '谱频率标准差', '频谱峰值'};

% 创建图形窗口
figure;
subplot_rows = 2;
subplot_cols = 3;

for i = 1:6
    subplot(subplot_rows, subplot_cols, i);
    plot(1:row, featureMatrix(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('样本点', 'FontSize', 14);
    ylabel('特征值','FontSize', 14);
    grid on;
end

% 调整子图之间的间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

%% 提取前相关性比较高的分量
vmd_components = cat(3, IMF1, IMF2, IMF3, IMF4, IMF5);

% 使用 permute 函数调整维度顺序，使第一个维度为 5
vmd_components = permute(vmd_components, [3 1 2]);

% 初始化相关系数向量
num_components = size(vmd_components, 1);
correlation_coeffs = zeros(num_components, 1);

% 计算每个 VMD 分量与原始信号的相关系数
for i = 1:num_components
    corr_values = zeros(size(data, 1), 1);
    for j = 1:size(data, 1)
        data_vector = data(j, :).';  % 当前时间点的数据行
        vmd_vector = squeeze(vmd_components(i, j, :)).'; % 当前 VMD 分量
        
        % 计算皮尔逊相关系数
        if all(isfinite(data_vector)) && all(isfinite(vmd_vector))
            corr_values(j) = corr(data_vector, vmd_vector');
        else
            warning('跳过 NaN 或 Inf 值，时间点 %d 的相关性计算。', j);
            corr_values(j) = NaN;
        end
    end
    
    % 取非 NaN 值的平均值
    valid_corr_values = corr_values(~isnan(corr_values));
    if ~isempty(valid_corr_values)
        correlation_coeffs(i) = mean(valid_corr_values);
    else
        correlation_coeffs(i) = NaN;
        warning('IMF %d 的相关性值全为 NaN。', i);
    end
end

% 找到相关性最高的前三个分量
[~, idx] = sort(abs(correlation_coeffs), 'descend');
top_three_components = idx(1:3);

% 提取前三个相关性最高的分量
selected_components = vmd_components(top_three_components, :);

%% 可视化相关性系数
figure;
bar(1:num_components, correlation_coeffs);
title('IMF分量与原始信号的相关系数');
xticklabels(compose('IMF %d', 1:num_components));
xlabel('模态分量编号');
ylabel('相关系数');
ylim([0, 1]); % 相关系数范围 [-1, 1]
grid on;

% 打印所有分量的相关性
disp('所有分量与原始信号的相关系数：');
for i = 1:num_components
    fprintf('IMF %d 相关系数：%.4f\n', i, correlation_coeffs(i));
end
