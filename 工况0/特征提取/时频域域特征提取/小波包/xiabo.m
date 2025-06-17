clear all;
close all;

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

data = Normal_001;%������������������������������������������������������������
data_all = reshape(data', 1, []); % ת�ò��������� 

row = 110;
new_data = data(1:row, :);


% ���ӻ��ź�
figure;
plot(data_all);
title('�ϳ��ź�');
xlabel('ʱ�� (s)');
ylabel('��ֵ');


% ������ʱ��
tic;


% ��ʼ���������
energy_matrix = zeros(row, 4);



for i = 1:size(new_data, 1)

    sample = new_data(i, :);
    % С�����ֽ����
    wname = 'db4'; % С��������������ѡ��Daubechies 4С��
    level = 2; % �ֽ����������Ϊ2

    % ����С�����ֽ�
    wp = wpdec(sample, level, wname);

    % ����ÿ���ڵ������
    node_energies = wenergy(wp);

    energy_matrix(i, :) = node_energies;

end


pinjie = 'Normal_001';%������������������������������������������������������������
% ���ɱ�����
variablename = ['xaiobo_feature_' pinjie];
% �����ݴ洢�ڽṹ����
xaiobo_feature_Normal_001 = energy_matrix;%������������������������������������������������������������

filename = ['xaiobo_feature_' pinjie '.mat'];
% ��������
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
% ��ȡ����ʾ������ʱ��
elapsedTime = toc;
disp(['�ض����������ʱ��: ', num2str(elapsedTime), ' ��']);


% ��ȡ���ݳߴ�
[num_samples, num_features] = size(energy_matrix);

% ����������������
feature_names = {'����С�����ֽ��1�ڵ�����', '����С�����ֽ��2�ڵ�����', '����С�����ֽ��3�ڵ�����', '����С�����ֽ��4�ڵ�����'};

% ����һ���µ�ͼ�δ���
figure;

subplot_rows = 2;
subplot_cols = 2;

for i = 1:num_features
    % ���㵱ǰ��ͼ��λ��
    subplot(subplot_rows, subplot_cols, i);
    
    % ���Ƶ�ǰ������
    plot(1:num_samples, energy_matrix(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('������', 'FontSize', 14);
    ylabel('����ֵ ','FontSize', 14);
    grid on;
end

% ������ͼ֮��ļ��
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);









