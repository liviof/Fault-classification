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



% 假设 X106_DE_time, X170_DE_time 等数据已经在工作区中存在

% 创建一个新的图形窗口
figure;

% 绘制 data1 = X119_DE_time 的前 1024 个数据点
subplot(3, 3, 1);
plot(X119_DE_time(1:1024));
title('B007_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data2 = X186_DE_time 的前 1024 个数据点
subplot(3, 3, 2);
plot(X186_DE_time(1:1024));
title('B014_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data3 = X223_DE_time 的前 1024 个数据点
subplot(3, 3, 3);
plot(X223_DE_time(1:1024));
title('B021_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data4 = X106_DE_time 的前 1024 个数据点
subplot(3, 3, 4);
plot(X106_DE_time(1:1024));
title('IR007_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data5 = X170_DE_time 的前 1024 个数据点
subplot(3, 3, 5);
plot(X170_DE_time(1:1024));
title('IR014_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data6 = X210_DE_time 的前 1024 个数据点
subplot(3, 3, 6);
plot(X210_DE_time(1:1024));
title('IR021_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data7 = X131_DE_time 的前 1024 个数据点
subplot(3, 3, 7);
plot(X131_DE_time(1:1024));
title('OR007@6_1');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data8 = X198_DE_time 的前 1024 个数据点
subplot(3, 3, 8);
plot(X198_DE_time(1:1024));
title('OR014@6_0');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data9 = X235_DE_time 的前 1024 个数据点
subplot(3, 3, 9);
plot(X235_DE_time(1:1024));
title('OR021@6_0');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;


figure;
% 绘制 data10 = X098_DE_time 的前 1024 个数据点
plot(X098_DE_time(1:1024));
title('Normal');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;


% data1 = X118_DE_time;
% data2 = X185_DE_time;
% data3 = X222_DE_time;
% 
% data4 = X105_DE_time;
% data5 = X169_DE_time;
% data6 = X209_DE_time;
% 
% data7 = X130_DE_time;
% data8 = X197_DE_time;
% data9 = X234_DE_time;
% 
% data10 = X100_DE_time;


% load B007_0.mat;
% load B014_0.mat;
% load B021_0.mat;
% load IR007_0.mat;
% load IR014_0.mat;
% load IR021_0.mat;
% load OR007@6_0.mat;
% load OR014@6_0.mat;
% load OR021@6_0.mat;
% load Normal.mat;


extracted_data1 = data1(1:110*1024);
shiyu_feature_B007_001 = reshape(extracted_data1, 1024, 110)';
save('shiyu_feature_B007_001.mat', 'shiyu_feature_B007_001');

extracted_data2 = data2(1:110*1024);
shiyu_feature_B014_001 = reshape(extracted_data2, 1024, 110)';
save('shiyu_feature_B014_001.mat', 'shiyu_feature_B014_001');

extracted_data3 = data3(1:110*1024);
shiyu_feature_B021_001 = reshape(extracted_data3, 1024, 110)';
save('shiyu_feature_B021_001.mat', 'shiyu_feature_B021_001');

extracted_data4 = data4(1:110*1024);
shiyu_feature_IR007_001 = reshape(extracted_data4, 1024, 110)';
save('shiyu_feature_IR007_001.mat', 'shiyu_feature_IR007_001');

extracted_data5 = data5(1:110*1024);
shiyu_feature_IR014_001 = reshape(extracted_data5, 1024, 110)';
save('shiyu_feature_IR014_001.mat', 'shiyu_feature_IR014_001');

extracted_data6 = data6(1:110*1024);
shiyu_feature_IR021_001 = reshape(extracted_data6, 1024, 110)';
save('shiyu_feature_IR021_001.mat', 'shiyu_feature_IR021_001');

extracted_data7 = data7(1:110*1024);
shiyu_feature_OR007_6_001 = reshape(extracted_data7, 1024, 110)';
save('shiyu_feature_OR007_6_001.mat', 'shiyu_feature_OR007_6_001');

extracted_data8 = data8(1:110*1024);
shiyu_feature_OR014_6_001 = reshape(extracted_data8, 1024, 110)';
save('shiyu_feature_OR014_6_001.mat', 'shiyu_feature_OR014_6_001');

extracted_data9 = data9(1:110*1024);
shiyu_feature_OR021_6_001 = reshape(extracted_data9, 1024, 110)';
save('shiyu_feature_OR021_6_001.mat', 'shiyu_feature_OR021_6_001');

extracted_data10 = data10(1:110*1024);
shiyu_feature_Normal_001 = reshape(extracted_data10, 1024, 110)';
save('shiyu_feature_Normal_001.mat', 'shiyu_feature_Normal_001');


