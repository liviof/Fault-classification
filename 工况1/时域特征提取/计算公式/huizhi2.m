close all;
clear all;
clc;

load B007_1.mat;
load B014_1.mat;
load B021_1.mat;
load IR007_1.mat;
load IR014_1.mat;
load IR021_1.mat;
load OR007@6_1.mat;
load OR014@6_1.mat;
load OR021@6_1.mat;
load Normal.mat;

data1 = X119_DE_time;
data2 = X186_DE_time;
data3 = X223_DE_time;
data4 = X106_DE_time;
data5 = X170_DE_time;
data6 = X210_DE_time;
data7 = X131_DE_time;
data8 = X198_DE_time;
data9 = X235_DE_time;
data10 = X098_DE_time;

% 创建一个新的图形窗口
figure;

% 绘制 data1 = X119_DE_time 的前 1024 个数据点
subplot(5, 2, 1);
plot(X119_DE_time(1:1024));
title('B007_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X119_DE_time(1:1024))) max(abs(X119_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data2 = X186_DE_time 的前 1024 个数据点
subplot(5, 2, 2);
plot(X186_DE_time(1:1024));
title('B014_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X186_DE_time(1:1024))) max(abs(X186_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data3 = X223_DE_time 的前 1024 个数据点
subplot(5, 2, 3);
plot(X223_DE_time(1:1024));
title('B021_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X223_DE_time(1:1024))) max(abs(X223_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data4 = X106_DE_time 的前 1024 个数据点
subplot(5, 2, 4);
plot(X106_DE_time(1:1024));
title('IR007_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X106_DE_time(1:1024))) max(abs(X106_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data5 = X170_DE_time 的前 1024 个数据点
subplot(5, 2, 5);
plot(X170_DE_time(1:1024));
title('IR014_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X170_DE_time(1:1024))) max(abs(X170_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data6 = X210_DE_time 的前 1024 个数据点
subplot(5, 2, 6);
plot(X210_DE_time(1:1024));
title('IR021_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X210_DE_time(1:1024))) max(abs(X210_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data7 = X131_DE_time 的前 1024 个数据点
subplot(5, 2, 7);
plot(X131_DE_time(1:1024));
title('OR007@6_1');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X131_DE_time(1:1024))) max(abs(X131_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data8 = X198_DE_time 的前 1024 个数据点
subplot(5, 2, 8);
plot(X198_DE_time(1:1024));
title('OR014@6_0');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X198_DE_time(1:1024))) max(abs(X198_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data9 = X235_DE_time 的前 1024 个数据点
subplot(5, 2, 9);
plot(X235_DE_time(1:1024));
title('OR021@6_0');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X235_DE_time(1:1024))) max(abs(X235_DE_time(1:1024)))]); % 设置纵轴范围

% 绘制 data10 = X098_DE_time 的前 1024 个数据点
subplot(5, 2, 10);
plot(X098_DE_time(1:1024));
title('Normal');
xlabel('样本点');
ylabel('振幅');
grid on;
ylim([-max(abs(X098_DE_time(1:1024))) max(abs(X098_DE_time(1:1024)))]); % 设置纵轴范围

% 数据保存部分
extracted_data1 = data1(1:110*1024);
B007_001 = reshape(extracted_data1, 1024, 110)';
save('B007_001.mat', 'B007_001');

extracted_data2 = data2(1:110*1024);
B014_001 = reshape(extracted_data2, 1024, 110)';
save('B014_001.mat', 'B014_001');

extracted_data3 = data3(1:110*1024);
B021_001 = reshape(extracted_data3, 1024, 110)';
save('B021_001.mat', 'B021_001');

extracted_data4 = data4(1:110*1024);
IR007_001 = reshape(extracted_data4, 1024, 110)';
save('IR007_001.mat', 'IR007_001');

extracted_data5 = data5(1:110*1024);
IR014_001 = reshape(extracted_data5, 1024, 110)';
save('IR014_001.mat', 'IR014_001');

extracted_data6 = data6(1:110*1024);
IR021_001 = reshape(extracted_data6, 1024, 110)';
save('IR021_001.mat', 'IR021_001');

extracted_data7 = data7(1:110*1024);
OR007_6_001 = reshape(extracted_data7, 1024, 110)';
save('OR007_6_001.mat', 'OR007_6_001');

extracted_data8 = data8(1:110*1024);
OR014_6_001 = reshape(extracted_data8, 1024, 110)';
save('OR014_6_001.mat', 'OR014_6_001');

extracted_data9 = data9(1:110*1024);
OR021_6_001 = reshape(extracted_data9, 1024, 110)';
save('OR021_6_001.mat', 'OR021_6_001');

extracted_data10 = data10(1:110*1024);
Normal_001 = reshape(extracted_data10, 1024, 110)';
save('Normal_001.mat', 'Normal_001');
