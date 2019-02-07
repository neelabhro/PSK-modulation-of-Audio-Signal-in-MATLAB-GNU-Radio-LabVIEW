%Neelabhro Roy
%2016171
%IIIT-DELHI
clear all;
close all;
clc;

clear y Fs;
%Here we are reading the Audio signal
%[y,Fs] = audioread('DITTY1.WAV');
[y,Fs] = audioread('handel2.wav');
% This returns the sampled data into y, and the sampling rate of the data
% to Fs
n = length(y);
t = 0:1./Fs:((n-1)./Fs);
%sound(y,Fs);
hold on

Y = ['The Sample rate of the signal is ',num2str(Fs)];   
disp(Y);
plot(t,y);
title('Input Audio Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the Audio signal');

figure;

FFT = fft(y);
stem(abs(FFT));
title('Input Audio Signal in Frequency domain');
xlabel('Number of samples');
ylabel('Frequency Amplitude');
figure;

noisy = awgn(y,40,'measured');
plot(t,noisy);
title('Signal with AWGN in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');
figure;
qpsk = y;
mx = max(y)./2;

 for i = 1 : n
     if(y(i) < mx)
         y(i) = 0;
     end
     
     if (y(i) >= mx)
         y(i) = 1;
     end
 end    

%filename = 'awgn.wav';
%audiowrite(filename,noisy,Fs); 
mx1 = max(qpsk)./4;
mx2 = max(qpsk)./2;
mx3 = 3*(max(qpsk)./4);

maxamp = max(qpsk);
for i =1:length(qpsk)
    if (qpsk(i)< mx1)
        qpsk(i)=0;
        
    elseif (qpsk(i)>=mx1 && qpsk(i)<mx2)
        qpsk(i)=1;
        
    elseif (qpsk(i)>=mx2 && qpsk(i)<mx3)
        qpsk(i)=2;
        
    else
        qpsk(i)=3;
    end
end
plot(t,y);
title('Input Audio Signal in Time domain post NRZ');
figure;
%z = @(x)cos(2*pi*1*x);
%y1=z(t);
%plot(t,y1);
%title('Cosine Wave in Time domain');
%xlabel('Time Axis');
%ylabel('Amplitude of the wave');
%figure;

M = 2;
%txSig = pskmod(y,M,pi/M);
txsig = pskmod(y,M);

N = 4;
txsigQ = pskmod(qpsk,N);
%txsig1 = txsig.*y1(length(txsig));
plot(t,txsig);
title('BPSK Modulated Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');
figure;
%plot(t,noisyMOD);
%title('BPSK Modulated Signal with AWGN in Time domain');
%xlabel('Time Axis');
%ylabel('Amplitude of the wave');

plot(t,txsigQ);
title('QPSK Modulated Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');

%p = snr(noisy,8192);
%c = [-1 1];
%data = randi([0 1],n,1);
%modData = genqammod(data,c);
%rxSig = awgn(modData,20,'measured');
noisyMOD = awgn(txsig,20);
noisyMODQ = awgn(txsigQ,20);
h = scatterplot(noisyMOD);
title('Scatter Plot of BPSK Modulated signal');

hQ = scatterplot(noisyMODQ);
title('Scatter Plot of QPSK Modulated signal');

noisyDEMOD = pskdemod(noisyMOD,M);
noisyDEMODQ = pskdemod(noisyMODQ,N);

bit_error_rate_BPSK = sum(y~=noisyDEMOD)/n
bit_error_rate_QPSK = sum(y~=noisyDEMODQ)/n

