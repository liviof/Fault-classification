close all;
clear all;
clc;

%% 重要的参数：icl（聚类中心下标、 cl（分类情况）、gammadmeo按照γ从大到小的顺序排列、inddemo 存储的是排序前 gamma 中各元素在原数组中的索引

%%
% % 时域
% load 'shiyu_feature_B007_000'
% load 'shiyu_feature_B014_000'
% load 'shiyu_feature_B021_000'
% 
% load 'shiyu_feature_IR007_000'
% load 'shiyu_feature_IR014_000'
% load 'shiyu_feature_IR021_000'
% 
% load 'shiyu_feature_OR007_6_000'
% load 'shiyu_feature_OR014_6_000'
% load 'shiyu_feature_OR021_6_000'
% 
% load 'shiyu_feature_Normal_000'
% 
% 
% load 'shiyu_feature_Normal_000_IMF1'
% load 'shiyu_feature_Normal_000_IMF2'
% load 'shiyu_feature_Normal_000_IMF5'
% 
% 
% % 频域
% load 'pinyu_feature_FFT_B007_000'
% load 'pinyu_feature_FFT_B014_000'
% load 'pinyu_feature_FFT_B021_000'
% 
% load 'pinyu_feature_FFT_IR007_000'
% load 'pinyu_feature_FFT_IR014_000'
% load 'pinyu_feature_FFT_IR021_000'
% 
% load 'pinyu_feature_FFT_OR007_6_000'
% load 'pinyu_feature_FFT_OR014_6_000'
% load 'pinyu_feature_FFT_OR021_6_000'
% 
% load 'pinyu_feature_FFT_Normal_000'
% 
% % 时频域
% load 'xaiobo_feature_B007_000'
% load 'xaiobo_feature_B014_000'
% load 'xaiobo_feature_B021_000'
% 
% load 'xaiobo_feature_IR007_000'
% load 'xaiobo_feature_IR014_000'
% load 'xaiobo_feature_IR021_000'
% 
% load 'xaiobo_feature_OR007_6_000'
% load 'xaiobo_feature_OR014_6_000'
% load 'xaiobo_feature_OR021_6_000'
% 
% load 'xaiobo_feature_Normal_000'


% PCA降维后数据
load 'reducedData'


% % 将所有特征组合成一个矩阵
% faultData1 = [shiyu_feature_B007_000, pinyu_feature_FFT_B007_000, xaiobo_feature_B007_000];
% faultData2 = [shiyu_feature_B014_000, pinyu_feature_FFT_B014_000, xaiobo_feature_B014_000];
% faultData3 = [shiyu_feature_B021_000, pinyu_feature_FFT_B021_000, xaiobo_feature_B021_000];
% 
% faultData4 = [shiyu_feature_IR007_000, pinyu_feature_FFT_IR007_000, xaiobo_feature_IR007_000];
% faultData5 = [shiyu_feature_IR014_000, pinyu_feature_FFT_IR014_000, xaiobo_feature_IR014_000];
% faultData6 = [shiyu_feature_IR021_000, pinyu_feature_FFT_IR021_000, xaiobo_feature_IR021_000];
% 
% faultData7 = [shiyu_feature_OR007_6_000, pinyu_feature_FFT_OR007_6_000, xaiobo_feature_OR007_6_000];
% faultData8 = [shiyu_feature_OR014_6_000, pinyu_feature_FFT_OR014_6_000, xaiobo_feature_OR014_6_000];
% faultData9 = [shiyu_feature_OR021_6_000, pinyu_feature_FFT_OR021_6_000, xaiobo_feature_OR021_6_000];
% 
% normalData = [shiyu_feature_Normal_000, pinyu_feature_FFT_Normal_000, xaiobo_feature_Normal_000];



% 合并所有数据和标签,X的维度为1100X22
% X = [normalData; faultData1; faultData2; faultData3; faultData4; faultData5; faultData6; faultData7; faultData8; faultData9];


% 归一化
[normalizedData, settings] = mapminmax(reducedData,0,1);

