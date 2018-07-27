clear all;

frames = zeros(400,512,11);

frames(:,:,1) = rgb2gray(im2double(imread('caltrain007.bmp')));
imshow(frames(:,:,1));
frames(:,:,2) = rgb2gray(im2double(imread('caltrain008.bmp')));
frames(:,:,3) = rgb2gray(im2double(imread('caltrain009.bmp')));
frames(:,:,4) = rgb2gray(im2double(imread('caltrain010.bmp')));
frames(:,:,5) = rgb2gray(im2double(imread('caltrain011.bmp')));
frames(:,:,6) = rgb2gray(im2double(imread('caltrain012.bmp')));
frames(:,:,7) = rgb2gray(im2double(imread('caltrain013.bmp')));
frames(:,:,8) = rgb2gray(im2double(imread('caltrain014.bmp')));
frames(:,:,9) = rgb2gray(im2double(imread('caltrain015.bmp')));
frames(:,:,10) = rgb2gray(im2double(imread('caltrain016.bmp')));
frames(:,:,11) = rgb2gray(im2double(imread('caltrain017.bmp')));
%%  

%   d = 8 , macrosize = 8 , Full search
MV8 =zeros(50,64,11,2);
MV16 = zeros(25,32,11,2);
tic;
for k=2:11,
    
    for i=1:8:393,
        for j=1:8:505,
               min = 10000000;
                for a=-7:7,    % search range
                    for b=-7:7,
                        
                        if i+a>393||i+a<1,
                            continue 
                        end
                        if j+b>505||j+b<1,
                            continue 
                        end                     
                        temp = 0;
                        for c=0:7,
                            for d=0:7                          
                                temp = temp + abs(frames(i+a+c,j+b+d,1)-frames(i+c,j+d,k));                            
                            end
                        end
                                  
                         if temp< min ,
                             min = temp;
                             MV8((i+7)/8,(j+7)/8,k,1) = a;
                             MV8((i+7)/8,(j+7)/8,k,2)= b ;
                         end
                   
                    end   
                end
         
        end
        
    end
    
end
toc
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;

compensate = zeros(400,512,11);
residual = zeros(400,512,11);
[compensate , residual] = Yield(frames,MV8);

clear i;clear j;clear k;

%%

%   d = 8 , macrosize = 8 , 2-d Logarithm search
n=4;
tic;
for k=2:11,  %frames
    
    for i=1:8:393,
        for j=1:8:505,
               a=0;
               b=0;
               n=4;
                while n>1,
                   temp2=1000000;
                   temp=0;
                   V =[0 0];
                   tempA = a+0;
                   tempB = b+0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 0];
                        end
                   end
                   tempA = a+n;
                   tempB = b+0;
                   temp=0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V = [n 0];
                        end
                   end
                    tempA = a+0;
                    tempB = b+n;
                    temp = 0;
                    if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 n];
                        end
                   end
                    tempA = a-n;
                   tempB = b+0;
                   temp = 0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[-n 0];
                        end
                   end
                    tempA = a+0;
                   tempB = b+-n;
                   temp = 0;
                     if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                           for c=0:7,
                               for d=0:7,                          
                                  temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                               end
                           end
                            if temp<temp2,
                               temp2=temp; 
                               V= [0 -n];
                            end
                     end
                     
                    if V(1,1)==0&&V(1,2)==0,
                       n = n/2; 
                    else
                       a=a+V(1,1);
                       b=b+V(1,2);
                    end
                end
                
                temp = 0;
                min=1000000;
                for e=-1:1:1,
                    for f=-1:1:1,
                        temp=0;
                        if i+a+e<394&&i+a+e>0&&j+b+f<506&&j+b+f>0,
                            for c=0:7,
                                for d=0:7,                          
                                    temp = temp + abs(frames(i+a+e+c,j+b+f+d,1)-frames(i+c,j+d,k));                            
                                end
                            end

                            if temp< min ,
                                 min = temp;
                                 MV8((i+7)/8,(j+7)/8,k,1) = a+e;
                                 MV8((i+7)/8,(j+7)/8,k,2)= b+f ;
                            end
                        end
                        
                    end
                end
                
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;clear tempA; clear tempB;clear temp2;
clear e; clear f; clear n; clear V;
compensate2 = zeros(400,512,11);
residual2 = zeros(400,512,11);
[compensate2 , residual2] = Yield(frames,MV8);

