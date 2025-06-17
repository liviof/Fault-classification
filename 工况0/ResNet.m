% 清除工作区和命令窗口
clear;
clc;

load 'CFS_Data'

% % 定义样本数量
numSamplesPerClass = 110;%————————————————————————


faultLabels1 = 1 * ones(numSamplesPerClass, 1); % 标签为2
faultLabels2 = 2 * ones(numSamplesPerClass, 1); % 标签为3
faultLabels3 = 3 * ones(numSamplesPerClass, 1); % 标签为4

faultLabels4 = 4 * ones(numSamplesPerClass, 1); % 标签为2
faultLabels5 = 5 * ones(numSamplesPerClass, 1); % 标签为3
faultLabels6 = 6 * ones(numSamplesPerClass, 1); % 标签为4

faultLabels7 = 7 * ones(numSamplesPerClass, 1); % 标签为2
faultLabels8 = 8 * ones(numSamplesPerClass, 1); % 标签为3
faultLabels9 = 9 * ones(numSamplesPerClass, 1); % 标签为4

normalLabels = 0 * ones(numSamplesPerClass, 1); % 标签为1

% 合并所有数据和标签,X的维度为110X18
data = CFS_Data;
labels = [faultLabels1; faultLabels2; faultLabels3; faultLabels4; faultLabels5; faultLabels6; faultLabels7; faultLabels8; faultLabels9; normalLabels];


% 划分训练集和测试集7:3
cv = cvpartition(labels, 'HoldOut', 0.3);
trainIdx = training(cv);
testIdx = test(cv);

trainData = data(trainIdx, :);
trainLabels = labels(trainIdx);
testData = data(testIdx, :);
testLabels = labels(testIdx);


% % 划分训练集和测试集 (70% 训练集，30% 测试集)
% numTrain = round(0.7 * size(data, 1));
% trainData = data(1:numTrain, :);
% trainLabels = labels(1:numTrain);
% testData = data(numTrain+1:end, :);
% testLabels = labels(numTrain+1:end);

% 将标签转换为分类数组
trainLabelsCat = categorical(trainLabels);
testLabelsCat = categorical(testLabels);


% 组装网络
numClasses = numel(unique(labels)); % 类别数量
% disp(numClasses);

lgraph = assembleResNet(numClasses);

% 设置训练选项
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {testData, testLabelsCat}, ...
    'ValidationFrequency', 30, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

% 训练模型
net = trainNetwork(trainData, trainLabelsCat, lgraph, options);

% 在测试集上进行预测
YPred = classify(net, testData);

% 获取真实的标签
YTest = testLabelsCat;

%%
% 计算混淆矩阵
C = confusionmat(YTest, YPred);

% 计算每个类别的召回率（Recall）
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

% 计算宏平均（Macro Average）召回率、精确率和F1分数
macroRecall = mean(recall);
macroPrecision = mean(precision);
macroF1Score = mean(f1Score);

% 输出结果
fprintf('Macro Average Recall: %.2f%%\n', macroRecall * 100);
fprintf('Macro Average Precision: %.2f%%\n', macroPrecision * 100);
fprintf('Macro Average F1 Score: %.2f%%\n', macroF1Score * 100);



% 绘制混淆矩阵
figure;
confMatrix = confusionchart(YTest, YPred);
confMatrix.Title = 'Confusion Matrix';
confMatrix.ColumnSummary = 'column-normalized';
confMatrix.RowSummary = 'row-normalized';



% % 显示一些分类结果的样本
% idx = randperm(numel(testLabels), 9); % 随机选择9个样本
% figure;
% for i = 1:length(idx) % 使用 length 而不是 numel，因为 idx 是一个向量
%     subplot(3, 3, i);
%     bar(testData(idx(i), :)); % 显示输入特征
%     title(sprintf('Predicted: %s\nTrue: %s', string(YPred(idx(i))), string(YTest(idx(i)))));
% end




% 使用 t-SNE 进行降维，将数据降到 2D 空间
Y_tsne = tsne(testData, 'NumDimensions', 2);

% 假设 testX 是一个二维特征矩阵
figure;
h = gscatter(Y_tsne(:,1), Y_tsne(:,2), YPred, [], [], 15, 'filled');

% 直接指定图例标签
classNames = {'Class1', 'Class2', 'Class3', 'Class4', 'Class5', ...
              'Class6', 'Class7', 'Class8', 'Class9', 'Normal'};

% 添加图例
legend(h, classNames, 'Location', 'best');

title('Classification Result on Test Data');
xlabel('Feature 1');
ylabel('Feature 2');


% 释放当前图形，防止后续操作继续在该图形上添加元素
hold off;

