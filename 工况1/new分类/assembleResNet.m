function lgraph = assembleResNet(numClasses)
    % ��ʼ�������
    layers = [
        featureInputLayer(16, 'Name', 'input') % ����㣬5������
        fullyConnectedLayer(64, 'Name', 'fc_initial') % ��ʼȫ���Ӳ�
        reluLayer('Name', 'relu_initial')
    ];

    % ���� layerGraph ����
    lgraph = layerGraph(layers);

    % ��Ӷ���в��
    numBlocks = 3; % ������Ҫ�����в�������
    for i = 1:numBlocks
        blockIndex = i;
        residualBlockLayers = residualBlock(64, blockIndex); % ÿ���в����64����Ԫ
        lgraph = addLayers(lgraph, residualBlockLayers);

        if i == 1
            % ��һ���в�����ӵ���ʼ��
            lgraph = connectLayers(lgraph, 'relu_initial', sprintf('fc1_%d', blockIndex));
            lgraph = connectLayers(lgraph, 'fc_initial', sprintf('add_%d/in2', blockIndex));
        else
            % �����в�����ӵ�ǰһ���в��
            lgraph = connectLayers(lgraph, sprintf('relu2_%d', blockIndex-1), sprintf('fc1_%d', blockIndex));
            lgraph = connectLayers(lgraph, sprintf('relu2_%d', blockIndex-1), sprintf('add_%d/in2', blockIndex));
        end
    end

    % ��������
    outputLayers = [
        fullyConnectedLayer(numClasses, 'Name', 'fc_final') % ����㣬numClasses �����
        softmaxLayer('Name', 'softmax') % Softmax ��
        classificationLayer('Name', 'classification') % �����
    ];
    lgraph = addLayers(lgraph, outputLayers);
    lgraph = connectLayers(lgraph, sprintf('relu2_%d', numBlocks), 'fc_final');

    % ���� layerGraph ����
end

function layers = residualBlock(numUnits, blockIndex)
    % �����в��Ĳ�
    layers = [
        fullyConnectedLayer(numUnits, 'Name', sprintf('fc1_%d', blockIndex))
        reluLayer('Name', sprintf('relu1_%d', blockIndex))
        fullyConnectedLayer(numUnits, 'Name', sprintf('fc2_%d', blockIndex))
        additionLayer(2, 'Name', sprintf('add_%d', blockIndex)) % �ӷ���
        reluLayer('Name', sprintf('relu2_%d', blockIndex))
    ];
end