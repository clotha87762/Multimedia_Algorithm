function [ compensate , residual ] = Yield(frames,MV8)
%COMPENSATE Summary of this function goes here
%   Detailed explanation goes here
compensate = zeros(400,512,11);
residual = zeros(400,512,11);

for k=2:11,
    
    for i=1:8:393,
        for j=1:8:505,
            
            for a=0:7,
                for b=0:7          
                    compensate(i+a,j+b,k) = frames(i+a+MV8((i+7)/8,(j+7)/8,k,1) ,j+b+MV8((i+7)/8,(j+7)/8,k,2),1);
                    residual(i+a,j+b,k) = abs(compensate(i+a,j+b,k) - frames(i+a,j+b,k));
                end
            end
            
        end
    end
end

end

