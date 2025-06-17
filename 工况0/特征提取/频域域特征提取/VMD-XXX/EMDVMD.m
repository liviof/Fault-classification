close all;
clear all;
clc;


load Normal_001;
load B007_001;
load B014_001;
load B021_001;
load IR007_001;
load IR014_001;
load IR021_001;
load OR007_6_001;
load OR014_6_001;
load OR021_6_001;

data = OR021_6_001;%������������������������������������������������������������
data_all = reshape(data, 1, []); % ת�ò��������� 


last_data = data(1:110, :);%������������������������������������������������������������
new_data = last_data';

% ���ӻ��ź�
figure;
plot(data_all);
title('�ϳ��ź�');
xlabel('ʱ�� (s)');
ylabel('��ֵ');

% ������ʱ��
tic;


row = size(last_data, 1);
% ��ʼ���������
featureMatrix = zeros(row, 6);%������������������������������������������������������������

IMF1 = zeros(size(last_data));
IMF2 = zeros(size(last_data));
IMF3 = zeros(size(last_data));
IMF4 = zeros(size(last_data));
IMF5 = zeros(size(last_data));


% size(data, 1)
for i = 1:size(new_data, 2)
    % ��ȡ��ǰ����
    sample = new_data(:,i); 
    
    % ����������VMD����
    [u, residual, info] = vmd(sample); % �������ֵ
    center_frequencies = info.CentralFrequencies;
    
    % ��������ֵ
    freq_mean = mean(center_frequencies);
    freq_rms = sqrt(mean(center_frequencies.^2));
    freq_std = std(center_frequencies);
    
    spectral_kurtosis = kurtosis(abs(fft(sample)).^2); % �׷�ֵ�Ͷ�
    freq_std_spectral = std(abs(fft(sample))); % ��Ƶ�ʱ�׼��

     modal_energies = sum(u.^2, 1);
     [~, max_energy_index] = max(modal_energies);
     peak_frequency = center_frequencies(max_energy_index); %Ƶ�׷�ֵ
     
    % ������ֵ���浽���������
    featureMatrix(i, :) = [freq_mean, freq_rms, freq_std, spectral_kurtosis, freq_std_spectral, peak_frequency];
    
    IMF1(i, :) = u(:,1)';
    IMF2(i, :) = u(:,2)';
    IMF3(i, :) = u(:,3)';
    IMF4(i, :) = u(:,4)';
    IMF5(i, :) = u(:,5)';
end

% pinyu_featureMatrix = featureMatrix;
% % ������һ��ʹ����������
% save('pinyu_feature_bear1.mat', 'pinyu_featureMatrix');

save('IMF1.mat', 'IMF1');
save('IMF2.mat', 'IMF2');
save('IMF3.mat', 'IMF3');
save('IMF4.mat', 'IMF4');
save('IMF5.mat', 'IMF5');

% 
% ��ȡ����ʾ������ʱ��
elapsedTime = toc;
disp(['�ض����������ʱ��: ', num2str(elapsedTime), ' ��']);


%% VMD�ֽ��ԭʼ�ź�
% ʹ��ѭ���������ÿ������
for i = 1:5
    subplot(5, 1, i); % ����5����ͼ����5��1�в��֣���ǰ���Ƶ�i����ͼ
    plot(u(:, i)); % ���Ƶ�i�����ݣ�����data(:, i)��ʾѡȡ�����еĵ�i������
    title(['Column ', num2str(i)]); % ��ÿ����ͼ��ӱ��⣬��ʾ�ǵڼ�������
    xlabel('Index'); % x���ǩ��ʾ���ݵ������
    ylabel('Value'); % y���ǩ��ʾ���ݵ�ֵ
end


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


%% ��ȡǰ����ԱȽϸߵķ���


vmd_components = cat(3,IMF1, IMF2, IMF3, IMF4, IMF5);

% ʹ�� permute ��������ά��˳��ʹ��һ��ά��Ϊ 5
vmd_components = permute(vmd_components, [3 1 2]);

% ��ʼ�����ϵ������
num_components = size(vmd_components, 1);
correlation_coeffs = zeros(num_components, 1);

disp(['Size of vmd_components: ', num2str(size(vmd_components))]);


% ����ÿ�� VMD ������ԭʼ�źŵ����ϵ��
for i = 1:num_components
    % ��ÿ��ʱ������Ƥ��ѷ���ϵ������ȡƽ��ֵ
    corr_values = zeros(size(data, 1), 1);
    for j = 1:size(data, 1)
        % ��ȡ��ǰʱ���������в�ת��Ϊ������
        data_vector = data(j, :).';                  % 1024 x 1 ������
        
        % ��ȡ��ǰ VMD ������ʱ������ݲ�ת��Ϊ������
        vmd_vector = squeeze(vmd_components(i, j, :)).'; % 1024 x 1 ������
        
%         % ��֤����ά��
%         if size(data_vector) ~= [1024, 1] || size(vmd_vector) ~= [1024, 1]
%             error('Data dimensions do not match at time point %d.', j);
%         end
        
        % ����Ƥ��ѷ���ϵ��
        if all(isfinite(data_vector)) && all(isfinite(vmd_vector))
            corr_values(j) = corr(data_vector, vmd_vector');
        else
            warning('Skipping NaN or Inf values in correlation calculation at time point %d.', j);
            corr_values(j) = NaN;
        end
    end
    
    % ȡ�� NaN ֵ��ƽ��ֵ
    valid_corr_values = corr_values(~isnan(corr_values));
    if ~isempty(valid_corr_values)
        correlation_coeffs(i) = mean(valid_corr_values);
    else
        correlation_coeffs(i) = NaN;
        warning('All correlation values are NaN for component %d.', i);
    end
end



% �ҵ��������ߵ�ǰ��������
[~, idx] = sort(abs(correlation_coeffs), 'descend');
top_three_components = idx(1:3);

% ��ȡǰ�����������ߵķ���
selected_components = vmd_components(top_three_components, :);
