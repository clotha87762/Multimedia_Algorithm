clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);
imshow(catImage);

%% Mouse input
xlabel ('Select at most 200 points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
[ ctrlPointX, ctrlPointY ] = ginput(200);
ctrlPointList = [ctrlPointX ctrlPointY];
clickedN = size(ctrlPointList,1);

promptStr = sprintf('%d points selected', clickedN);
xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);

%% Calculate Bㄚˇzier curve (Your efforts here)
outlineVertexList = ctrlPointList; %Enrich outlineVertexList

%% Draw and fill the polygon
drawAndFillPolygon( catImage, ctrlPointList, outlineVertexList, true, true, true ); %ctrlPointScattered, polygonPlotted, filled

%% Bezier Curve
hold off;
LOD = 50;
sample = linspace(0,1,LOD);
Ttemp = [sample.^3 ;sample.^2; sample;];
Ttemp(4,:) = 1;
Ttemp = Ttemp';
M = [-1 3 -3 1;3 -6 3 0; -3 3 0 0;1 0 0 0];
P = zeros(LOD,2);
imshow(catImage);
n = clickedN;

k=1;

for i=0:3:n,
    
    GX =[ctrlPointX(mod(i,n)+1) ctrlPointX(mod(i+1,n)+1) ctrlPointX(mod(i+2,n)+1) ctrlPointX(mod(i+3,n)+1)]';
 
    GY =[ctrlPointY(mod(i,n)+1) ctrlPointY(mod(i+1,n)+1) ctrlPointY(mod(i+2,n)+1) ctrlPointY(mod(i+3,n)+1)]';
    for j=1:LOD
        T = Ttemp(j,:);
        P(j,1) = (T*M)*GX;
        P(j,2) = (T*M)*GY;
            
        
        temp(k,1) = P(j,1);
        temp(k,2) = P(j,2);
        k = k+1;
      
    end
    hold on;
    plot(P(:,1),P(:,2),'Color','r');
    alpha(0.5);
end

%fill(temp(:,1),temp(:,2),'r');
%alpha(0.5);

figure();
LOD = 6;
sample = linspace(0,1,LOD);
Ttemp = [sample.^3 ;sample.^2; sample;];
Ttemp(4,:) = 1;
Ttemp = Ttemp';
M = [-1 3 -3 1;3 -6 3 0; -3 3 0 0;1 0 0 0];
P = zeros(LOD,2);
imshow(catImage);
n = clickedN;
for i=0:3:n,
    
    GX =[ctrlPointX(mod(i,n)+1) ctrlPointX(mod(i+1,n)+1) ctrlPointX(mod(i+2,n)+1) ctrlPointX(mod(i+3,n)+1)]';
 
    GY =[ctrlPointY(mod(i,n)+1) ctrlPointY(mod(i+1,n)+1) ctrlPointY(mod(i+2,n)+1) ctrlPointY(mod(i+3,n)+1)]';
    for j=1:LOD
        T = Ttemp(j,:);
        P(j,1) = (T*M)*GX;
        P(j,2) = (T*M)*GY;
        
    end
    hold on;
    plot(P(:,1),P(:,2),'Color','c');
    alpha(0.5);
end


%% Part B
figure();

bitscale = imresize(catImage,4,'nearest');
imwrite(bitscale,'bitmap4x.jpg');
hold off;
imshow(bitscale);
hold on;
temp4x = temp.*4;

plot(temp4x(:,1),temp4x(:,2),'Color','r','LineWidth',4);

%fill(temp4x(:,1),temp4x(:,2),'r');


%saveas(gcf,'VectorvsBitmap.png');








