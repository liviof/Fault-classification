clear all;
close all;

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


data = Normal_002;%——————————————————————————————
data_all = reshape(data', 1, []); % 转置并重塑数据 

row = 110;
new_data = data(1:row, :);


% 可视化信号
figure;
plot(data_all);
title('合成信号');
xlabel('时间 (s)');
ylabel('幅值');


% 启动计时器
tic;


% 初始化结果矩阵
energy_matrix = zeros(row, 4);



for i = 1:size(new_data, 1)

    sample = new_data(i, :);
    % 小波包分解参数
    wname = 'db4'; % 小波基函数，这里选择Daubechies 4小波
    level = 2; % 分解层数，设置为2

    % 进行小波包分解
    wp = wpdec(sample, level, wname);

    % 计算每个节点的能量
    node_energies = wenergy(wp);

    energy_matrix(i, :) = node_energies;

end


pinjie = 'Normal_002';%——————————————————————————————
% 生成变量名
variablename = ['xaiobo_feature_' pinjie];
% 将数据存储在结构体中
xaiobo_feature_Normal_002 = energy_matrix;%——————————————————————————————

filename = ['xaiobo_feature_' pinjie '.mat'];
% 保存数据
save(filename, variablename);


% load B007_001;
% load B014_001;
% load B021_001;
% load IR007_001;
% load IR014_001;
% load IR021_001;
% load OR007_6_001;
% load OR014_6_001;
% load OR021_6_001;
% load Normal_001;


% 
% 读取并显示经过的时间
elapsedTime = toc;
disp(['特定代码段运行时间: ', num2str(elapsedTime), ' 秒']);


% 获取数据尺寸
[num_samples, num_features] = size(energy_matrix);

% 定义特征名称数组
feature_names = {'两层小波包分解第1节点能量', '两层小波包分解第2节点能量', '两层小波包分解第3节点能量', '两层小波包分解第4节点能量'};

% 创建一个新的图形窗口
figure;

subplot_rows = 2;
subplot_cols = 2;

for i = 1:num_features
    % 计算当前子图的位置
    subplot(subplot_rows, subplot_cols, i);
    
    % 绘制当前特征列
    plot(1:num_samples, energy_matrix(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('样本点', 'FontSize', 14);
    ylabel('特征值 ','FontSize', 14);
    grid on;
end

% 调整子图之间的间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);









