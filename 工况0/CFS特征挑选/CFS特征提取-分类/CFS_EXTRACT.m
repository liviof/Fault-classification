close all;
clear all;
clc;

%% ��Ҫ�Ĳ�����icl�����������±ꡢ cl�������������gammadmeo���զôӴ�С��˳�����С�inddemo �洢��������ǰ gamma �и�Ԫ����ԭ�����е�����

%%
% % ʱ��
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
% % Ƶ��
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
% % ʱƵ��
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


% PCA��ά������
load 'reducedData'


% % ������������ϳ�һ������
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



% �ϲ��������ݺͱ�ǩ,X��ά��Ϊ1100X22
% X = [normalData; faultData1; faultData2; faultData3; faultData4; faultData5; faultData6; faultData7; faultData8; faultData9];


% ��һ��
[normalizedData, settings] = mapminmax(reducedData,0,1);

data = normalizedData';

% �ǵý��о���ת��
datax = data;

%��������cl�����ŷ��������icl�����ž������ĵ�ԭʼ�±�

%% CFS���������֮��ضϾ���
% ���� pdist �������������ݵ�֮�����������, Ĭ����������������ŷ����þ���
% ���� n �����ݵ㣬��ֻ���� n*(n - 1)/2 ������ֵ����Ϊ��������ǶԳƵ� (24*23)/2 = 276
tic;
mdistdemo=pdist(datax);
demotest = squareform(mdistdemo);
[m, ~] = size(demotest); % ֻ��ȡ���������������ﲻ��Ҫʹ�ã��� ~ ����
temp = (m * (m - 1)) / 2;

% ʹ�þ��������������ݵ���������
[I, J] = meshgrid(1:m, 1:m);
upper_triangle_mask = triu(true(m), 1); % ���������Ǿ������룬����ɸѡ�����ǲ���Ԫ��
I = I(upper_triangle_mask);
J = J(upper_triangle_mask);

% ֱ����ȡ�����ǲ��ֵľ���ֵ
distances = demotest(upper_triangle_mask);

% ��ϳ�mdist����
mdist = [I(:), J(:), distances(:)]; % ͨ����ƴ���γ����յ�mdist���󣬽���ά�����;���ֵת��Ϊ��������ƴ��

% save('mdist.mat','mdist');


%% CFS��������������
xx=mdist;

ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
    ND=NL;  %% ȷ�� DN ȡΪ��һ�������ֵ�еĽϴ��ߣ���������Ϊ���ݵ�����
end
N=size(xx,1); %% xx ��һ��ά�ȵĳ��ȣ��൱���ļ�����������������ܸ�����
%% ��ʼ��Ϊ��
for i=1:ND
    for j=1:ND
        dist(i,j)=0;
    end
end

%% ���� xx Ϊ dist ���鸳ֵ��ע������ֻ���� 0.5*DN(DN-1) ��ֵ�����ｫ�䲹����������
%% ���ﲻ���ǶԽ���Ԫ��
for i=1:N
    ii=xx(i,1);
    jj=xx(i,2);
    dist(ii,jj)=xx(i,3);
    dist(jj,ii)=xx(i,3);
end

%% ȷ�� dc

percent=2;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);
position=round(N*percent/100); %% round ��һ���������뺯��
sda=sort(xx(:,3)); %% �����о���ֵ����������
dc=sda(position);


% ����ֲ��ܶ� rho (���� Gaussian ��)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��
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
% ���ƾֲ��ܶ�����
figure(3);
% plot(rhoo,'-o');
plot(rhoo, '-o', ...                    % ʹ��ԲȦ��Ϊ���
     'Color', 'k', ...
     'MarkerSize', 6, ...             % ���ñ�Ǵ�СΪ10�����Ը�����Ҫ������
     'MarkerEdgeColor', 'k', ...       % ���ñ�Ǳ�Ե��ɫΪ��ɫ ('k' ��ʾ��ɫ)
     'MarkerFaceColor', 'k');          % ���ñ�������ɫΪ��ɫ
% ��ӱ���ͱ�ǩ
% title('Simple Line Plot');
xlabel('����');
ylabel('�ֲ��ܶȦ�');



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
%% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ
maxd=max(max(dist));