data = normalizedData';

% 记得进行矩阵转置
datax = data;

%————cl保存着分类情况、icl保存着聚类中心的原始下标

%% CFS——计算点之间截断距离
% 调用 pdist 函数来计算数据点之间的两两距离, 默认情况下它计算的是欧几里得距离
% 对于 n 个数据点，它只返回 n*(n - 1)/2 个距离值，因为距离矩阵是对称的 (24*23)/2 = 276
tic;
mdistdemo=pdist(datax);
demotest = squareform(mdistdemo);
[m, ~] = size(demotest); % 只获取行数，列数在这里不需要使用，用 ~ 忽略
temp = (m * (m - 1)) / 2;

% 使用矩阵运算生成数据点索引矩阵
[I, J] = meshgrid(1:m, 1:m);
upper_triangle_mask = triu(true(m), 1); % 创建上三角矩阵掩码，用于筛选上三角部分元素
I = I(upper_triangle_mask);
J = J(upper_triangle_mask);

% 直接提取上三角部分的距离值
distances = demotest(upper_triangle_mask);

% 组合成mdist矩阵
mdist = [I(:), J(:), distances(:)]; % 通过列拼接形成最终的mdist矩阵，将二维索引和距离值转换为列向量后拼接

% save('mdist.mat','mdist');


%% CFS——导入距离矩阵
xx=mdist;

ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
    ND=NL;  %% 确保 DN 取为第一二列最大值中的较大者，并将其作为数据点总数
end
N=size(xx,1); %% xx 第一个维度的长度，相当于文件的行数（即距离的总个数）
%% 初始化为零
for i=1:ND
    for j=1:ND
        dist(i,j)=0;
    end
end

%% 利用 xx 为 dist 数组赋值，注意输入只存了 0.5*DN(DN-1) 个值，这里将其补成了满矩阵
%% 这里不考虑对角线元素
for i=1:N
    ii=xx(i,1);
    jj=xx(i,2);
    dist(ii,jj)=xx(i,3);
    dist(jj,ii)=xx(i,3);
end

%% 确定 dc

percent=2;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);
position=round(N*percent/100); %% round 是一个四舍五入函数
sda=sort(xx(:,3)); %% 对所有距离值作升序排列
dc=sda(position);


% 计算局部密度 rho (利用 Gaussian 核)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% 将每个数据点的 rho 值初始化为零
for i=1:ND
    rho(i)=0.;
end

%%%%%% Gaussian kernel
for i=1:ND-1
    for j=i+1:ND
        rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
        rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
    end
end
%%%%%% Gaussian kernel

rhoo = rho;
% 绘制局部密度排列
figure(3);
% plot(rhoo,'-o');
plot(rhoo, '-o', ...                    % 使用圆圈作为标记
     'Color', 'k', ...
     'MarkerSize', 6, ...             % 设置标记大小为10（可以根据需要调整）
     'MarkerEdgeColor', 'k', ...       % 设置标记边缘颜色为黑色 ('k' 表示黑色)
     'MarkerFaceColor', 'k');          % 设置标记填充颜色为黑色
% 添加标题和标签
% title('Simple Line Plot');
xlabel('特征');
ylabel('局部密度ρ');



%%%%%% "Cut off" kernel
% for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
% end
%%%%%% Gaussian kernel
%% 先求矩阵列最大值，再求最大值，最后得到所有距离值中的最大值
maxd=max(max(dist));

% 将 rho 按降序排列，ordrho 保持序
[rho_sorted,ordrho]=sort(rho,'descend');

% 处理 rho 值最大的数据点
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% 生成 delta 和 nneigh 数组
for ii=2:ND
    delta(ordrho(ii))=maxd;
    for jj=1:ii-1
        if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
            delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
            nneigh(ordrho(ii))=ordrho(jj);
        % 记录 rho 值更大的数据点中与 ordrho(ii) 距离最近的点的编号 ordrho(jj)
        end
    end
end

