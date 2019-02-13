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

%noisy = awgn(y,5,'measured');
%plot(t,noisy);
%title('Signal with AWGN in Time domain');
%xlabel('Time Axis');
%ylabel('Amplitude of the wave');
%figure;
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
M = 2;
%txSig = pskmod(y,M,pi/M);
txsig = pskmod(y,M);
plot(t,txsig);
title('BPSK Modulated Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');

Eb_N0_dB = [-3:10]; % multiple Eb/N0 values
noise = 1/sqrt(2)*[randn(1,n) + j*randn(1,n)];
for i = 1:length(Eb_N0_dB)
   noisyMOD = txsig + 10^(-Eb_N0_dB(i)/20)*transpose(noise); % additive white gaussian noise

   % receiver - hard decision decoding
   ipHat = real(noisyMOD)>0;

   % counting the errors
   nErr(i) = size(find([txsig- ipHat]),2);

end

simBer = nErr/n; % simulated ber
theoryBer = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); % theoretical ber

figure;
semilogy(Eb_N0_dB,theoryBer,'b.-');
hold on
semilogy(Eb_N0_dB,simBer,'mx-');
axis([-3 10 10^-5 0.5])
grid on
legend('theory', 'simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for BPSK modulation');