% �� rho ���������У�ordrho ������
[rho_sorted,ordrho]=sort(rho,'descend');

% ���� rho ֵ�������ݵ�
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% ���� delta �� nneigh ����
for ii=2:ND
    delta(ordrho(ii))=maxd;
    for jj=1:ii-1
        if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
            delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
            nneigh(ordrho(ii))=ordrho(jj);
        % ��¼ rho ֵ��������ݵ����� ordrho(ii) ��������ĵ�ı�� ordrho(jj)
        end
    end
end

% ���� rho ֵ������ݵ�� delta ֵ
delta(ordrho(1))=max(delta(:));


deltaa = delta;
% ���ƾֲ��ܶ�����
figure(4);
% plot(deltaa,'-o');
plot(deltaa, '-o', ...                    % ʹ��ԲȦ��Ϊ���
     'Color', 'k', ...
     'MarkerSize', 6, ...             % ���ñ�Ǵ�СΪ10�����Ը�����Ҫ������
     'MarkerEdgeColor', 'k', ...       % ���ñ�Ǳ�Ե��ɫΪ��ɫ ('k' ��ʾ��ɫ)
     'MarkerFaceColor', 'k');          % ���ñ�������ɫΪ��ɫ
% ��ӱ���ͱ�ǩ
% title('Simple Line Plot');
xlabel('����');
ylabel('�����');

%% ����ͼ

fid = fopen('DECISION_GRAPH', 'w');
for i=1:ND
    fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

% ѡ��һ��Χס�����ĵľ���
disp('Select a rectangle enclosing cluster centers')

% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0
scrsz = get(0,'ScreenSize');

% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)
figure('Position',[100 100 scrsz(3)/4. scrsz(1)/1.3]);

%% ind �� gamma �ں��沢û���õ�
for i=1:ND
    ind(i)=i;
    gamma(i)=rhoo(i)*deltaa(i);
    
end
% [gammasort gammaindex]=sort(gamma,'descend')

%% ���� rho �� delta ����һ����ν�ġ�����ͼ��

% subplot(2,1,1)
% figure(200);
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('CFS����ͼ','FontSize',16,'fontname','SimHei')
xlabel (' \rho','FontSize',16,'fontname','Times New Roman');
ylabel (' \delta','FontSize',16,'fontname','Times New Roman');
set(gca,'FontSize',16);


% ʹ��ginput���getrect��ȡ����������Ϣ��������������������������������������������������������������������
disp('����ͼ�����ε����������������Խǵ㣨�������ϽǺ����½ǣ�');
[x1, y1] = ginput(1); % ��ȡ��һ��������
[x2, y2] = ginput(1); % ��ȡ�ڶ���������

% ����������������ͳߴ���Ϣ
rectX = min(x1, x2); % �����������Ͻ�x���꣬ȡ���������x�������Сֵ
rectY = min(y1, y2); % �����������Ͻ�y���꣬ȡ���������y�������Сֵ
rectWidth = abs(x2 - x1); % ���ο�ȣ�Ϊ���������x�����ֵ�ľ���ֵ
rectHeight = abs(y2 - y1); % ���θ߶ȣ�Ϊ���������y�����ֵ�ľ���ֵ

rect = [rectX, rectY, rectWidth, rectHeight]; % ��ϳ�����getrect���صľ�����Ϣ����

% getrect ��ͼ��������ȡһ���������� rect �д�ŵ���
% �������½ǵ����� (x,y) �Լ����ؾ��εĿ�Ⱥ͸߶�
rhomin=rect(1);
deltamin=rect(2); %% ���߳������Ǹ� error������ 4 ��Ϊ 2 ��!

%% ��ʼ�� cluster ����

NCLUST=0;
% cl Ϊ������־���飬cl(i)=j ��ʾ�� i �����ݵ�����ڵ� j �� cluster
% ��ͳһ�� cl ��ʼ��Ϊ -1
for i=1:ND
    cl(i)=-1;
end
toc;