% 生成 rho 值最大数据点的 delta 值
delta(ordrho(1))=max(delta(:));


deltaa = delta;
% 绘制局部密度排列
figure(4);
% plot(deltaa,'-o');
plot(deltaa, '-o', ...                    % 使用圆圈作为标记
     'Color', 'k', ...
     'MarkerSize', 6, ...             % 设置标记大小为10（可以根据需要调整）
     'MarkerEdgeColor', 'k', ...       % 设置标记边缘颜色为黑色 ('k' 表示黑色)
     'MarkerFaceColor', 'k');          % 设置标记填充颜色为黑色
% 添加标题和标签
% title('Simple Line Plot');
xlabel('特征');
ylabel('距离δ');

%% 决策图

fid = fopen('DECISION_GRAPH', 'w');
for i=1:ND
    fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

% 选择一个围住类中心的矩形
disp('Select a rectangle enclosing cluster centers')

% 每台计算机，句柄的根对象只有一个，就是屏幕，它的句柄总是 0
scrsz = get(0,'ScreenSize');

% 人为指定一个位置，感觉就没有那么 auto 了 :-)
figure('Position',[100 100 scrsz(3)/4. scrsz(1)/1.3]);

%% ind 和 gamma 在后面并没有用到
for i=1:ND
    ind(i)=i;
    gamma(i)=rhoo(i)*deltaa(i);
    
end
% [gammasort gammaindex]=sort(gamma,'descend')

%% 利用 rho 和 delta 画出一个所谓的“决策图”

% subplot(2,1,1)
% figure(200);
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('CFS决策图','FontSize',16,'fontname','SimHei')
xlabel (' \rho','FontSize',16,'fontname','Times New Roman');
ylabel (' \delta','FontSize',16,'fontname','Times New Roman');
set(gca,'FontSize',16);


% 使用ginput替代getrect获取矩形区域信息——————————————————————————————————
disp('请在图上依次点击矩形区域的两个对角点（例如左上角和右下角）');
[x1, y1] = ginput(1); % 获取第一个点坐标
[x2, y2] = ginput(1); % 获取第二个点坐标

% 计算矩形区域的坐标和尺寸信息
rectX = min(x1, x2); % 矩形区域左上角x坐标，取两个点击点x坐标的最小值
rectY = min(y1, y2); % 矩形区域左上角y坐标，取两个点击点y坐标的最小值
rectWidth = abs(x2 - x1); % 矩形宽度，为两个点击点x坐标差值的绝对值
rectHeight = abs(y2 - y1); % 矩形高度，为两个点击点y坐标差值的绝对值

rect = [rectX, rectY, rectWidth, rectHeight]; % 组合成类似getrect返回的矩形信息向量

% getrect 从图中用鼠标截取一个矩形区域， rect 中存放的是
% 矩形左下角的坐标 (x,y) 以及所截矩形的宽度和高度
rhomin=rect(1);
deltamin=rect(2); %% 作者承认这是个 error，已由 4 改为 2 了!

%% 初始化 cluster 个数

NCLUST=0;
% cl 为归属标志数组，cl(i)=j 表示第 i 号数据点归属于第 j 个 cluster
% 先统一将 cl 初始化为 -1
for i=1:ND
    cl(i)=-1;
end
toc;

%% 在矩形区域内统计数据点（即聚类中心）的个数
for i=1:ND
    if ( (rho(i)>rhomin) && (delta(i)>deltamin))
        NCLUST=NCLUST+1;
        cl(i)=NCLUST; %% 第 i 号数据点属于第 NCLUST 个 cluster
        icl(NCLUST)=i;%% 逆映射,第 NCLUST 个 cluster 的中心为第 i 号数据点
    end
end

fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);

disp('Performing assignation')

%% 将其他数据点归类 (assignation)
for i=1:ND
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end

% 由于是按照 rho 值从大到小的顺序遍历,循环结束后, cl 应该都变成正的值了.



%% 处理光晕点
for i=1:ND
    halo(i)=cl(i);