%%

% d = 8 , macrosize = 16 , full search

MV8 =zeros(50,64,11,2);
MV16 = zeros(25,32,11,2);
tic;
for k=2:11,
    
    for i=1:16:385,
        for j=1:16:497,
               min = 10000000;
                for a=-7:7,    % search range
                    for b=-7:7,
                        
                        if i+a>385||i+a<1,
                            continue 
                        end
                        if j+b>497||j+b<1,
                            continue 
                        end                     
                        temp = 0;
                        for c=0:15,
                            for d=0:15                          
                                temp = temp + abs(frames(i+a+c,j+b+d,1)-frames(i+c,j+d,k));                            
                            end
                        end
                                  
                         if temp< min ,
                             min = temp;
                             MV16((i+15)/16,(j+15)/16,k,1) = a;
                             MV16((i+15)/16,(j+15)/16,k,2)= b ;
                         end
                   
                    end   
                end
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;

compensate3 = zeros(400,512,11);
residual3 = zeros(400,512,11);
[compensate3 , residual3] = Yield16(frames,MV16);

clear i;clear j;clear k;

%%

% d = 16 , macrosize = 8 , full search

MV8 =zeros(50,64,11,2);
MV16 = zeros(25,32,11,2);
tic;
for k=2:11,
    
    for i=1:8:393,
        for j=1:8:505,
               min = 10000000;
                for a=-15:15,    % search range
                    for b=-15:15,
                        
                        if i+a>393||i+a<1,
                            continue 
                        end
                        if j+b>505||j+b<1,
                            continue 
                        end                     
                        temp = 0;
                        for c=0:7,
                            for d=0:7                          
                                temp = temp + abs(frames(i+a+c,j+b+d,1)-frames(i+c,j+d,k));                            
                            end
                        end
                                  
                         if temp< min ,
                             min = temp;
                             MV8((i+7)/8,(j+7)/8,k,1) = a;
                             MV8((i+7)/8,(j+7)/8,k,2)= b ;
                         end
                   
                    end   
                end
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;

compensate4 = zeros(400,512,11);
residual4 = zeros(400,512,11);
[compensate4 , residual4] = Yield(frames,MV8);

clear i;clear j;clear k;

%%

% d = 16 , macrosize = 16 , full search

MV8 =zeros(50,64,11,2);
MV16 = zeros(25,32,11,2);
tic;
for k=2:11,
    
    for i=1:16:385,
        for j=1:16:497,
               min = 10000000;
                for a=-15:15,    % search range
                    for b=-15:15,
                        
                        if i+a>385||i+a<1,
                            continue 
                        end
                        if j+b>497||j+b<1,
                            continue 
                        end                     
                        temp = 0;
                        for c=0:15,
                            for d=0:15                          
                                temp = temp + abs(frames(i+a+c,j+b+d,1)-frames(i+c,j+d,k));                            
                            end
                        end
                                  
                         if temp< min ,
                             min = temp;
                             MV16((i+15)/16,(j+15)/16,k,1) = a;
                             MV16((i+15)/16,(j+15)/16,k,2)= b ;
                         end
                   
                    end   
                end
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;

compensate5 = zeros(400,512,11);
residual5 = zeros(400,512,11);
[compensate5 , residual5] = Yield16(frames,MV16);

clear i;clear j;clear k;

%%

