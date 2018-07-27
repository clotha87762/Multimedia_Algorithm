clear all;
oriImg = imread('BFCatvengers.png');
oriImg2 = imread('Catvengers.png');
 
 
oriImg = im2double( oriImg );
oriImg2 = im2double( oriImg2 );
 
orig_size_1 = size(oriImg,1);
orig_size_2 = size(oriImg,2);
temp2 = double(zeros(orig_size_1+2,orig_size_2+2,3));
temp2(2:orig_size_1+1,2:orig_size_2+1,1:3)=oriImg;
temp = zeros(orig_size_1,orig_size_2,3);
for i=1:orig_size_1,
    for j=1:orig_size_2,
        for k=1:3,
            
            if oriImg(i,j,k) > 0 ,
                
             if k==1,
             temp(i,j,1) = temp2(i+1,j+1,1);
             temp(i,j,2) = (temp2(i+1,j+2,2)+temp2(i+1,j,2)+temp2(i+2,j+1,2)+temp2(i,j+1,2))/4;
             temp(i,j,3) = (temp2(i,j,3)+temp2(i,j+2,3)+temp2(i+2,j+2,3)+temp2(i+2,j,3))/4;
        
            elseif k==2;
                 temp(i,j,1) = (temp2(i,j+1,1)+temp2(i+2,j+1,1)+temp2(i+1,j,1)+temp2(i+1,j+2,1))/2;
                 temp(i,j,2) = temp2(i+1,j+1,2);
                 temp(i,j,3) =  (temp2(i,j+1,3)+temp2(i+2,j+1,3)+temp2(i+1,j,3)+temp2(i+1,j+2,3))/2;          
            elseif k==3;
                 temp(i,j,1) = (temp2(i,j,1)+temp2(i,j+2,1)+temp2(i+2,j+2,1)+temp2(i+2,j,1))/4;     
                 temp(i,j,2) = (temp2(i+1,j+2,2)+temp2(i+1,j,2)+temp2(i+2,j+1,2)+temp2(i,j+1,2))/4;
                 temp(i,j,3) = temp2(i+1,j+1,3);                
             
             end   
             
           end
        
        end
    end
end
   
imwrite(temp,'temp.jpg');
Diff = zeros(orig_size_1,orig_size_2,3);
for i=1:orig_size_1,
   for j=1:orig_size_2,
      
       Diff(i,j,1) = abs(temp(i,j,1)-oriImg2(i,j,1))*5;
        Diff(i,j,2) = abs(temp(i,j,2)-oriImg2(i,j,2))*5;
         Diff(i,j,3) = abs(temp(i,j,3)-oriImg2(i,j,3))*5;
       
   end
end

imwrite(Diff,'Diff.jpg');
 

x=size(temp);
M=x(1);
N=x(2);

MSE = sum(sum(sum((oriImg2-temp).^2)))/(M*N*3);
PSNR = 10*log10(1.0/MSE);

fprintf('PSNR = %d\n',(PSNR));
%imwrite(temp2,'temp2.png');
 

