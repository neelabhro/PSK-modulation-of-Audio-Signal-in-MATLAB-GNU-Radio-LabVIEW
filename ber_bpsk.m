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
txsig = 2*input-1;
M = 2;
%txSig = pskmod(y,M,pi/M);
%s = pskmod(input,M);
plot(t,txsig);
title('BPSK Modulated Signal in Time domain');
xlabel('Time Axis');
ylabel('Amplitude of the wave');
noise = 1/sqrt(2) * [randn(1,N) + j*randn(1,N)];
Eb_No = [-5:10]; % multiple Eb/N0 values
figure;
n = length(Eb_No);

for i = 1 : n
   y = txsig + 10 ^ (-Eb_No(i) / 20) * noise;
   noisy = real(y) > 0;
   %BER Calculation
   BER(i) = size(find([input- noisy]),2);

end
BerT = 0.5 * erfc( sqrt(10 .^ (Eb_No / 10)) );
BerS = BER/N;
semilogy(Eb_No, BerT, 'b.-');
hold on
semilogy(Eb_No, BerS, 'mx-');
axis([-5 11 10^-5 0.5])
grid on
legend('Theoritical Values', 'Simulated Values');
xlabel('Eb/No in dB');
ylabel('BIT ERROR RATE');
title('BIT ERROR RATE for BPSK Modulated Audio Signal with AWGN');
