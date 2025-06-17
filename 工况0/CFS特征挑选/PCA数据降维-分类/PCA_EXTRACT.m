close all;
clear all;
clc;


% Normal_000数据
load 'shiyu_feature_Normal_000'
load 'shiyu_feature_Normal_000_IMF1'
load 'shiyu_feature_Normal_000_IMF2'
load 'shiyu_feature_Normal_000_IMF5'
load 'pinyu_feature_FFT_Normal_000'
load 'xaiobo_feature_Normal_000'

% B007_000数据
load 'shiyu_feature_B007_000'
load 'shiyu_feature_B007_000_IMF1'
load 'shiyu_feature_B007_000_IMF2'
load 'shiyu_feature_B007_000_IMF3'
load 'pinyu_feature_FFT_B007_000'
load 'xaiobo_feature_B007_000'

% B014_000数据
load 'shiyu_feature_B014_000'
load 'shiyu_feature_B014_000_IMF1'
load 'shiyu_feature_B014_000_IMF2'
load 'shiyu_feature_B014_000_IMF3'
load 'pinyu_feature_FFT_B014_000'
load 'xaiobo_feature_B014_000'

% B021_000数据
load 'shiyu_feature_B021_000'
load 'shiyu_feature_B021_000_IMF1'
load 'shiyu_feature_B021_000_IMF2'
load 'shiyu_feature_B021_000_IMF3'
load 'pinyu_feature_FFT_B021_000'
load 'xaiobo_feature_B021_000'

% IR007_000数据
load 'shiyu_feature_IR007_000'
load 'shiyu_feature_IR007_000_IMF1'
load 'shiyu_feature_IR007_000_IMF2'
load 'shiyu_feature_IR007_000_IMF3'
load 'pinyu_feature_FFT_IR007_000'
load 'xaiobo_feature_IR007_000'

% IR014_000数据
load 'shiyu_feature_IR014_000'
load 'shiyu_feature_IR014_000_IMF1'
load 'shiyu_feature_IR014_000_IMF2'
load 'shiyu_feature_IR014_000_IMF3'
load 'pinyu_feature_FFT_IR014_000'
load 'xaiobo_feature_IR014_000'

% IR021_000数据
load 'shiyu_feature_IR021_000'
load 'shiyu_feature_IR021_000_IMF1'
load 'shiyu_feature_IR021_000_IMF2'
load 'shiyu_feature_IR021_000_IMF3'
load 'pinyu_feature_FFT_IR021_000'
load 'xaiobo_feature_IR021_000'

% OR007_6_000数据
load 'shiyu_feature_OR007_6_000'
load 'shiyu_feature_OR007_6_000_IMF2'
load 'shiyu_feature_OR007_6_000_IMF3'
load 'shiyu_feature_OR007_6_000_IMF4'
load 'pinyu_feature_FFT_OR007_6_000'
load 'xaiobo_feature_OR007_6_000'

% OR014_6_000数据
load 'shiyu_feature_OR014_6_000'
load 'shiyu_feature_OR014_6_000_IMF2'
load 'shiyu_feature_OR014_6_000_IMF3'
load 'shiyu_feature_OR014_6_000_IMF4'
load 'pinyu_feature_FFT_OR014_6_000'
load 'xaiobo_feature_OR014_6_000'

% OR021_6_000数据
load 'shiyu_feature_OR021_6_000'
load 'shiyu_feature_OR021_6_000_IMF1'
load 'shiyu_feature_OR021_6_000_IMF2'
load 'shiyu_feature_OR021_6_000_IMF3'
load 'pinyu_feature_FFT_OR021_6_000'
load 'xaiobo_feature_OR021_6_000'


load 'bear1eigen'

% 将所有特征组合成一个矩阵

% combined_data = [data1, data22, data3, newData_IMF1, newData_IMF2, newData_IMF3, newData_IMF4, newData_IMF5];
Normal_000_data = [shiyu_feature_Normal_000, shiyu_feature_Normal_000_IMF1, shiyu_feature_Normal_000_IMF2, shiyu_feature_Normal_000_IMF5,... 
    pinyu_feature_FFT_Normal_000, xaiobo_feature_Normal_000];

B007_000_data = [shiyu_feature_B007_000, shiyu_feature_B007_000_IMF1, shiyu_feature_B007_000_IMF2, shiyu_feature_B007_000_IMF3,... 
    pinyu_feature_FFT_B007_000, xaiobo_feature_B007_000];
