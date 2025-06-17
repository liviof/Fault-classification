close all;
clear all;
clc;


load Normal_002;
load B007_002;
load B014_002;
load B021_002;
load IR007_002;
load IR014_002;
load IR021_002;
load OR007_6_002;
load OR014_6_002;
load OR021_6_002;

data = B021_002;%——————————————————————————————
data_all = reshape(data, 1, []); % 转置并重塑数据 


last_data = data(1:110, :);%——————————————————————————————
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
featureMatrix = zeros(row, 6);%——————————————————————————————

IMF1 = zeros(size(last_data));
IMF2 = zeros(size(last_data));
IMF3 = zeros(size(last_data));
IMF4 = zeros(size(last_data));
IMF5 = zeros(size(last_data));


% size(data, 1)
for i = 1:size(new_data, 2)
    % 提取当前样本
    sample = new_data(:,i); 
    
    % 对样本进行VMD处理
    [u, residual, info] = vmd(sample); % 假设参数值
    center_frequencies = info.CentralFrequencies;
    
    % 计算特征值
    freq_mean = mean(center_frequencies);
    freq_rms = sqrt(mean(center_frequencies.^2));
    freq_std = std(center_frequencies);
    
    spectral_kurtosis = kurtosis(abs(fft(sample)).^2); % 谱幅值峭度
    freq_std_spectral = std(abs(fft(sample))); % 谱频率标准差

     modal_energies = sum(u.^2, 1);
     [~, max_energy_index] = max(modal_energies);
     peak_frequency = center_frequencies(max_energy_index); %频谱峰值
     
    % 将特征值保存到结果矩阵中
    featureMatrix(i, :) = [freq_mean, freq_rms, freq_std, spectral_kurtosis, freq_std_spectral, peak_frequency];
    
    IMF1(i, :) = u(:,1)';
    IMF2(i, :) = u(:,2)';
    IMF3(i, :) = u(:,3)';
    IMF4(i, :) = u(:,4)';
    IMF5(i, :) = u(:,5)';
end

% pinyu_featureMatrix = featureMatrix;
% % 保存或进一步使用特征矩阵
% save('pinyu_feature_bear1.mat', 'pinyu_featureMatrix');

save('IMF1.mat', 'IMF1');
save('IMF2.mat', 'IMF2');
save('IMF3.mat', 'IMF3');
save('IMF4.mat', 'IMF4');
save('IMF5.mat', 'IMF5');

% 
% 读取并显示经过的时间
elapsedTime = toc;
disp(['特定代码段运行时间: ', num2str(elapsedTime), ' 秒']);


%% VMD分解的原始信号
% 使用循环逐个绘制每列数据
for i = 1:5
    subplot(5, 1, i); % 创建5个子图，按5行1列布局，当前绘制第i个子图
    plot(u(:, i)); % 绘制第i列数据，这里data(:, i)表示选取所有行的第i列数据
    title(['Column ', num2str(i)]); % 给每个子图添加标题，显示是第几列数据
    xlabel('Index'); % x轴标签表示数据点的索引
    ylabel('Value'); % y轴标签表示数据的值
end


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


%% 提取前相关性比较高的分量


vmd_components = cat(3,IMF1, IMF2, IMF3, IMF4, IMF5);

% 使用 permute 函数调整维度顺序，使第一个维度为 5
vmd_components = permute(vmd_components, [3 1 2]);

% 初始化相关系数向量
num_components = size(vmd_components, 1);
correlation_coeffs = zeros(num_components, 1);

disp(['Size of vmd_components: ', num2str(size(vmd_components))]);


% 计算每个 VMD 分量与原始信号的相关系数
for i = 1:num_components
    % 对每个时间点计算皮尔逊相关系数，并取平均值
    corr_values = zeros(size(data, 1), 1);
    for j = 1:size(data, 1)
        % 获取当前时间点的数据行并转置为列向量
        data_vector = data(j, :).';                  % 1024 x 1 列向量
        
        % 获取当前 VMD 分量的时间点数据并转置为列向量
        vmd_vector = squeeze(vmd_components(i, j, :)).'; % 1024 x 1 列向量
        
%         % 验证数据维度
%         if size(data_vector) ~= [1024, 1] || size(vmd_vector) ~= [1024, 1]
%             error('Data dimensions do not match at time point %d.', j);
%         end
        
        % 计算皮尔逊相关系数
        if all(isfinite(data_vector)) && all(isfinite(vmd_vector))
            corr_values(j) = corr(data_vector, vmd_vector');
        else
            warning('Skipping NaN or Inf values in correlation calculation at time point %d.', j);
            corr_values(j) = NaN;
        end
    end
    
    % 取非 NaN 值的平均值
    valid_corr_values = corr_values(~isnan(corr_values));
    if ~isempty(valid_corr_values)
        correlation_coeffs(i) = mean(valid_corr_values);
    else
        correlation_coeffs(i) = NaN;
        warning('All correlation values are NaN for component %d.', i);
    end
end



% 找到相关性最高的前三个分量
[~, idx] = sort(abs(correlation_coeffs), 'descend');
top_three_components = idx(1:3);

% 提取前三个相关性最高的分量
selected_components = vmd_components(top_three_components, :);
