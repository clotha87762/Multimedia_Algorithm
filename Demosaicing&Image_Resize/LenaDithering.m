clear all;

ori = imread('lena_gray.bmp');

%ori= rgb2gray(ori);
ori_gray = ori;
height = size(ori_gray,1);
width = size(ori_gray,2);
for i=1:height   % absolute value
    for j=1:width
       
        if ori_gray(i,j)<=128,
            ori_gray(i,j)=0;
        else
           ori_gray(i,j)=255; 
        end        
    end
end
imwrite(ori_gray,'Lena128.jpg');

ori_gray = ori;

height = size(ori_gray,1);
width = size(ori_gray,2);

for i=1:height   % random value
    for j=1:width
        threshold = rand(1,1);
        threshold = uint8(threshold * 255);
        if ori_gray(i,j)<=threshold,
            ori_gray(i,j)=0;
        else
           ori_gray(i,j)=255; 
        end        
    end
end
imwrite(ori_gray,'Lenarandom.jpg');

s=0;
uint32(s);

ori_gray = ori;

height = size(ori_gray,1);
width = size(ori_gray,2);

for i=1:height   % average value
    for j=1:width
       s = s + uint32(ori_gray(i,j));
      
    end
end

s = (s/ (size(ori_gray,1)*size(ori_gray,2)));



for i=1:height   % average value
    for j=1:width
        if ori_gray(i,j)<=s,
           ori_gray(i,j)=0;
        else
           ori_gray(i,j)=255; 
        end        
    end
end
imwrite(ori_gray,'LenaaverageDithering.jpg');

ori_gray = ori;

threshold_matrix = [200 250 100;220 150 200;10 150 50 ];
ori_ex = zeros(size(ori_gray,1)+2,size(ori_gray,2)+2);
ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1) = ori_gray;

height = size(ori_ex,1);
width = size(ori_ex,2);

for i=2:3:height-1   % pattern dithering
    for j=2:3:width-1
        
        for a=-1:1
            for b=-1:1
                if ori_ex(i+a,j+b)<threshold_matrix(a+2,b+2),
                    ori_ex(i+a,j+b) = 0;
                else
                    ori_ex(i+a,j+b) = 255;
                end
                
            end
        end      
    end
end
ori_gray = (ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1));
imwrite(ori_gray,'Lenapattern.jpg');
%{
for i=1:size(ori_gray,1)   % Error Diffusion #1
    for j=1:size(ori_gray,2)
        if ori_gray(i,j)>=128
        error(i,j) = double(ori_gray(i,j))-255;
     
        else
        error(i,j) = double(ori_gray(i,j));    
        end
    end
end
%}
ori_gray = ori;
height = size(ori_gray,1);
width = size(ori_gray,2);

ori_ex=zeros(size(ori_gray,1)+3,size(ori_gray,2)+3);
ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1)=ori_gray;

for i=1:height    % Error Diffusion #1
    for j=1:width
       
        if ori_ex(i,j)>=128
        error = double(ori_ex(i,j))-255;
     
        else
        error = double(ori_ex(i,j));    
        end 
        
        
        if i>0&&j+1>0&&i<=size(ori_gray,1)&&j+1<=size(ori_gray,2),
        ori_ex(i,j+1) = ori_ex(i,j+1) + 7*error/16;
        end;
        if i+1>0&&j-1>0&&i+1<=size(ori_gray,1)&&j-1<=size(ori_gray,2),
        ori_ex(i+1,j-1) = ori_ex(i+1,j-1) +3*error/16;
        end
        if i+1>0&&j>0&&i+1<=size(ori_gray,1)&&j<=size(ori_gray,2),
        ori_ex(i+1,j) = ori_ex(i+1,j)+5*error/16;
        end
        if i+1>0&&j+1>0&&i+1<=size(ori_gray,1)&&j+1<=size(ori_gray,2),
        ori_ex(i+1,j+1) = ori_ex(i+1,j+1)+error/16;
        end
       
        
    end
end

height = size(ori_gray,1);
width = size(ori_gray,2);

for i=1:height
    for j=1:width
        if ori_ex(i,j)>=128
        ori_ex(i,j)=255;
        else
         ori_ex(i,j) = 0;   
        end
    end
end
ori_gray = (ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1));
imwrite(ori_gray,'LenaerrorDiffusion1.jpg');

ori_gray = ori;

ori_ex=zeros(size(ori_gray,1)+3,size(ori_gray,2)+3);
ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1)=ori_gray;

height = size(ori_gray,1);
width = size(ori_gray,2);

for i=3:height+1    % Error Diffusion #2
    for j=3:width+1
       
        if ori_ex(i,j)>=128
        e = double(ori_ex(i,j))-255;
     
        else
        e = double(ori_ex(i,j));    
        end 
        
        ori_ex(i,j+1)=ori_ex(i,j+1)+7*e/48;
        ori_ex(i,j+2)=ori_ex(i,j+2)+5*e/48;
        ori_ex(i+1,j-2)=ori_ex(i+1,j-2)+3*e/48;
        ori_ex(i+1,j-1)=ori_ex(i+1,j-1)+5*e/48;
        ori_ex(i+1,j)=ori_ex(i+1,j)+7*e/48;
        ori_ex(i+1,j+1)=ori_ex(i+1,j+1)+5*e/48;
        ori_ex(i+1,j+2)=ori_ex(i+1,j+2)+3*e/48;
        ori_ex(i+2,j-2)=ori_ex(i+2,j-2)+1*e/48;
        ori_ex(i+2,j-1)=ori_ex(i+2,j-1)+3*e/48;
        ori_ex(i+2,j)=ori_ex(i+2,j)+5*e/48;
        ori_ex(i+2,j+1)=ori_ex(i+2,j+1)+3*e/48;
        ori_ex(i+2,j+2)=ori_ex(i+2,j+2)+1*e/48;
      
    end
end

ori_gray = (ori_ex(2:size(ori_gray,1)+1,2:size(ori_gray,2)+1));
height = size(ori_gray,1);
width = size(ori_gray,2);
for i=1:height 
    for j=1:width
        if ori_gray(i,j)>=128
        ori_gray(i,j)=255;
        else
         ori_gray(i,j) = 0;   
        end
    end
end


imwrite(ori_gray,'LenaerrorDiffusion2.jpg');