%% �ھ���������ͳ�����ݵ㣨���������ģ��ĸ���
for i=1:ND
    if ( (rho(i)>rhomin) && (delta(i)>deltamin))
        NCLUST=NCLUST+1;
        cl(i)=NCLUST; %% �� i �����ݵ����ڵ� NCLUST �� cluster
        icl(NCLUST)=i;%% ��ӳ��,�� NCLUST �� cluster ������Ϊ�� i �����ݵ�
    end
end

fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);

disp('Performing assignation')

%% ���������ݵ���� (assignation)
for i=1:ND
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end

% �����ǰ��� rho ֵ�Ӵ�С��˳�����,ѭ��������, cl Ӧ�ö��������ֵ��.



%% ������ε�
for i=1:ND
    halo(i)=cl(i);
end

if (NCLUST>1)
    
    % ��ʼ������ bord_rho Ϊ 0,ÿ�� cluster ����һ�� bord_rho ֵ
    for i=1:NCLUST
        bord_rho(i)=0.;
    end
    
    % ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho
    for i=1:ND-1
        for j=i+1:ND
            % �����㹻С��������ͬһ�� cluster �� i �� j
            if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
                rho_aver=(rho(i)+rho(j))/2.; %% ȡ i,j �����ƽ���ֲ��ܶ�
                if (rho_aver>bord_rho(cl(i)))
                    bord_rho(cl(i))=rho_aver;
                end
                if (rho_aver>bord_rho(cl(j)))
                    bord_rho(cl(j))=rho_aver;
                end
            end
        end
    end
    
    % halo ֵΪ 0 ��ʾΪ outlier
    for i=1:ND
        if (rho(i)<bord_rho(cl(i)))
            halo(i)=0;
        end
    end
    
end

%% ��һ����ÿ�� cluster
for i=1:NCLUST
    nc=0; %% �����ۼƵ�ǰ cluster �����ݵ�ĸ���
    nh=0; %% �����ۼƵ�ǰ cluster �к������ݵ�ĸ���
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

%% �����ǽ�ѡ���ľ������ĵ���м���ɫ


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


% ��������8����ͬ�ı����״
marker_shapes = {'o', 's', '^', 'd', 'v', '*', 'p', 'h'}; % �����������µı�ǣ������(p) �� ������(h)

figure(40);
hold on;

for i = 1:NCLUST
    nn = 0;
    % ������ɫ������ȷ���� cmap ��Χ��
    ic = int8((i * 64) / (NCLUST + 1)); % ���������򳬹���Χ
    
    index_array = [];
    for j = 1:ND
        if halo(j) == i
            nn = nn + 1;
            A(nn, 1) = Y1(j, 1);
            A(nn, 2) = Y1(j, 2);
        end
    end

    % ȷ�����㹻�ı����״����ʾ�������
    shape_index = mod(i - 1, length(marker_shapes)) + 1;
    current_marker = marker_shapes{shape_index};
    
    % ���� MarkerSize ����ֵ��ʹͼ�����
    plot(A(1:nn, 1), A(1:nn, 2), current_marker, ...
         'MarkerSize', 12, ... % ����ͼ���С
         'MarkerFaceColor', cmap(ic,:), ...
         'MarkerEdgeColor', cmap(ic,:));
end


% ���ƾ������Ĳ�����ɫ��ѡ����
center_box_width = 0.15; % ���ȵ�һ�루������Ҫ������%����������������������������������������
center_box_height = 0.15; % ��߶ȵ�һ�루������Ҫ������%����������������������������������������


for i = 1:length(icl)
    center_x = Y1(icl(i), 1); % ��ȡ�����ĵ�x����
    center_y = Y1(icl(i), 2); % ��ȡ�����ĵ�y����
    
    % ������ɫ��
    rectangle('Position', [center_x - center_box_width, ...
                           center_y - center_box_height, ...
                           center_box_width * 2, center_box_height * 2], ...
              'EdgeColor', 'r', ... % ʹ����ɫ��Ե
              'LineWidth', 2);      % �߿��߿�Ϊ2
end


% ���ͼ������ѡ��
legend_str = cell(1, NCLUST);
for i = 1:NCLUST
    legend_str{i} = sprintf('�� %d', i);
end
legend(legend_str);


