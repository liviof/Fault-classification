close all;
clear all;
clc;


% Normal_001����
load 'shiyu_feature_Normal_001'
load 'shiyu_feature_Normal_001_IMF3'
load 'shiyu_feature_Normal_001_IMF2'
load 'shiyu_feature_Normal_001_IMF5'
load 'pinyu_feature_FFT_Normal_001'
load 'xaiobo_feature_Normal_001'

% B007_001����
load 'shiyu_feature_B007_001'
load 'shiyu_feature_B007_001_IMF1'
load 'shiyu_feature_B007_001_IMF2'
load 'shiyu_feature_B007_001_IMF3'
load 'pinyu_feature_FFT_B007_001'
load 'xaiobo_feature_B007_001'

% B014_001����
load 'shiyu_feature_B014_001'
load 'shiyu_feature_B014_001_IMF1'
load 'shiyu_feature_B014_001_IMF2'
load 'shiyu_feature_B014_001_IMF3'
load 'pinyu_feature_FFT_B014_001'
load 'xaiobo_feature_B014_001'

% B021_000����
load 'shiyu_feature_B021_001'
load 'shiyu_feature_B021_001_IMF1'
load 'shiyu_feature_B021_001_IMF2'
load 'shiyu_feature_B021_001_IMF3'
load 'pinyu_feature_FFT_B021_001'
load 'xaiobo_feature_B021_001'

% IR007_001����
load 'shiyu_feature_IR007_001'
load 'shiyu_feature_IR007_001_IMF1'
load 'shiyu_feature_IR007_001_IMF2'
load 'shiyu_feature_IR007_001_IMF3'
load 'pinyu_feature_FFT_IR007_001'
load 'xaiobo_feature_IR007_001'

% IR014_001����
load 'shiyu_feature_IR014_001'
load 'shiyu_feature_IR014_001_IMF1'
load 'shiyu_feature_IR014_001_IMF2'
load 'shiyu_feature_IR014_001_IMF3'
load 'pinyu_feature_FFT_IR014_001'
load 'xaiobo_feature_IR014_001'

% IR021_001����
load 'shiyu_feature_IR021_001'
load 'shiyu_feature_IR021_001_IMF4'
load 'shiyu_feature_IR021_001_IMF2'
load 'shiyu_feature_IR021_001_IMF3'
load 'pinyu_feature_FFT_IR021_001'
load 'xaiobo_feature_IR021_001'

% OR007_6_001����
load 'shiyu_feature_OR007_6_001'
load 'shiyu_feature_OR007_6_001_IMF2'
load 'shiyu_feature_OR007_6_001_IMF3'
load 'shiyu_feature_OR007_6_001_IMF4'
load 'pinyu_feature_FFT_OR007_6_001'
load 'xaiobo_feature_OR007_6_001'

% OR014_6_001����
load 'shiyu_feature_OR014_6_001'
load 'shiyu_feature_OR014_6_001_IMF2'
load 'shiyu_feature_OR014_6_001_IMF3'
load 'shiyu_feature_OR014_6_001_IMF4'
load 'pinyu_feature_FFT_OR014_6_001'
load 'xaiobo_feature_OR014_6_001'

% OR021_6_001����
load 'shiyu_feature_OR021_6_001'
load 'shiyu_feature_OR021_6_001_IMF1'
load 'shiyu_feature_OR021_6_001_IMF2'
load 'shiyu_feature_OR021_6_001_IMF3'
load 'pinyu_feature_FFT_OR021_6_001'
load 'xaiobo_feature_OR021_6_001'


load 'bear1eigen'

% ������������ϳ�һ������

% combined_data = [data1, data22, data3, newData_IMF1, newData_IMF2, newData_IMF3, newData_IMF4, newData_IMF5];
Normal_001_data = [shiyu_feature_Normal_001, shiyu_feature_Normal_001_IMF2, shiyu_feature_Normal_001_IMF3, shiyu_feature_Normal_001_IMF5,... 
    pinyu_feature_FFT_Normal_001, xaiobo_feature_Normal_001];

B007_001_data = [shiyu_feature_B007_001, shiyu_feature_B007_001_IMF1, shiyu_feature_B007_001_IMF2, shiyu_feature_B007_001_IMF3,... 
    pinyu_feature_FFT_B007_001, xaiobo_feature_B007_001];
B014_001_data = [shiyu_feature_B014_001, shiyu_feature_B014_001_IMF1, shiyu_feature_B014_001_IMF2, shiyu_feature_B014_001_IMF3,... 
    pinyu_feature_FFT_B014_001, xaiobo_feature_B014_001];
