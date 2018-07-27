function [out ,fltr] = myFilter(in, fs, N, wFun, type, para)

% in: input signal
% fs: sampling frequency
% N : size of FIR filter, assumed to be odd
% wFun: 'Hanning', 'Hamming', 'Blackman'
% type: 'low-pass', 'high-pass', 'bandpass', 'bandstop' 
% para: cut-off frequency or band frequencies corresponding to the filter type
%       if type is 'low-pass' or 'high-pass', para has only one element         
%       if type is 'bandpass' or 'bandstop', para is a vector of 2 elements

% 1. Normalization
if strcmp(type,'low-pass')==1||strcmp(type,'high-pass')==1, 
    fc = para(1);
    fc = fc/fs;
    
   if strcmp(type,'low-pass')==1,
       disp('Now doing low-pass filtering');
   elseif strcmp(type,'high-pass')==1,
       disp('Now doing hight-pass filtering');
   end
    
    
    omega = 2*pi*fc;
elseif strcmp(type,'bandpass')==1||strcmp(type,'bandstop')==1,
    f1 = para(1);
    f2 = para(2);
    f1 = f1/fs;
    f2 = f2/fs;
    omega1 = f1*2*pi;
    omega2 = f2*2*pi;
      if strcmp(type,'bandpass')==1,
       disp('Now doing bandpass filtering');
   elseif strcmp(type,'bandstop')==1,
       disp('Now doing bandstop filtering');
   end
      
end

middle =floor(N/2);


% 2. Create the filter according the ideal equations in Table5.2
fltr = zeros([1 N]);

if strcmp(type,'low-pass')==1, 
    for n=-middle:1:middle,
        if n==0, fltr(middle+1)=1; 
        else fltr(n+middle+1) = sin(2*pi*fc*double(n))/(pi*double(n));
            
        end
     
    end
fltr(middle+1) = 2*fc;
elseif strcmp(type,'high-pass')==1,
    for n=-middle:1:middle,
        if n==0, fltr(middle+1)=1; 
        else fltr(n+middle+1) = -1.0*sin(2*pi*fc*double(n))/(pi*double(n));
        end
    end
fltr(middle+1) = (1-2*fc);    
elseif strcmp(type,'bandpass')==1,
     for n=-middle:1:middle,
        if n==0, fltr(middle+1)=1; 
        else fltr(n+middle+1) = (sin(2*pi*f2*double(n))/(pi*double(n))) - (sin(2*pi*f1*double(n))/(pi*double(n)));
        end
    end
fltr(middle+1) = 2*(f2-f1);    
elseif strcmp(type,'bandstop')==1,
     for n=-middle:1:middle,
        if n==0, fltr(middle+1)=1; 
        else fltr(n+middle+1) =sin(2*pi*f1*double(n))/(pi*double(n))-sin(2*pi*f2*double(n))/(pi*double(n)) ;
        end
    end
fltr(middle+1) = (1- 2*(f2-f1));    
end
 

% 3. Create the windowing function

if strcmp(wFun,'Hanning')==1, 
    for n=0:N-1,
       fltr(n+1) =fltr(n+1)*( 0.5 + 0.5*cos((2*pi*double(n))/N)); 
    end
elseif strcmp(wFun,'Hamming')==1,
    for n=0:N-1,
       fltr(n+1) = fltr(n+1)*(0.54 + 0.46*cos((2*pi*double(n))/N)); 
    end
elseif strcmp(wFun,'Blackman')==1,
   for n=0:N-1
    fltr(n+1) = fltr(n+1)*(0.42+0.5*cos(2*pi*double(n)/(N-1))+0.08*cos(4*pi*double(n)/(N-1)));
   end
elseif strcmp(wFun,'Rectangular')==1,
    % Do nothing~
end


% 4. Get the realistic filter

% 5. Filter the input signal in time domain. Do not use matlab function 'conv'

%out = conv(in,fltr);

%{
for i=1:size(in),
   s=0;
    for j=0:N-1,
        if i-N+1<1,
        continue;
        end
        s = s+ fltr(j+1)*in(i-j);
    end
    
    out(i) =s;
end
%}

%{
for i=1:length(in),
    x=zeros(1,N);
   
    if i-N+1<1, 
        t=1;
        x(1,1:i) = fliplr(in(t:i)); 
        out(i) =  sum(fltr.*x);
    else
        t=i-N+1;
        x(1,1:N) = fliplr(in(t:i));
        out(i) =  sum(fltr.*x);    
    end
 
end
%}
sampleCount = length(in);
kernelCount = length(fltr);
out = in;
for i = 1:1:sampleCount,
    out(i) = 0;
    for j = 1:1:min(i-1, kernelCount),
        out(i) = out(i) + in(i - j ) * fltr(j);
    end
end