%   d = 8 , macrosize = 16 , 2-d Logarithm search
n=4;
tic;
for k=2:11,
    
    for i=1:16:385,
        for j=1:16:497,
               a=0;
               b=0;
               n=4;
                while n>1,
                   temp2=1000000;
                   temp=0;
                   V =[0 0];
                   tempA = a+0;
                   tempB = b+0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 0];
                        end
                   end
                   tempA = a+n;
                   tempB = b+0;
                   temp=0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                         
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V = [n 0];
                        end
                   end
                    tempA = a+0;
                    tempB = b+n;
                    temp = 0;
                    if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 n];
                        end
                   end
                   tempA = a-n;
                   tempB = b+0;
                   temp = 0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                    
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[-n 0];
                        end
                   end
                   tempA = a+0;
                   tempB = b+-n;
                   temp = 0;
                     if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                           for c=0:15,
                               for d=0:15,                          
                                  temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                               end
                           end
                            if temp<temp2,
                               temp2=temp; 
                               V= [0 -n];
                            end
                     end
                     
                    if V(1,1)==0&&V(1,2)==0,
                       n = n/2; 
                    else
                       a=a+V(1,1);
                       b=b+V(1,2);
                    end
                end
                
                temp = 0;
                min=1000000;
                for e=-1:1:1,
                    for f=-1:1:1,
                        temp=0;
                        if i+a+e<386&&i+a+e>0&&j+b+f<498&&j+b+f>0,
                            for c=0:15,
                                for d=0:15                          
                                    temp = temp + abs(frames(i+a+e+c,j+b+f+d,1)-frames(i+c,j+d,k));                            
                                end
                            end

                            if temp< min ,
                                 min = temp;
                                 MV16((i+15)/16,(j+15)/16,k,1) = a+e;
                                 MV16((i+15)/16,(j+15)/16,k,2)= b+f ;
                            end
                        end
                        
                    end
                end
                
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;clear tempA; clear tempB;clear temp2;
clear e; clear f; clear n; clear V;
compensate6 = zeros(400,512,11);
residual6 = zeros(400,512,11);
[compensate6 , residual6] = Yield16(frames,MV16);

%%
%   d = 16 , macrosize = 8 , 2-d Logarithm search

n=8;
tic;
for k=2:11,
    
    for i=1:8:393,
        for j=1:8:505,
               a=0;
               b=0;
               n=8;
                while n>1,
                   temp2=1000000;
                   temp=0;
                   V =[0 0];
                   tempA = a+0;
                   tempB = b+0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 0];
                        end
                   end
                   tempA = a+n;
                   tempB = b+0;
                   temp=0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V = [n 0];
                        end
                   end
                    tempA = a+0;
                    tempB = b+n;
                    temp = 0;
                    if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 n];
                        end
                   end
                    tempA = a-n;
                   tempB = b+0;
                   temp = 0;
                   if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                       for c=0:7,
                           for d=0:7,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[-n 0];
                        end
                   end
                    tempA = a+0;
                   tempB = b+-n;
                   temp = 0;
                     if i+tempA<394&&i+tempA>0&&j+tempB<506&&j+tempB>0,
                           for c=0:7,
                               for d=0:7,                          
                                  temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                               end
                           end
                            if temp<temp2,
                               temp2=temp; 
                               V= [0 -n];
                            end
                     end
                     
                    if V(1,1)==0&&V(1,2)==0,
                       n = n/2; 
                    else
                       a=a+V(1,1);
                       b=b+V(1,2);
                    end
                end
                
                temp = 0;
                min=1000000;
                for e=-1:1:1,
                    for f=-1:1:1,
                        temp=0;
                        if i+a+e<394&&i+a+e>0&&j+b+f<506&&j+b+f>0,
                            for c=0:7,
                                for d=0:7,                          
                                    temp = temp + abs(frames(i+a+e+c,j+b+f+d,1)-frames(i+c,j+d,k));                            
                                end
                            end

                            if temp< min ,
                                 min = temp;
                                 MV8((i+7)/8,(j+7)/8,k,1) = a+e;
                                 MV8((i+7)/8,(j+7)/8,k,2)= b+f ;
                            end
                        end
                        
                    end
                end
                
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;clear tempA; clear tempB;clear temp2;
clear e; clear f; clear n; clear V;
compensate7 = zeros(400,512,11);
residual7 = zeros(400,512,11);
[compensate7 , residual7] = Yield(frames,MV8);

%%