B014_000_data = [shiyu_feature_B014_000, shiyu_feature_B014_000_IMF1, shiyu_feature_B014_000_IMF2, shiyu_feature_B014_000_IMF3,... 
    pinyu_feature_FFT_B014_000, xaiobo_feature_B014_000];
B021_000_data = [shiyu_feature_B021_000, shiyu_feature_B021_000_IMF1, shiyu_feature_B021_000_IMF2, shiyu_feature_B021_000_IMF3,... 
    pinyu_feature_FFT_B021_000, xaiobo_feature_B021_000];

IR007_000_data = [shiyu_feature_IR007_000, shiyu_feature_IR007_000_IMF1, shiyu_feature_IR007_000_IMF2, shiyu_feature_IR007_000_IMF3,... 
    pinyu_feature_FFT_IR007_000, xaiobo_feature_IR007_000];
IR014_000_data = [shiyu_feature_IR014_000, shiyu_feature_IR014_000_IMF1, shiyu_feature_IR014_000_IMF2, shiyu_feature_IR014_000_IMF3,... 
    pinyu_feature_FFT_IR014_000, xaiobo_feature_IR014_000];
IR021_000_data = [shiyu_feature_IR021_000, shiyu_feature_IR021_000_IMF1, shiyu_feature_IR021_000_IMF2, shiyu_feature_IR021_000_IMF3,... 
    pinyu_feature_FFT_IR021_000, xaiobo_feature_IR021_000];

OR007_6_000_data = [shiyu_feature_OR007_6_000, shiyu_feature_OR007_6_000_IMF2, shiyu_feature_OR007_6_000_IMF3, shiyu_feature_OR007_6_000_IMF4,... 
    pinyu_feature_FFT_OR007_6_000, xaiobo_feature_OR007_6_000];
OR014_6_000_data = [shiyu_feature_OR014_6_000, shiyu_feature_OR014_6_000_IMF2, shiyu_feature_OR014_6_000_IMF3, shiyu_feature_OR014_6_000_IMF4,... 
    pinyu_feature_FFT_OR014_6_000, xaiobo_feature_OR014_6_000];
OR021_6_000_data = [shiyu_feature_OR021_6_000, shiyu_feature_OR021_6_000_IMF1, shiyu_feature_OR021_6_000_IMF2, shiyu_feature_OR021_6_000_IMF3,... 
    pinyu_feature_FFT_OR021_6_000, xaiobo_feature_OR021_6_000];

% % 归一化
% [normalizedData, settings] = mapminmax(combined_data,0,1);


stackedData = [B007_000_data; B014_000_data; B021_000_data; ...
               IR007_000_data; IR014_000_data; IR021_000_data; ...
               OR007_6_000_data; OR014_6_000_data; OR021_6_000_data; ...
               Normal_000_data];


% 标准化数据（均值为0，标准差为1）
CFS_Data = zscore(stackedData);

save('CFS_Data.mat', 'CFS_Data');


% 执行 PCA
[coeff, score, latent, ~, explained] = pca(data);

% 显示每个主成分解释的方差百分比
disp('Explained variance by each principal component:');
disp(explained);

% 绘制累积方差解释图
figure;
cumsum_explained = cumsum(explained);
plot(cumsum_explained, 'LineWidth', 2);
xlabel('主成分数量');
ylabel('累计解释方差 (%)');
title('主成分数量与累计解释方差关系图');
grid on;

% 选择要保留的主成分数量
numComponents = find(cumsum_explained >= 97, 1); % 选择能够解释至少 95% 方差的主成分数量
fprintf('保留的主成分数量: %d\n', numComponents);

% 降维后的数据
reducedData = score(:, 1:numComponents);

% 显示降维后的数据尺寸
disp(['降维后的数据尺寸: ', num2str(size(reducedData))]);

%save('reducedData.mat', 'reducedData');


% 如果降维后的数据维度小于等于 3，进行可视化
if numComponents == 2
    % 二维可视化
    figure;
    scatter(reducedData(:, 1), reducedData(:, 2));
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    title('PCA Reduced Data (2D)');
    grid on;
elseif numComponents == 3
    % 三维可视化
    figure;
    scatter3(reducedData(:, 1), reducedData(:, 2), reducedData(:, 3));
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    zlabel('Principal Component 3');
    title('PCA Reduced Data (3D)');
    grid on;
end

% 重构数据并计算重建误差
reconstructedData = reducedData * coeff(:, 1:numComponents)';
reconstructionError = mean(sqrt(sum((data - reconstructedData).^2, 2)));
fprintf('重构误差: %f\n', reconstructionError);
numFeatures = size(stackedData, 2);
disp(['特征数 ', num2str(numFeatures)]);


