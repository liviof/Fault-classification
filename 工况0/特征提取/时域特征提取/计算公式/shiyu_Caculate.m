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


load IMF1;
load IMF2;
load IMF3;
% load IMF4;
% load IMF5;


% % IMF����������Ƶ����ȡʱ����õ��ˣ����Բ���Ҫ�ٲü�
% data_ll = bear1(1:2765, :);
% 
% 
% %ԭʼ������Ϣ
% oneLongVector = reshape(data_ll', 1, []); % ת�ò��������� 
% 
% 
% figure;
% plot(oneLongVector);
% title('Bear1 ԭʼ�ź�', 'FontSize', 22);
% xlabel('������', 'FontSize', 20);
% ylabel('���', 'FontSize', 20);
% grid on;



data = IMF3; %��������������������������������������������������������

% ���������������ȥ��ʧЧ�׶�
row = size(data, 1);
new_data = data(1:row, :);

% ���ڴ洢������������ľ����ʼ��
features = zeros(row, 12);


for i = 1:size(new_data, 1)
    
    segment = new_data(i, :); % ��ȡ��ǰ�ε�����
% ���������
    abs_mean = mean(abs(segment));            % ���Ծ�ֵ
    peak_value = max(abs(segment));           % ��ֵ (����ֵ)
    var_value = var(segment);                 % ����
    peak_to_peak = max(segment) - min(segment); % ���ֵ
    kurtosis_factor = kurtosis(segment);      % �������
    rms_value = sqrt(mean(segment.^2));       % ������ (RMS)

    kurtosisValue = kurtosis(segment); %�Ͷ�      
    stdValue = std(segment); %��׼��
    kurtosisFactor = kurtosisValue / stdValue;  % �Ͷ�����  
    
    shape_factor = rms_value / mean(abs(segment));    % ��״����
    impulse_factor = peak_value / mean(abs(segment)); % ��������
    root_amplitude = sqrt(mean(sqrt(abs(segment))));  % �����
    crest_factor = peak_value / rms_value;      % ��������
    skewness_factor = skewness(segment);        % ƫ������
    
    % ����ǰ�εĸ��������δ���������Ķ�Ӧ��
    features(i, :) = [abs_mean, peak_value, var_value, peak_to_peak, ...
                      kurtosis_factor, rms_value, kurtosisFactor, ...
                      shape_factor, impulse_factor, root_amplitude, ...
                      crest_factor, skewness_factor];
end


% shiyu_features = features;
% % �� 'features' �������浽��ǰĿ¼�µ� 'features.mat' �ļ���
% save('shiyu_features_bear1.mat', 'shiyu_features');

% features_Normal_000 = features;
% % �� 'features' �������浽��ǰĿ¼�µ� 'features.mat' �ļ���
% save('shiyu_Normal_000_features.mat', 'features_Normal_000');


pinjie = 'OR021_6_001_IMF3';%��������������������������������������������������������
% ���ɱ�����
variablename = ['shiyu_feature_' pinjie];
% �����ݴ洢�ڽṹ����
shiyu_feature_OR021_6_001_IMF3 = features;%��������������������������������������������������������

filename = ['shiyu_feature_' pinjie '.mat'];
% ��������
save(filename, variablename);



% ��ȡ���ݳߴ�
[num_samples, num_features] = size(features);

% ����������������
feature_names = {
    '���Ծ�ֵ', '��ֵ', '����', '���ֵ', '�������', ...
    '������', '�Ͷ�����', '��״����', '��������', ...
    '�����', '��������', 'ƫ������', '����ϵ��'
};

% ����һ���µ�ͼ�δ���
figure;

% ������ͼ���֣�4��4�У����һ�п��ܲ�����
subplot_rows = 3;
subplot_cols = 4;

for i = 1:num_features
    % ���㵱ǰ��ͼ��λ��
    subplot(subplot_rows, subplot_cols, i);
    
    % ���Ƶ�ǰ������
    plot(1:num_samples, features(:, i));
    title(feature_names{i}, 'FontSize', 18);
    xlabel('������', 'FontSize', 14);
    ylabel('����ֵ ','FontSize', 14);
    grid on;
end

% ������ͼ֮��ļ��
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