end

if (NCLUST>1)
    
    % 初始化数组 bord_rho 为 0,每个 cluster 定义一个 bord_rho 值
    for i=1:NCLUST
        bord_rho(i)=0.;
    end
    
    % 获取每一个 cluster 中平均密度的一个界 bord_rho
    for i=1:ND-1
        for j=i+1:ND
            % 距离足够小但不属于同一个 cluster 的 i 和 j
            if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
                rho_aver=(rho(i)+rho(j))/2.; %% 取 i,j 两点的平均局部密度
                if (rho_aver>bord_rho(cl(i)))
                    bord_rho(cl(i))=rho_aver;
                end
                if (rho_aver>bord_rho(cl(j)))
                    bord_rho(cl(j))=rho_aver;
                end
            end
        end
    end
    
    % halo 值为 0 表示为 outlier
    for i=1:ND
        if (rho(i)<bord_rho(cl(i)))
            halo(i)=0;
        end
    end
    
end

%% 逐一处理每个 cluster
for i=1:NCLUST
    nc=0; %% 用于累计当前 cluster 中数据点的个数
    nh=0; %% 用于累计当前 cluster 中核心数据点的个数
    for j=1:ND
        if (cl(j)==i)           
            nc=nc+1;
        end
        if (halo(j)==i)
            nh=nh+1;
        end
    end
    
    fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
    temp(i)=nc;
end

%% 这里是将选定的聚类中心点进行加颜色


figure(30);
cmap=colormap;  
for i=1:NCLUST  
   ic=int8((i*64.)/(NCLUST*1.));  
   hold on  
   plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));  
end  

% subplot(2,1,2)  
% disp('Performing 2D nonclassical multidimensional scaling')  
Y1 = mdscale(dist, 2, 'criterion','metricstress');  
% plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');  
% title ('2D Nonclassical multidimensional scaling','FontSize',15.0)  
% xlabel ('X')  
% ylabel ('Y')  

for i=1:ND  
 A(i,1)=0.;  
 A(i,2)=0.;  
end  


% 定义至少8个不同的标记形状
marker_shapes = {'o', 's', '^', 'd', 'v', '*', 'p', 'h'}; % 增加了两个新的标记：五角星(p) 和 六角星(h)

figure(40);
hold on;

for i = 1:NCLUST
    nn = 0;
    % 计算颜色索引，确保在 cmap 范围内
    ic = int8((i * 64) / (NCLUST + 1)); % 避免除以零或超过范围
    
    index_array = [];
    for j = 1:ND
        if halo(j) == i
            nn = nn + 1;
            A(nn, 1) = Y1(j, 1);
            A(nn, 2) = Y1(j, 2);
        end
    end

    % 确保有足够的标记形状来表示所有类别
    shape_index = mod(i - 1, length(marker_shapes)) + 1;
    current_marker = marker_shapes{shape_index};
    
    % 增大 MarkerSize 参数值，使图标更大
    plot(A(1:nn, 1), A(1:nn, 2), current_marker, ...
         'MarkerSize', 12, ... % 增大图标大小
         'MarkerFaceColor', cmap(ic,:), ...
         'MarkerEdgeColor', cmap(ic,:));
end


% 绘制聚类中心并用蓝色框选出来
center_box_width = 0.15; % 框宽度的一半（根据需要调整）%————————————————————
center_box_height = 0.15; % 框高度的一半（根据需要调整）%————————————————————


for i = 1:length(icl)
    center_x = Y1(icl(i), 1); % 获取簇中心的x坐标
    center_y = Y1(icl(i), 2); % 获取簇中心的y坐标
    
    % 绘制蓝色框
    rectangle('Position', [center_x - center_box_width, ...
                           center_y - center_box_height, ...
                           center_box_width * 2, center_box_height * 2], ...
              'EdgeColor', 'r', ... % 使用蓝色边缘
              'LineWidth', 2);      % 边框线宽为2
end


