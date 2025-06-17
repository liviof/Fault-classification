close all;
clear all;
clc;

%% 载入数据
load OR014_6_001;
data = OR014_6_001;
data_all = reshape(data, 1, []); 

% 选择用于分析的样本数据
last_data = data(1:110, :);
new_data = last_data';

%% 可视化原始信号
figure;
plot(data_all);
title('原始合成信号');
xlabel('时间');
ylabel('幅值');

%% 初始化结果变量
row = size(last_data, 1);
featureMatrix = zeros(row, 6);
IMF1 = zeros(size(last_data));
IMF2 = zeros(size(last_data));
IMF3 = zeros(size(last_data));
IMF4 = zeros(size(last_data));
IMF5 = zeros(size(last_data));

% 启动计时
tic;

%% VMD 分解
for i = 1:size(new_data, 2)
    sample = new_data(:, i); 
    
    % VMD
    [u, residual, info] = vmd(sample); 
    center_frequencies = info.CentralFrequencies;
    
    freq_mean = mean(center_frequencies);
    freq_rms = sqrt(mean(center_frequencies.^2));
    freq_std = std(center_frequencies);
    
    spectral_kurtosis = kurtosis(abs(fft(sample)).^2);
    freq_std_spectral = std(abs(fft(sample)));
    modal_energies = sum(u.^2, 1);
    [~, max_energy_index] = max(modal_energies);
    peak_frequency = center_frequencies(max_energy_index);
    
    featureMatrix(i, :) = [freq_mean, freq_rms, freq_std, spectral_kurtosis, freq_std_spectral, peak_frequency];
    
    IMF1(i, :) = u(:,1)';
    IMF2(i, :) = u(:,2)';
    IMF3(i, :) = u(:,3)';
    IMF4(i, :) = u(:,4)';
    IMF5(i, :) = u(:,5)';
end

save('IMF1.mat', 'IMF1');
save('IMF2.mat', 'IMF2');
save('IMF3.mat', 'IMF3');
save('IMF4.mat', 'IMF4');
save('IMF5.mat', 'IMF5');

elapsedTime = toc;
disp(['VMD运行时间: ', num2str(elapsedTime), ' 秒']);

%% EMD 分解
emd_IMFs = {};
for i = 1:size(new_data, 2)
    sample = new_data(:, i);
    [imf, ~] = emd(sample, 'MaxNumIMF', 5); % 限制最多5个分量
    emd_IMFs{i} = imf;
end

%% 计算相关系数：VMD
vmd_components = cat(3,IMF1, IMF2, IMF3, IMF4, IMF5);
vmd_components = permute(vmd_components, [3 1 2]);
num_components = size(vmd_components, 1);
vmd_corr = zeros(num_components, 1);

for i = 1:num_components
    corr_vals = zeros(size(data, 1), 1);
    for j = 1:size(data, 1)
        data_vec = data(j, :).';
        vmd_vec = squeeze(vmd_components(i, j, :));
        corr_vals(j) = corr(data_vec, vmd_vec);
    end
    vmd_corr(i) = mean(corr_vals, 'omitnan');
end

%% 计算相关系数：EMD
% 取出前5个IMF，补0对齐
emd_corr = zeros(5, 1);
for i = 1:5
    all_corr = zeros(size(data,1),1);
    for j = 1:size(data,1)
        orig = data(j, :).';
        if size(emd_IMFs{j}, 2) >= i
            emd_vec = emd_IMFs{j}(:,i);
            len = min(length(orig), length(emd_vec));
            all_corr(j) = corr(orig(1:len), emd_vec(1:len));
        else
            all_corr(j) = NaN;
        end
    end
    emd_corr(i) = mean(all_corr, 'omitnan');
end

%% 画图对比
figure;
bar([vmd_corr emd_corr]);
legend('VMD IMF相关性', 'EMD IMF相关性');
xlabel('IMF分量序号');
ylabel('平均皮尔逊相关系数');
title('VMD 与 EMD 分解结果相关性对比');
grid on;
