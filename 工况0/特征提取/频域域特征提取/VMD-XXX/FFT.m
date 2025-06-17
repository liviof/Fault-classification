close all;
clear all;
clc;

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


data = OR021_6_001;
data_all = reshape(data', 1, []); % ת�ò��������� 

last_data = data(1:110, :);%����������������������������������������������������
new_data = last_data';

% ���ӻ��ź�
figure;
plot(data_all);
title('�ϳ��ź�');
xlabel('ʱ�� (s)');
ylabel('��ֵ');

% ������ʱ��
tic;

% �źŲɼ�Ƶ��Hz,��������Ƶ��
fs = 12000; %������������������������������������������������������������

row = size(last_data, 1); % ���2765
cols = size(last_data, 2); % ���2560
% ��ʼ���������
featureMatrix = zeros(row, 6);%������������������������������������������������������������



for i = 1:row
    % �Ե�i���źŽ��п��ٸ���Ҷ�任��FFT��
    fft_result = fft(last_data(i, :));
    
    % ��ȡǰ�벿�ֵ�Ƶ���ֵ���������ԳƲ��֣�
    magnitude = abs(fft_result(1:cols/2+1));  % ע��������� cols ��ż��
    
    % ����Ƶ���ᣨֻȡǰ�벿�֣�
    freq_axis = (0:cols/2)*(fs/cols);  % �����ο�˹��Ƶ��
    
    % ���� PSD
    psd = magnitude.^2;
    
    % ����������
    total_energy = sum(psd);
    
    % �����ֵƵ��
    mean_frequencies = sum(freq_axis .* psd) / total_energy;
    
    % ���� RMS Ƶ��
    rms_frequencies = sqrt(sum(freq_axis.^2 .* psd) / total_energy);
    
    % �����׼��Ƶ��
    std_frequencies = sqrt(rms_frequencies^2 - mean_frequencies^2);
    
    % ������Ƶ�ʱ�׼�Ƶ�ʷֲ��ı�׼�
    std_spectral_frequencies = sqrt(sum((freq_axis - mean_frequencies).^2 .* psd) / total_energy);
    
    % �����׷�ֵ�Ͷ�
    amplitude = magnitude;
    mu = mean(amplitude);
    sigmaSquared = var(amplitude);
    spectral_kurtosis = mean(((amplitude - mu).^4) ./ (sigmaSquared^2));
    
    % ����Ƶ�׷�ֵƵ��
    [~, peak_index] = max(psd);
    peak_frequencies = freq_axis(peak_index);
    
    
    featureMatrix(i, :) = [mean_frequencies, rms_frequencies, std_frequencies, std_spectral_frequencies, spectral_kurtosis, peak_frequencies];
    
end

pinjie = 'OR021_6_001';
% ���ɱ�����
variablename = ['pinyu_feature_FFT_' pinjie];
% �����ݴ洢�ڽṹ����
pinyu_feature_FFT_OR021_6_001 = featureMatrix;

filename = ['pinyu_feature_FFT_' pinjie '.mat'];
% ��������
save(filename, variablename);


% 
% ��ȡ����ʾ������ʱ��
elapsedTime = toc;
disp(['�ض����������ʱ��: ', num2str(elapsedTime), ' ��']);


%% 

% ��ȡ���ݳߴ�
[num_samples, num_features] = size(featureMatrix);

% ����������������
feature_names = {'��ֵƵ��', '������Ƶ��', '��׼��Ƶ��', '�׷�ֵ�Ͷ�', '��Ƶ�ʱ�׼��', 'Ƶ�׷�ֵ'};

% ����һ���µ�ͼ�δ���
figure;

subplot_rows = 2;
subplot_cols = 3;

for i = 1:num_features
    % ���㵱ǰ��ͼ��λ��
    subplot(subplot_rows, subplot_cols, i);
    
    % ���Ƶ�ǰ������
    plot(1:num_samples, featureMatrix(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('������', 'FontSize', 14);
    ylabel('����ֵ ','FontSize', 14);
    grid on;
end

% ������ͼ֮��ļ��
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);




