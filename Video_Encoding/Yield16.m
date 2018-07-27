function [ compensate , residual ] = Yield16(frames,MV16)
%COMPENSATE Summary of this function goes here
%   Detailed explanation goes here
compensate = zeros(400,512,11);
residual = zeros(400,512,11);

for k=2:11,
    
    for i=1:16:385,
        for j=1:16:497,
            
            for a=0:15,
                for b=0:15          
                    compensate(i+a,j+b,k) = frames(i+a+MV16((i+15)/16,(j+15)/16,k,1) ,j+b+MV16((i+15)/16,(j+15)/16,k,2),1);
                    residual(i+a,j+b,k) = abs(compensate(i+a,j+b,k) - frames(i+a,j+b,k));
                end
            end
            
        end
    end
end

end

