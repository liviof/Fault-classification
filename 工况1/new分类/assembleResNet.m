function lgraph = assembleResNet(numClasses)
    % 初始化网络层
    layers = [
        featureInputLayer(16, 'Name', 'input') % 输入层，5个特征
        fullyConnectedLayer(64, 'Name', 'fc_initial') % 初始全连接层
        reluLayer('Name', 'relu_initial')
    ];

    % 创建 layerGraph 对象
    lgraph = layerGraph(layers);

    % 添加多个残差块
    numBlocks = 3; % 根据需要调整残差块的数量
    for i = 1:numBlocks
        blockIndex = i;
        residualBlockLayers = residualBlock(64, blockIndex); % 每个残差块有64个单元
        lgraph = addLayers(lgraph, residualBlockLayers);

        if i == 1
            % 第一个残差块连接到初始层
            lgraph = connectLayers(lgraph, 'relu_initial', sprintf('fc1_%d', blockIndex));
            lgraph = connectLayers(lgraph, 'fc_initial', sprintf('add_%d/in2', blockIndex));
        else
            % 后续残差块连接到前一个残差块
            lgraph = connectLayers(lgraph, sprintf('relu2_%d', blockIndex-1), sprintf('fc1_%d', blockIndex));
            lgraph = connectLayers(lgraph, sprintf('relu2_%d', blockIndex-1), sprintf('add_%d/in2', blockIndex));
        end
    end

    % 添加输出层
    outputLayers = [
        fullyConnectedLayer(numClasses, 'Name', 'fc_final') % 输出层，numClasses 个类别
        softmaxLayer('Name', 'softmax') % Softmax 层
        classificationLayer('Name', 'classification') % 分类层
    ];
    lgraph = addLayers(lgraph, outputLayers);
    lgraph = connectLayers(lgraph, sprintf('relu2_%d', numBlocks), 'fc_final');

    % 返回 layerGraph 对象
end

function layers = residualBlock(numUnits, blockIndex)
    % 创建残差块的层
    layers = [
        fullyConnectedLayer(numUnits, 'Name', sprintf('fc1_%d', blockIndex))
        reluLayer('Name', sprintf('relu1_%d', blockIndex))
        fullyConnectedLayer(numUnits, 'Name', sprintf('fc2_%d', blockIndex))
        additionLayer(2, 'Name', sprintf('add_%d', blockIndex)) % 加法层
        reluLayer('Name', sprintf('relu2_%d', blockIndex))
    ];
end