% 添加图例（可选）
legend_str = cell(1, NCLUST);
for i = 1:NCLUST
    legend_str{i} = sprintf('簇 %d', i);
end
legend(legend_str);


text(rho(icl(i)),delta(icl(i)),['NR-',num2str(icl(i))],'FontSize',10,'fontname','Times New Roman')
title('簇可视化','FontSize', 16);
ylabel('降维特征1','FontSize',16);
xlabel('降维特征2','FontSize',16);
set(gca,'FontSize',16);

grid on;
hold off;



% gammadmeo 存储的是排序后的 gamma 的值，按照从大到小的顺序排列；inddemo 存储的是排序前 gamma 中各元素在原数组中的索引
[gammadmeo,inddemo]=sort(gamma,'descend');
% 获取gammadmeo的维度
[m,n]=size(gammadmeo);
disp(n);

save('gammadmeo.mat','gammadmeo');
save('inddemo.mat','inddemo');


% 从 readdata 提取指定列
CFS_Data = reducedData(:, icl);

% 保存为 .mat 文件
save('CFS_Data.mat', 'CFS_Data');

%% 绘制
figure(50);
for i=1:n
    plot(i,gammadmeo(i),'ko--');
    hold on;
end
ylabel('The value of \gamma','FontSize',16,'fontname','Times New Roman');
xlabel('The number of sample','FontSize',16,'fontname','Times New Roman');
set(gca,'FontSize',16);

icl_size = size(icl,2);

% 分割数据为两个部分
first_five = gammadmeo(1:icl_size);
remaining = gammadmeo(icl_size+1:end);

% 绘制第一部分（前五个数据点）
figure(51);
hold on; % 启用图形保持模式，以便在同一图中绘制多个对象
plot(1:icl_size, first_five, '-rs', 'LineWidth', 2, 'MarkerFaceColor', 'r'); % 红色方形，红线.

% 绘制第二部分（剩余的数据点）
plot(icl_size+1:length(gammadmeo), remaining, '-ko', 'LineWidth', 2, 'MarkerFaceColor', 'k'); % 黑色圆形，黑线

% 添加网格、标题和标签等（可选）
grid on;
ylabel('局部密度和距离的乘积 \gamma','FontSize',16);
xlabel('输入特征','FontSize',16);

% 确保没有连接线在两部分之间
hold off;




% 绘制相同簇的信号

% 随机选择两个信号索引来绘制（这里我们简单地选择前两个）

% 提取这两个信号
common_signal1 = data(9, 1: 50);%————————————————————
common_signal2 = data(8, 1: 50);%————————————————————

% 绘制这两个信号
figure;
hold on;

% 假设信号长度相同，如果不同需要调整
common_cluster = 1:length(common_signal1);

plot(common_cluster, common_signal1, '-b', 'LineWidth', 2); % 蓝色线表示第一个信号
plot(common_cluster, common_signal2, '-r', 'LineWidth', 2); % 红色线表示第二个信号

% 添加图例、标题和轴标签
% legend('Signal 1', 'Signal 2');
title('相同簇的信号');
xlabel('样本量');
ylabel('振幅');

% 显示网格
grid on;

% 关闭保持模式
hold off;



% 绘制不同簇中心的信号
% 随机选择两个信号索引来绘制（这里我们简单地选择前两个）

% 提取这两个信号
diff_signal1 = data(3, 1: 50);%————————————————————
diff_signal2 = data(4, 1: 50);%————————————————————

figure;
hold on;

% 假设信号长度相同，如果不同需要调整
diff_cluster = 1:length(diff_signal1);

plot(diff_cluster, diff_signal1, '-b', 'LineWidth', 2); % 蓝色线表示第一个信号
plot(diff_cluster, diff_signal2, '-r', 'LineWidth', 2); % 红色线表示第二个信号

% 添加图例、标题和轴标签
% legend('Signal 1', 'Signal 2');
title('不同簇的信号');
xlabel('样本量');
ylabel('振幅');

% 显示网格
grid on;

% 关闭保持模式
hold off;