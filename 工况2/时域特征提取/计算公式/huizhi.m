close all;
clear all;
clc;


load B007_2.mat;
load B014_2.mat;
load B021_2.mat;
load IR007_2.mat;
load IR014_2.mat;
load IR021_2.mat;
load OR007@6_2.mat;
load OR014@6_2.mat;
load OR021@6_2.mat;
load Normal.mat;


data1 = X120_DE_time;
data2 = X187_DE_time;
data3 = X224_DE_time;

data4 = X107_DE_time;
data5 = X171_DE_time;
data6 = X211_DE_time;

data7 = X132_DE_time;
data8 = X199_DE_time;
data9 = X236_DE_time;

data10 = X099_DE_time;



% 假设 X106_DE_time, X170_DE_time 等数据已经在工作区中存在

% 创建一个新的图形窗口
figure;

% 绘制 data1 = X120_DE_time 的前 1024 个数据点
subplot(3, 3, 1);
plot(X120_DE_time(1:1024));
title('B007_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data2 = X187_DE_time 的前 1024 个数据点
subplot(3, 3, 2);
plot(X187_DE_time(1:1024));
title('B014_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data3 = X224_DE_time 的前 1024 个数据点
subplot(3, 3, 3);
plot(X224_DE_time(1:1024));
title('B021_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data4 = X107_DE_time 的前 1024 个数据点
subplot(3, 3, 4);
plot(X107_DE_time(1:1024));
title('IR007_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data5 = X171_DE_time 的前 1024 个数据点
subplot(3, 3, 5);
plot(X171_DE_time(1:1024));
title('IR014_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data6 = X211_DE_time 的前 1024 个数据点
subplot(3, 3, 6);
plot(X211_DE_time(1:1024));
title('IR021_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data7 = X132_DE_time 的前 1024 个数据点
subplot(3, 3, 7);
plot(X132_DE_time(1:1024));
title('OR007@6_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data8 = X199_DE_time 的前 1024 个数据点
subplot(3, 3, 8);
plot(X199_DE_time(1:1024));
title('OR014@6_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% 绘制 data9 = X236_DE_time 的前 1024 个数据点
subplot(3, 3, 9);
plot(X236_DE_time(1:1024));
title('OR021@6_2');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;


figure;
% 绘制 data10 = X099_DE_time 的前 1024 个数据点
plot(X099_DE_time(1:1024));
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
B007_002 = reshape(extracted_data1, 1024, 110)';
save('B007_002.mat', 'B007_002');

extracted_data2 = data2(1:110*1024);
B014_002 = reshape(extracted_data2, 1024, 110)';
save('B014_002.mat', 'B014_002');

extracted_data3 = data3(1:110*1024);
B021_002 = reshape(extracted_data3, 1024, 110)';
save('B021_002.mat', 'B021_002');

extracted_data4 = data4(1:110*1024);
IR007_002 = reshape(extracted_data4, 1024, 110)';
save('IR007_002.mat', 'IR007_002');

extracted_data5 = data5(1:110*1024);
IR014_002 = reshape(extracted_data5, 1024, 110)';
save('IR014_002.mat', 'IR014_002');

extracted_data6 = data6(1:110*1024);
IR021_002 = reshape(extracted_data6, 1024, 110)';
save('IR021_002.mat', 'IR021_002');

extracted_data7 = data7(1:110*1024);
OR007_6_002 = reshape(extracted_data7, 1024, 110)';
save('OR007_6_002.mat', 'OR007_6_002');

extracted_data8 = data8(1:110*1024);
OR014_6_002 = reshape(extracted_data8, 1024, 110)';
save('OR014_6_002.mat', 'OR014_6_002');

extracted_data9 = data9(1:110*1024);
OR021_6_002 = reshape(extracted_data9, 1024, 110)';
save('OR021_6_002.mat', 'OR021_6_002');

extracted_data10 = data10(1:110*1024);
Normal_002 = reshape(extracted_data10, 1024, 110)';
save('Normal_002.mat', 'Normal_002');


