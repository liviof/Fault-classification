% ����������������
clear;
clc;

load 'CFS_Data'

% % ������������
numSamplesPerClass = 110;%������������������������������������������������


faultLabels1 = 1 * ones(numSamplesPerClass, 1); % ��ǩΪ2
faultLabels2 = 2 * ones(numSamplesPerClass, 1); % ��ǩΪ3
faultLabels3 = 3 * ones(numSamplesPerClass, 1); % ��ǩΪ4

faultLabels4 = 4 * ones(numSamplesPerClass, 1); % ��ǩΪ2
faultLabels5 = 5 * ones(numSamplesPerClass, 1); % ��ǩΪ3
faultLabels6 = 6 * ones(numSamplesPerClass, 1); % ��ǩΪ4

faultLabels7 = 7 * ones(numSamplesPerClass, 1); % ��ǩΪ2
faultLabels8 = 8 * ones(numSamplesPerClass, 1); % ��ǩΪ3
faultLabels9 = 9 * ones(numSamplesPerClass, 1); % ��ǩΪ4

normalLabels = 0 * ones(numSamplesPerClass, 1); % ��ǩΪ1

% �ϲ��������ݺͱ�ǩ,X��ά��Ϊ110X18
data = CFS_Data;
labels = [faultLabels1; faultLabels2; faultLabels3; faultLabels4; faultLabels5; faultLabels6; faultLabels7; faultLabels8; faultLabels9; normalLabels];


% ����ѵ�����Ͳ��Լ�7:3
cv = cvpartition(labels, 'HoldOut', 0.3);
trainIdx = training(cv);
testIdx = test(cv);

trainData = data(trainIdx, :);
trainLabels = labels(trainIdx);
testData = data(testIdx, :);
testLabels = labels(testIdx);


% % ����ѵ�����Ͳ��Լ� (70% ѵ������30% ���Լ�)
% numTrain = round(0.7 * size(data, 1));
% trainData = data(1:numTrain, :);
% trainLabels = labels(1:numTrain);
% testData = data(numTrain+1:end, :);
% testLabels = labels(numTrain+1:end);

% ����ǩת��Ϊ��������
trainLabelsCat = categorical(trainLabels);
testLabelsCat = categorical(testLabels);


% ��װ����
numClasses = numel(unique(labels)); % �������
% disp(numClasses);

lgraph = assembleResNet(numClasses);

% ����ѵ��ѡ��
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {testData, testLabelsCat}, ...
    'ValidationFrequency', 30, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

% ѵ��ģ��
net = trainNetwork(trainData, trainLabelsCat, lgraph, options);

% �ڲ��Լ��Ͻ���Ԥ��
YPred = classify(net, testData);

% ��ȡ��ʵ�ı�ǩ
YTest = testLabelsCat;

%%
% �����������
C = confusionmat(YTest, YPred);

% ����ÿ�������ٻ��ʣ�Recall��
recall = zeros(numClasses, 1);
precision = zeros(numClasses, 1);
f1Score = zeros(numClasses, 1);

for i = 1:numClasses
    TP = C(i, i); % True Positives
    FN = sum(C(i, :)) - TP; % False Negatives
    FP = sum(C(:, i)) - TP; % False Positives
    
    recall(i) = TP / (TP + FN); % Recall for class i
    precision(i) = TP / (TP + FP); % Precision for class i
    f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i)); % F1 Score for class i
end

% �����ƽ����Macro Average���ٻ��ʡ���ȷ�ʺ�F1����
macroRecall = mean(recall);
macroPrecision = mean(precision);
macroF1Score = mean(f1Score);

% ������
fprintf('Macro Average Recall: %.2f%%\n', macroRecall * 100);
fprintf('Macro Average Precision: %.2f%%\n', macroPrecision * 100);
fprintf('Macro Average F1 Score: %.2f%%\n', macroF1Score * 100);



% ���ƻ�������
figure;
confMatrix = confusionchart(YTest, YPred);
confMatrix.Title = 'Confusion Matrix';
confMatrix.ColumnSummary = 'column-normalized';
confMatrix.RowSummary = 'row-normalized';



% % ��ʾһЩ������������
% idx = randperm(numel(testLabels), 9); % ���ѡ��9������
% figure;
% for i = 1:length(idx) % ʹ�� length ������ numel����Ϊ idx ��һ������
%     subplot(3, 3, i);
%     bar(testData(idx(i), :)); % ��ʾ��������
%     title(sprintf('Predicted: %s\nTrue: %s', string(YPred(idx(i))), string(YTest(idx(i)))));
% end




% ʹ�� t-SNE ���н�ά�������ݽ��� 2D �ռ�
Y_tsne = tsne(testData, 'NumDimensions', 2);

% ���� testX ��һ����ά��������
figure;
h = gscatter(Y_tsne(:,1), Y_tsne(:,2), YPred, [], [], 15, 'filled');

% ֱ��ָ��ͼ����ǩ
classNames = {'Class1', 'Class2', 'Class3', 'Class4', 'Class5', ...
              'Class6', 'Class7', 'Class8', 'Class9', 'Normal'};

% ���ͼ��
legend(h, classNames, 'Location', 'best');

title('Classification Result on Test Data');
xlabel('Feature 1');
ylabel('Feature 2');


% �ͷŵ�ǰͼ�Σ���ֹ�������������ڸ�ͼ�������Ԫ��
hold off;

