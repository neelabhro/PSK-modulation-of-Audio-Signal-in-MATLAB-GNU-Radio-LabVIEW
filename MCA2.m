%Neelabhro Roy
%2016171
%IIIT-DELHI
clear all;
close all;
clc;

[y,Fs] = audioread('handel2.wav');
% This returns the sampled data into y, and the sampling rate of the data
% to Fs
N = length(y);
mx = max(y)./2;
t = 0:1./Fs:((N-1)./Fs);
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

 for i = 1 : N
     if(y(i) < mx)
         y(i) = 0;
     end
     
     if (y(i) >= mx)
         y(i) = 1;
     end
 end    

input = transpose(y);
%input = y;
txsig = 2*input-1;
M = 2;
%txSig = pskmod(y,M,pi/M);
%s = pskmod(input,M);
plot(t,txsig);
title('BPSK Modulated Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');

%AWGN
noise = 1/sqrt(2) * [randn(1,N) + j*randn(1,N)];

%Rayleigh Fading coefficient
h = randn(1,N) + j*randn(1,N);
h = sqrt(h);
Eb_No = [-5:20]; % multiple Eb/N0 values
figure;
n = length(Eb_No);

for i = 1 : n
   noisy1 = txsig.*h + 10 ^ (-Eb_No(i) / 20) * noise;
   noisy2 = txsig + 10 ^ (-Eb_No(i) / 20) * noise;
   %noisy = txsig.*h';
   noisy1 = real(noisy1) > 0;
   noisy2 = real(noisy2) > 0;
   %BER Calculation
   BER1(i) = size(find([input- noisy1]),2);
   BER2(i) = size(find([input- noisy2]),2);
end

BerT = 0.5 * erfc( sqrt(10 .^ (Eb_No / 10)) );
BerS1 = BER1/N;
BerS2 = BER2/N;
semilogy(Eb_No, BerT, 'b.-');
hold on
semilogy(Eb_No, BerS1, 'mx-');
hold on
semilogy(Eb_No, BerS2, 'g--*');
axis([-5 20 10^-5 1])
grid on
legend('Theoritical Values', 'Rayleigh Fading and AWGN','With AWGN');
xlabel('Eb/No in dB');
ylabel('BIT ERROR RATE');
title('BIT ERROR RATE for BPSK Modulated Audio Signal with AWGN');