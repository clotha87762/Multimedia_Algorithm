clear all; close all; clc;

vertNum = 60;
vertAngle = linspace(0,2*pi,vertNum+1);
vertX =  cos(vertAngle);
vertY =  sin(vertAngle);

topVerts = [vertX ; vertY ]';
topVerts(:,3) = 1;
topCenter = [0 0 1];
botVerts = [vertX; vertY]';
botVerts(:,3) = -1;
botCenter=[0 0 -1];

topVerts(61,:) =[];
botVerts(61,:) =[];


topIndex = int32(linspace(1,60,60));
botIndex = int32(linspace(61,120,60));
verts = [topVerts; botVerts];
verts = [verts;topCenter;botCenter];

faces=zeros(vertNum*4,3);
faces(1:60,1) = 121;
faces(61:120,1)=122;
faces(1:60,2) = topIndex;
faces(1:60,3) = mod((topIndex+1),60)+1;
faces(61:120,2) = botIndex;
faces(61:120,3) = mod((botIndex+1),60)+61;
faces(121:180,1) =  mod((topIndex+1),60)+1;
faces(121:180,2) = topIndex;
faces(121:180,3) = mod((botIndex+1),60)+61;
faces(181:240,1) = botIndex;
faces(181:240,2) = mod((botIndex+1),60)+61;
faces(181:240,3) = topIndex;

vertColors = [linspace(0,1,60) linspace(0,1,60) 0 0];
vertColors(2,1:120) = 1;
vertColors(2,121)=0;
vertColors(2,122)=0;
vertColors(3,1:60)=1;
vertColors(3,61:120)=0;
vertColors(3,121) = 1;
vertColors(3,122)=0;
vertColors = vertColors';
vertColorsRGB = hsv2rgb(vertColors) ;

writeColorObj('HSVCylinder.obj', verts, vertColorsRGB, faces );



