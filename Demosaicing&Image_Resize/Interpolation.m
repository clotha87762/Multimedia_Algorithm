clear all;

ori = imread('Catvengers_gray.png');
s = 4;
oriscale = uint8(zeros(s*size(ori,1),s*size(ori,2)));
height = size(oriscale,1);
width =  size(oriscale,2);
for i=1:height
   for j=1:width
        oriscale(i,j) = ori(round((i-0.5)/s+0.5),round((j-0.5)/s+0.5));
   end
end

imwrite(oriscale,'NearestNeighbor.jpg');

oriscale = uint8(zeros(s*size(ori,1),s*size(ori,2)));

height = size(oriscale,1);
width =  size(oriscale,2);
hori = size(ori,1);
wori = size(ori,2);

for i=1:height, % 邊界問題QAQ
    for j =1:width,
        
       a=i/s;
       b=j/s;
       x=floor(a)+1;
       if x>hori,
       x = x-1;
       end
       y=floor(b)+1;
       if y>wori,
       y = y-1;
       end
       
       part1 = (1-(a-floor(a)))*(1-(b-floor(b)));
       part2 = (1-(a-floor(a)))*(b-floor(b));
       part3 = (a-floor(a))*(1-(b-floor(b)));
       part4 = (a-floor(a))*(b-floor(b));
       
       if x<hori&&y<wori,
        oriscale(i,j) = part1*ori(x,y) + part2*ori(x,y+1) + part3*ori(x+1,y)+ part4*ori(x+1,y+1);
       elseif x<hori&&y<=wori,
     
           oriscale(i,j) = (1-(a-floor(a)))*ori(x,y) + (a-floor(a))*ori(x+1,y);
        elseif x<=hori&&y<wori,
          
           oriscale(i,j) = (1-(b-floor(b)))*ori(x,y) + (b-floor(b))*ori(x,y+1);    
         
           
         elseif x<=hori&&y<=wori,
 
         oriscale(i,j) = ori(x,y) ;
               
       end
        
    end
end

imwrite(oriscale,'BiLinear.jpg');