%   d = 16 , macrosize = 16 , 2-d Logarithm search
n=8;
tic;
for k=2:11,
    
    for i=1:16:385,
        for j=1:16:497,
               a=0;
               b=0;
               n=8;
                while n>1,
                   temp2=1000000;
                   temp=0;
                   V =[0 0];
                   tempA = a+0;
                   tempB = b+0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 0];
                        end
                   end
                   tempA = a+n;
                   tempB = b+0;
                   temp=0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                         
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V = [n 0];
                        end
                   end
                    tempA = a+0;
                    tempB = b+n;
                    temp = 0;
                    if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                          
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[0 n];
                        end
                   end
                   tempA = a-n;
                   tempB = b+0;
                   temp = 0;
                   if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                       for c=0:15,
                           for d=0:15,                    
                              temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                           end
                       end
                        if temp<temp2,
                           temp2=temp; 
                           V=[-n 0];
                        end
                   end
                   tempA = a+0;
                   tempB = b+-n;
                   temp = 0;
                     if i+tempA<386&&i+tempA>0&&j+tempB<498&&j+tempB>0,
                           for c=0:15,
                               for d=0:15,                          
                                  temp = temp + abs(frames(i+tempA+c,j+d+tempB,1)-frames(i+c,j+d,k));                            
                               end
                           end
                            if temp<temp2,
                               temp2=temp; 
                               V= [0 -n];
                            end
                     end
                     
                    if V(1,1)==0&&V(1,2)==0,
                       n = n/2; 
                    else
                       a=a+V(1,1);
                       b=b+V(1,2);
                    end
                end
                
                temp = 0;
                min=1000000;
                for e=-1:1:1,
                    for f=-1:1:1,
                        temp=0;
                        if i+a+e<386&&i+a+e>0&&j+b+f<498&&j+b+f>0,
                            for c=0:15,
                                for d=0:15                          
                                    temp = temp + abs(frames(i+a+e+c,j+b+f+d,1)-frames(i+c,j+d,k));                            
                                end
                            end

                            if temp< min ,
                                 min = temp;
                                 MV16((i+15)/16,(j+15)/16,k,1) = a+e;
                                 MV16((i+15)/16,(j+15)/16,k,2)= b+f ;
                            end
                        end
                        
                    end
                end
                
         
        end
        
    end
    
end
toc;
clear a; clear b; clear c; clear d; clear i; clear j; clear k;clear min; clear temp;clear tempA; clear tempB;clear temp2;
clear e; clear f; clear n; clear V;
compensate8 = zeros(400,512,11);
residual8 = zeros(400,512,11);
[compensate8 , residual8] = Yield16(frames,MV16);

%%


figure('name','d = 8 , macrosize = 8 , Full search  #008','NumberTitle','off');
imshow(residual(:,:,2));
%title('d = 8 , macrosize = 8 , Full search  #008');
figure('name','d = 8 , macrosize = 8 , Full search  #017','NumberTitle','off');
imshow(residual(:,:,11));
%title('d = 8 , macrosize = 8 , Full search  #017');
figure('name','d = 8 , macrosize = 8 , 2-d logarithm  #008','NumberTitle','off');
imshow(residual2(:,:,2));
%title('d = 8 , macrosize = 8 , 2-d logarithm  #008');
figure('name','d = 8 , macrosize = 8 , 2-d logarithm  #017','NumberTitle','off');
imshow(residual2(:,:,11));
%title('d = 8 , macrosize = 8 , 2-d logarithm  #017');
figure('name','d = 8 , macrosize = 16 , Full search  #008','NumberTitle','off');
imshow(residual3(:,:,2));
%title('d = 8 , macrosize = 16 , Full search  #008');
figure('name','d = 8 , macrosize = 16 , Full search  #017','NumberTitle','off');
imshow(residual3(:,:,11));
%title('d = 8 , macrosize = 16 , Full search  #017');
figure('name','d = 16 , macrosize = 8 , Full search  #008','NumberTitle','off');
imshow(residual4(:,:,2));
%title('d = 16 , macrosize = 8 , Full search  #008');
figure('name','d = 16 , macrosize = 8 , Full search  #017','NumberTitle','off');
imshow(residual4(:,:,11));
%title('d = 16 , macrosize = 8 , Full search  #017');
figure('name','d = 16 , macrosize = 16 , Full search  #008','NumberTitle','off');
imshow(residual5(:,:,2));
%title('d = 16 , macrosize = 16 , Full search  #008');
figure('name','d = 16 , macrosize = 16 , Full search  #017','NumberTitle','off');
imshow(residual5(:,:,11));
%title('d = 16 , macrosize = 16 , Full search  #017');
figure('name','d = 8 , macrosize = 16 , 2-d logarithm  #008','NumberTitle','off');
imshow(residual6(:,:,2));
%title('d = 8 , macrosize = 16 , 2-d logarithm  #008');
figure('name','d = 8 , macrosize = 16 , 2-d logarithm  #017','NumberTitle','off');
imshow(residual6(:,:,11));
%title('d = 8 , macrosize = 16 , 2-d logarithm  #017');
figure('name','d = 16 , macrosize = 8 , 2-d logarithm  #008','NumberTitle','off');
imshow(residual7(:,:,2));
%title('d = 16 , macrosize = 8 , 2-d logarithm  #008');
figure('name','d = 16 , macrosize = 8 , 2-d logarithm  #017','NumberTitle','off');
imshow(residual7(:,:,11));
%title('d = 16 , macrosize = 8 , 2-d logarithm  #017');
figure('name','d = 16 , macrosize = 16 , 2-d logarithm  #008','NumberTitle','off');
imshow(residual8(:,:,2));
%title('d = 16 , macrosize = 16 , 2-d logarithm  #008');
figure('name','d = 16 , macrosize = 16 , 2-d logarithm  #017','NumberTitle','off');
imshow(residual8(:,:,11));
%title('d = 16 , macrosize = 16 , 2-d logarithm  #017');
%%
SAD = zeros(1,11);
SAD2 = zeros(1,11);
SAD3 = zeros(1,11);
SAD4 = zeros(1,11);
SAD5 = zeros(1,11);
SAD6 = zeros(1,11);
SAD7 = zeros(1,11);
SAD8 = zeros(1,11);
PSNR = zeros(1,11);
sumSAD = zeros(1,8);

