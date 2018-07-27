function  [avg]=NNA(i,j,k,temp2,temp)
    avg = zeros(1,3);
    x = 0;
    sum=0;
   
    if k==1,
         temp(i,j,1) = temp2(i+1,j+1,1);
         temp(i,j,2) = (temp2(i+1,j+2,2)+temp2(i+1,j,2)+temp2(i+2,j+1,2)+temp2(i,j+1,2))/4;
         temp(i,j,3) = (temp2(i,j,3)+temp2(i,j+2,3)+temp2(i+2,j+2,3)+temp2(i+2,j,3))/4;
        
    elseif k==2;
         temp(i,j,1) = (temp2(i+1,j+2,1)+temp2(i+1,j,1))/2;
         temp(i,j,2) = temp2(i+1,j+1,2);
         temp(i,j,3) =  (temp2(i+2,j+1,3)+temp2(i,j+1,3))/2;          
    elseif k==3;
         temp(i,j,1) = (temp2(i,j,1)+temp2(i,j+2,1)+temp2(i+2,j+2,1)+temp2(i+2,j,1))/4;     
         temp(i,j,2) = (temp2(i+1,j+2,2)+temp2(i+1,j,2)+temp2(i+2,j+1,2)+temp2(i,j+1,2))/4;
         temp(i,j,3) = temp2(i+1,j+1,3);                
    end
        avg = temp(i,j,:); 
    
end