B021_001_data = [shiyu_feature_B021_001, shiyu_feature_B021_001_IMF1, shiyu_feature_B021_001_IMF2, shiyu_feature_B021_001_IMF3,... 
    pinyu_feature_FFT_B021_001, xaiobo_feature_B021_001];

IR007_001_data = [shiyu_feature_IR007_001, shiyu_feature_IR007_001_IMF1, shiyu_feature_IR007_001_IMF2, shiyu_feature_IR007_001_IMF3,... 
    pinyu_feature_FFT_IR007_001, xaiobo_feature_IR007_001];
IR014_001_data = [shiyu_feature_IR014_001, shiyu_feature_IR014_001_IMF1, shiyu_feature_IR014_001_IMF2, shiyu_feature_IR014_001_IMF3,... 
    pinyu_feature_FFT_IR014_001, xaiobo_feature_IR014_001];
IR021_001_data = [shiyu_feature_IR021_001, shiyu_feature_IR021_001_IMF2, shiyu_feature_IR021_001_IMF3, shiyu_feature_IR021_001_IMF4,... 
    pinyu_feature_FFT_IR021_001, xaiobo_feature_IR021_001];

OR007_6_001_data = [shiyu_feature_OR007_6_001, shiyu_feature_OR007_6_001_IMF2, shiyu_feature_OR007_6_001_IMF3, shiyu_feature_OR007_6_001_IMF4,... 
    pinyu_feature_FFT_OR007_6_001, xaiobo_feature_OR007_6_001];
OR014_6_001_data = [shiyu_feature_OR014_6_001, shiyu_feature_OR014_6_001_IMF2, shiyu_feature_OR014_6_001_IMF3, shiyu_feature_OR014_6_001_IMF4,... 
    pinyu_feature_FFT_OR014_6_001, xaiobo_feature_OR014_6_001];
OR021_6_001_data = [shiyu_feature_OR021_6_001, shiyu_feature_OR021_6_001_IMF1, shiyu_feature_OR021_6_001_IMF2, shiyu_feature_OR021_6_001_IMF3,... 
    pinyu_feature_FFT_OR021_6_001, xaiobo_feature_OR021_6_001];

% % ��һ��
% [normalizedData, settings] = mapminmax(combined_data,0,1);


stackedData = [B007_001_data; B014_001_data; B021_001_data; ...
               IR007_001_data; IR014_001_data; IR021_001_data; ...
               OR007_6_001_data; OR014_6_001_data; OR021_6_001_data; ...
               Normal_001_data];


% ��׼�����ݣ���ֵΪ0����׼��Ϊ1��
data = zscore(stackedData);

% ִ�� PCA
[coeff, score, latent, ~, explained] = pca(data);

% ��ʾÿ�����ɷֽ��͵ķ���ٷֱ�
disp('Explained variance by each principal component:');
disp(explained);

% �����ۻ��������ͼ
figure;
cumsum_explained = cumsum(explained);
plot(cumsum_explained, 'LineWidth', 2);
xlabel('���ɷ�����');
ylabel('�ۼƽ��ͷ��� (%)');
title('���ɷ��������ۼƽ��ͷ����ϵͼ');
grid on;

% ѡ��Ҫ���������ɷ�����
numComponents = find(cumsum_explained >= 97, 1); % ѡ���ܹ��������� 95% ��������ɷ�����
fprintf('���������ɷ�����: %d\n', numComponents);

% ��ά�������
reducedData = score(:, 1:numComponents);

% ��ʾ��ά������ݳߴ�
disp(['��ά������ݳߴ�: ', num2str(size(reducedData))]);

save('reducedData.mat', 'reducedData');


% �����ά�������ά��С�ڵ��� 3�����п��ӻ�
if numComponents == 2
    % ��ά���ӻ�
    figure;
    scatter(reducedData(:, 1), reducedData(:, 2));
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    title('PCA Reduced Data (2D)');
    grid on;
elseif numComponents == 3
    % ��ά���ӻ�
    figure;
    scatter3(reducedData(:, 1), reducedData(:, 2), reducedData(:, 3));
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    zlabel('Principal Component 3');
    title('PCA Reduced Data (3D)');
    grid on;
end

% �ع����ݲ������ؽ����
reconstructedData = reducedData * coeff(:, 1:numComponents)';
reconstructionError = mean(sqrt(sum((data - reconstructedData).^2, 2)));
fprintf('�ع����: %f\n', reconstructionError);
numFeatures = size(stackedData, 2);
disp(['������ ', num2str(numFeatures)]);