M=400;
N=512;
for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD(k) = SAD(k) + abs(residual(i,j,k));  
        end
    end
      MSE = sum(sum((residual(:,:,k).^2)))/(M*N);
      PSNR(k) = 10*log10(1.0/MSE);
      sumSAD(1) = sumSAD(1) + SAD(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame    d = 8 , macrosize = 8 , Full search ');
ylabel('PSNR');

for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD2(k) = SAD2(k) + abs(residual2(i,j,k));
        end
    end
    MSE = sum(sum((residual2(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(2) = sumSAD(2) + SAD2(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame   d = 8 , macrosize = 8 , 2-d Logarithm search');
ylabel('PSNR');



for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD3(k) = SAD3(k) + abs(residual3(i,j,k));
        end
    end
    MSE = sum(sum(((residual3(:,:,k)).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(3) = sumSAD(3) + SAD3(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame  d = 8 , macrosize = 16 , full search');
ylabel('PSNR');


for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD4(k) = SAD4(k) + abs(residual4(i,j,k));
        end
    end
    MSE = sum(sum((residual4(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(4) = sumSAD(4) + SAD4(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame  d = 16 , macrosize = 8 , full search');
ylabel('PSNR');



for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD5(k) = SAD5(k) + abs(residual5(i,j,k));
        end
    end
    MSE = sum(sum((residual5(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(5) = sumSAD(5) + SAD5(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame   d = 16 , macrosize = 16 , full search ');
ylabel('PSNR');


for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD6(k) = SAD6(k) + abs(residual6(i,j,k));
        end
    end
    MSE = sum(sum((residual6(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(6) = sumSAD(6) + SAD6(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame  d = 8 , macrosize = 16 , 2-d Logarithm search ');
ylabel('PSNR');


for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD7(k) = SAD7(k) + abs(residual7(i,j,k));
        end
    end
    MSE = sum(sum((residual7(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(7) = sumSAD(7) + SAD7(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame  d = 16 , macrosize = 8 , 2-d Logarithm search');
ylabel('PSNR');



for k=2:11,
    for i=1:400,
        for j=1:512,
            SAD8(k) = SAD8(k) + abs(residual8(i,j,k));
        end
    end
    MSE = sum(sum((residual8(:,:,k).^2)))/(M*N);
    PSNR(k) = 10*log10(1.0/MSE);
    sumSAD(8) = sumSAD(8) + SAD8(k);
end
x = [8:1:17];
figure();
PSNR(1) = [];
plot(x,PSNR);
xlabel(' # frame  d = 16 , macrosize = 16 , 2-d Logarithm search');
ylabel('PSNR');

