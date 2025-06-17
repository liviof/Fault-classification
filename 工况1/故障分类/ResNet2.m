% 清除工作区和命令窗口
clear;
clc;

load 'CFS_Data'

% 定义样本数量
numSamplesPerClass = 110;

% 标签
faultLabels1 = 1 * ones(numSamplesPerClass, 1);
faultLabels2 = 2 * ones(numSamplesPerClass, 1);
faultLabels3 = 3 * ones(numSamplesPerClass, 1);
faultLabels4 = 4 * ones(numSamplesPerClass, 1);
faultLabels5 = 5 * ones(numSamplesPerClass, 1);
faultLabels6 = 6 * ones(numSamplesPerClass, 1);
faultLabels7 = 7 * ones(numSamplesPerClass, 1);
faultLabels8 = 8 * ones(numSamplesPerClass, 1);
faultLabels9 = 9 * ones(numSamplesPerClass, 1);
normalLabels = 0 * ones(numSamplesPerClass, 1);

% 合并所有数据和标签
data = CFS_Data;
labels = [faultLabels1; faultLabels2; faultLabels3; faultLabels4; faultLabels5; ...
          faultLabels6; faultLabels7; faultLabels8; faultLabels9; normalLabels];

% 划分训练集和测试集7:3
cv = cvpartition(labels, 'HoldOut', 0.3);
trainIdx = training(cv);
testIdx = test(cv);

trainData = data(trainIdx, :);
trainLabels = labels(trainIdx);
testData = data(testIdx, :);
testLabels = labels(testIdx);

% 转换为分类标签
trainLabelsCat = categorical(trainLabels);
testLabelsCat = categorical(testLabels);

% 构建网络
numClasses = numel(unique(labels));
lgraph = assembleResNet(numClasses);

% 设置训练选项（包含验证集监控）
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {testData, testLabelsCat}, ...
    'ValidationFrequency', 30, ...
    'Verbose', false, ...
    'Plots', 'training-progress', ...
    'OutputFcn', @(info)stopIfAccuracyNotImproving(info,3));

% 训练网络并返回训练信息
[net, info] = trainNetwork(trainData, trainLabelsCat, lgraph, options);

% 测试集预测
YPred = classify(net, testData);
YTest = testLabelsCat;

% 混淆矩阵
C = confusionmat(YTest, YPred);
numClasses = size(C, 1);
recall = zeros(numClasses, 1);
precision = zeros(numClasses, 1);
f1Score = zeros(numClasses, 1);

for i = 1:numClasses
    TP = C(i, i);
    FN = sum(C(i, :)) - TP;
    FP = sum(C(:, i)) - TP;
    
    recall(i) = TP / (TP + FN);
    precision(i) = TP / (TP + FP);
    f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

macroRecall = mean(recall);
macroPrecision = mean(precision);
macroF1Score = mean(f1Score);

fprintf('Macro Average Recall: %.2f%%\n', macroRecall * 100);
fprintf('Macro Average Precision: %.2f%%\n', macroPrecision * 100);
fprintf('Macro Average F1 Score: %.2f%%\n', macroF1Score * 100);

% 混淆矩阵图
figure;
confMatrix = confusionchart(YTest, YPred);
confMatrix.Title = '混淆矩阵';
confMatrix.ColumnSummary = 'column-normalized';
confMatrix.RowSummary = 'row-normalized';

% 可视化训练准确率和验证准确率
figure;
plot(info.TrainingAccuracy, 'LineWidth', 1.5);
hold on;
plot(info.ValidationAccuracy, 'LineWidth', 1.5);
xlabel('迭代次数');
ylabel('准确率 (%)');
legend('训练准确率', '验证准确率');
title('训练与验证准确率变化');
grid on;

% t-SNE 降维可视化预测结果
Y_tsne = tsne(testData, 'NumDimensions', 2);
figure;
h = gscatter(Y_tsne(:,1), Y_tsne(:,2), YPred, [], [], 15, 'filled');
classNames = {'类别1', '类别2', '类别3', '类别4', '类别5', ...
              '类别6', '类别7', '类别8', '类别9', '正常'};
legend(h, classNames, 'Location', 'best');
title('测试数据分类结果');
xlabel('特征 1');
ylabel('特征 2');
hold off;

function stop = stopIfAccuracyNotImproving(info, N)
% info: training info 结构体
% N: 若干轮内验证准确率未提升则终止训练
persistent bestValAccuracy
persistent valLag

stop = false;

% 初始化
if info.State == "start"
    bestValAccuracy = 0;
    valLag = 0;
elseif info.State == "iteration"
    if ~isempty(info.ValidationAccuracy)
        if info.ValidationAccuracy > bestValAccuracy
            bestValAccuracy = info.ValidationAccuracy;
            valLag = 0;
        else
            valLag = valLag + 1;
        end

        % 如果验证准确率连续N次没有提升，则提前停止
        if valLag >= N
            stop = true;
        end
    end
elseif info.State == "done"
    clear bestValAccuracy
    clear valLag
end
end
