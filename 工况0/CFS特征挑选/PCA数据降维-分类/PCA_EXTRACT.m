close all;
clear all;
clc;


% Normal_000����
load 'shiyu_feature_Normal_000'
load 'shiyu_feature_Normal_000_IMF1'
load 'shiyu_feature_Normal_000_IMF2'
load 'shiyu_feature_Normal_000_IMF5'
load 'pinyu_feature_FFT_Normal_000'
load 'xaiobo_feature_Normal_000'

% B007_000����
load 'shiyu_feature_B007_000'
load 'shiyu_feature_B007_000_IMF1'
load 'shiyu_feature_B007_000_IMF2'
load 'shiyu_feature_B007_000_IMF3'
load 'pinyu_feature_FFT_B007_000'
load 'xaiobo_feature_B007_000'

% B014_000����
load 'shiyu_feature_B014_000'
load 'shiyu_feature_B014_000_IMF1'
load 'shiyu_feature_B014_000_IMF2'
load 'shiyu_feature_B014_000_IMF3'
load 'pinyu_feature_FFT_B014_000'
load 'xaiobo_feature_B014_000'

% B021_000����
load 'shiyu_feature_B021_000'
load 'shiyu_feature_B021_000_IMF1'
load 'shiyu_feature_B021_000_IMF2'
load 'shiyu_feature_B021_000_IMF3'
load 'pinyu_feature_FFT_B021_000'
load 'xaiobo_feature_B021_000'

% IR007_000����
load 'shiyu_feature_IR007_000'
load 'shiyu_feature_IR007_000_IMF1'
load 'shiyu_feature_IR007_000_IMF2'
load 'shiyu_feature_IR007_000_IMF3'
load 'pinyu_feature_FFT_IR007_000'
load 'xaiobo_feature_IR007_000'

% IR014_000����
load 'shiyu_feature_IR014_000'
load 'shiyu_feature_IR014_000_IMF1'
load 'shiyu_feature_IR014_000_IMF2'
load 'shiyu_feature_IR014_000_IMF3'
load 'pinyu_feature_FFT_IR014_000'
load 'xaiobo_feature_IR014_000'

% IR021_000����
load 'shiyu_feature_IR021_000'
load 'shiyu_feature_IR021_000_IMF1'
load 'shiyu_feature_IR021_000_IMF2'
load 'shiyu_feature_IR021_000_IMF3'
load 'pinyu_feature_FFT_IR021_000'
load 'xaiobo_feature_IR021_000'

% OR007_6_000����
load 'shiyu_feature_OR007_6_000'
load 'shiyu_feature_OR007_6_000_IMF2'
load 'shiyu_feature_OR007_6_000_IMF3'
load 'shiyu_feature_OR007_6_000_IMF4'
load 'pinyu_feature_FFT_OR007_6_000'
load 'xaiobo_feature_OR007_6_000'

% OR014_6_000����
load 'shiyu_feature_OR014_6_000'
load 'shiyu_feature_OR014_6_000_IMF2'
load 'shiyu_feature_OR014_6_000_IMF3'
load 'shiyu_feature_OR014_6_000_IMF4'
load 'pinyu_feature_FFT_OR014_6_000'
load 'xaiobo_feature_OR014_6_000'

% OR021_6_000����
load 'shiyu_feature_OR021_6_000'
load 'shiyu_feature_OR021_6_000_IMF1'
load 'shiyu_feature_OR021_6_000_IMF2'
load 'shiyu_feature_OR021_6_000_IMF3'
load 'pinyu_feature_FFT_OR021_6_000'
load 'xaiobo_feature_OR021_6_000'


load 'bear1eigen'

% ������������ϳ�һ������

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

% % ��һ��
% [normalizedData, settings] = mapminmax(combined_data,0,1);


stackedData = [B007_000_data; B014_000_data; B021_000_data; ...
               IR007_000_data; IR014_000_data; IR021_000_data; ...
               OR007_6_000_data; OR014_6_000_data; OR021_6_000_data; ...
               Normal_000_data];


% ��׼�����ݣ���ֵΪ0����׼��Ϊ1��
CFS_Data = zscore(stackedData);

save('CFS_Data.mat', 'CFS_Data');


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

%save('reducedData.mat', 'reducedData');


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


