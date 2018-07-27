% hw3.m - 請完整寫出把三首歌都分出來的過程
%%

% Q1
clear all;close all;clc;

% Read in input audio file (wavread or audioread)

[songs,fs] = audioread('hw3_mix.wav');
FS1=fs;
FS2=fs;
FS3=fs;

 [y1 h1] = myFilter(songs, FS1, 1001, 'Rectangular', 'low-pass', 400);
 [y2 h2] =  myFilter(songs, FS2, 1001, 'Rectangular', 'bandpass', [400 600]);
 [y3 h3] =  myFilter(songs, FS3,1001, 'Rectangular', 'high-pass', 600);
 % Filtering


audiowrite('audio1.wav',y1,FS1);
audiowrite('audio2.wav',y2,FS2);
audiowrite('audio3.wav',y3,FS3);
    
%y2=y2.*100;

% Frequency analysis - you can use the following code to plot spectrum
% y1: signal, Fs1: sampling rate
%%
xx = linspace(1,1001,1001);
figure,plot(xx,h1);
savefig('lowpass_FIR_time_domain.fig');
title('lowpass FIR time domain');

xx = linspace(1,1001,1001);
figure,plot(xx,h2);
savefig('bandpass_FIR_time_domain.fig');
title('bandpass FIR time domain');

xx = linspace(1,1001,1001);
figure,plot(xx,h3);
savefig('highpass_FIR_time_domain.fig');
title('highpass FIR time domain');




L = 2^nextpow2(max(size(h1)));
h1_FFT = fft(h1,L);
xx = FS1/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(h1_FFT(1:L/2+1)));
axis([0,2000,0,1]);
savefig('lowpass_FIR_freq_domain.fig');
title('lowpass FIR freq domain');

L = 2^nextpow2(max(size(h2)));
h2_FFT = fft(h2,L);
xx = FS2/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(h2_FFT(1:L/2+1)));
axis([0,2000,0,1]);
savefig('bandpass_FIR_freq_domain.fig');
title('bandpass FIR freq domain');

L = 2^nextpow2(max(size(h3)));
h3_FFT = fft(h3,L);
xx = FS3/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(h3_FFT(1:L/2+1)));
axis([0,2000,0,1]);
savefig('highpass_FIR_freq_domain.fig');
title('highpass FIR freq domain');

L = 2^nextpow2(max(size(y1)));
y1_FFT = fft(y1,L);
xx = FS1/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(y1_FFT(1:L/2+1)));
axis([0,2000,0,1000]);
savefig('lowpassMusic_freq_domain.fig');
title('lowpass Music freq domain');

L = 2^nextpow2(max(size(y2)));
y2_FFT = fft(y2,L);
xx = FS2/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(y2_FFT(1:L/2+1)));
axis([0,2000,0,1000]);
savefig('bandpassMusic_freq_domain.fig');
title('bandpassMusic freq domain');

L = 2^nextpow2(max(size(y3)));
y3_FFT = fft(y3,L);
xx = FS3/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(y3_FFT(1:L/2+1)));
axis([0,2000,0,1000]);
savefig('highpassMusic_freq_domain.fig');
title('highpassMusic freq domain');

L = 2^nextpow2(max(size(songs)));
fsongs = fft(songs,L);
figure, plot(xx,abs(fsongs(1:L/2+1)));
axis([0,2000,0,1000]);
savefig('originalMusic_freq_domain.fig');
title('originalMusic freq domain.');
% Save the filtered audio (wavwrite or audiowrite)



%%
%Q2

[input,freq] = audioread('AnJing_4bit.wav');

xx = linspace(1,length(input),length(input));
figure,plot(xx,input);
title(' Q2 Input Time domain');

L = 2^nextpow2(max(size(input)));
input_FFT = fft(input,L);
xx = freq/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(input_FFT(1:L/2+1)));
title('Q2 Input Frequency domain');

dithered = zeros(1,length(input));
for a=1:length(input),
   noise = (rand*0.25) -0.125;
   dithered(a) = input(a) + noise;
  % disp(dithered(a));
end
xx = linspace(1,length(dithered),length(dithered));
figure,plot(xx,dithered);
title('Dithered Time domain');

L = 2^nextpow2(max(size(dithered)));
dithered_FFT = fft(dithered,L);
xx = freq/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(dithered_FFT(1:L/2+1)));
%axis([1 2000 0 inf]);
title('Dithered Frequency domain');

audiowrite('dithered.wav',dithered,freq);

input = input.*128;
dithered = dithered.*128;
e = 0;
shaped = zeros(1,length(dithered));
e(1,1) = 0;

Quantized = zeros(1,length(dithered));

for b=1:length(dithered),
    
    shaped(b)=dithered(b)+(2*e);
    %disp(e(b));
    if shaped(b)>=128,
        shaped(b)=127;
    elseif shaped(b)<-128;
        shaped(b)=-128;
    end
    
    
    Quantized(b) =floor(shaped(b));
    %{
    temp = mod(abs(shaped(b)),16);
    if(temp<=8)
       
        if(Quantized(b)>0)
            Quantized(b) = Quantized(b)-temp;
        else
            Quantized(b) = Quantized(b) +temp;
        end
        
    else
        
        if(Quantized(b)>0)
            Quantized(b) = Quantized(b) + (16 - temp);
        else
            Quantized(b) = Quantized(b) - (16 - temp);
        end
        
        
    end
    %}
    e=  shaped(b) - Quantized(b);                    % 這邊的ｆｉｎ到底是有沒有dither過的
end
shaped = shaped./128;
xx = linspace(1,length(shaped),length(shaped));
figure,plot(xx,shaped);
title('Dithered & Noise shaped Time domain');

L = 2^nextpow2(max(size(shaped)));
shaped_FFT = fft(shaped,L);
xx = freq/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(shaped_FFT(1:L/2+1)));
%axis([1 2000 0 inf]);
title('Dithered & Noise shaped Frequency domain');

shaped = shaped.*128;
[fil h4]=myFilter(shaped, freq, 1001, 'Rectangular', 'low-pass', 1000);

shaped = shaped./128;


audiowrite('shaped.wav',shaped,freq);

fil = fil./128;
audiowrite('filtered.wav',fil,freq);

xx = linspace(1,length(fil),length(fil));
figure,plot(xx,fil);
title('Dithered & Noise shaped & Filtered time domain');

L = 2^nextpow2(max(size(fil)));
filtered_FFT = fft(fil,L);
xx = freq/2*linspace(0,1,L/2+1);
figure, plot(xx,abs(filtered_FFT(1:L/2+1)));
axis([1 2000 0 inf]);
title('Dithered & Noise shaped & Filtered Frequency domain');


[test h4]=myFilter(input, freq, 1001, 'Rectangular', 'low-pass', 1000);
test = test./128;


xx = linspace(1,length(test),length(test));
figure,plot(xx,test);
audiowrite('test.wav',test,freq);