text(rho(icl(i)),delta(icl(i)),['NR-',num2str(icl(i))],'FontSize',10,'fontname','Times New Roman')
title('�ؿ��ӻ�','FontSize', 16);
ylabel('��ά����1','FontSize',16);
xlabel('��ά����2','FontSize',16);
set(gca,'FontSize',16);

grid on;
hold off;



% gammadmeo �洢���������� gamma ��ֵ�����մӴ�С��˳�����У�inddemo �洢��������ǰ gamma �и�Ԫ����ԭ�����е�����
[gammadmeo,inddemo]=sort(gamma,'descend');
% ��ȡgammadmeo��ά��
[m,n]=size(gammadmeo);
disp(n);

save('gammadmeo.mat','gammadmeo');
save('inddemo.mat','inddemo');


% �� readdata ��ȡָ����
CFS_Data = reducedData(:, icl);

% ����Ϊ .mat �ļ�
save('CFS_Data.mat', 'CFS_Data');

%% ����
figure(50);
for i=1:n
    plot(i,gammadmeo(i),'ko--');
    hold on;
end
ylabel('The value of \gamma','FontSize',16,'fontname','Times New Roman');
xlabel('The number of sample','FontSize',16,'fontname','Times New Roman');
set(gca,'FontSize',16);

icl_size = size(icl,2);

% �ָ�����Ϊ��������
first_five = gammadmeo(1:icl_size);
remaining = gammadmeo(icl_size+1:end);

% ���Ƶ�һ���֣�ǰ������ݵ㣩
figure(51);
hold on; % ����ͼ�α���ģʽ���Ա���ͬһͼ�л��ƶ������
plot(1:icl_size, first_five, '-rs', 'LineWidth', 2, 'MarkerFaceColor', 'r'); % ��ɫ���Σ�����.

% ���Ƶڶ����֣�ʣ������ݵ㣩
plot(icl_size+1:length(gammadmeo), remaining, '-ko', 'LineWidth', 2, 'MarkerFaceColor', 'k'); % ��ɫԲ�Σ�����

% ������񡢱���ͱ�ǩ�ȣ���ѡ��
grid on;
ylabel('�ֲ��ܶȺ;���ĳ˻� \gamma','FontSize',16);
xlabel('��������','FontSize',16);

% ȷ��û����������������֮��
hold off;




% ������ͬ�ص��ź�

% ���ѡ�������ź����������ƣ��������Ǽ򵥵�ѡ��ǰ������

% ��ȡ�������ź�
common_signal1 = data(9, 1: 50);%����������������������������������������
common_signal2 = data(8, 1: 50);%����������������������������������������

% �����������ź�
figure;
hold on;

% �����źų�����ͬ�������ͬ��Ҫ����
common_cluster = 1:length(common_signal1);

plot(common_cluster, common_signal1, '-b', 'LineWidth', 2); % ��ɫ�߱�ʾ��һ���ź�
plot(common_cluster, common_signal2, '-r', 'LineWidth', 2); % ��ɫ�߱�ʾ�ڶ����ź�

% ���ͼ������������ǩ
% legend('Signal 1', 'Signal 2');
title('��ͬ�ص��ź�');
xlabel('������');
ylabel('���');

% ��ʾ����
grid on;

% �رձ���ģʽ
hold off;



% ���Ʋ�ͬ�����ĵ��ź�
% ���ѡ�������ź����������ƣ��������Ǽ򵥵�ѡ��ǰ������

% ��ȡ�������ź�
diff_signal1 = data(3, 1: 50);%����������������������������������������
diff_signal2 = data(4, 1: 50);%����������������������������������������

figure;
hold on;

% �����źų�����ͬ�������ͬ��Ҫ����
diff_cluster = 1:length(diff_signal1);

plot(diff_cluster, diff_signal1, '-b', 'LineWidth', 2); % ��ɫ�߱�ʾ��һ���ź�
plot(diff_cluster, diff_signal2, '-r', 'LineWidth', 2); % ��ɫ�߱�ʾ�ڶ����ź�

% ���ͼ������������ǩ
% legend('Signal 1', 'Signal 2');
title('��ͬ�ص��ź�');
xlabel('������');
ylabel('���');

% ��ʾ����
grid on;

% �رձ���ģʽ
hold off;