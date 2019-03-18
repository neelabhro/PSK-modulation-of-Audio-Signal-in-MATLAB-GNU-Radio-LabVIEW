%Neelabhro Roy
%2016171
%IIIT-DELHI

clear all;
close all;
clc;

Eb_No = [0:20];
n = length(Eb_No);
SNR = Eb_No + 10*log10(4);

for i = 1:n

    Total_bits1 = 0;    
    Error_bits1 = 0;
    
    Total_bits2 = 0;    
    Error_bits2 = 0;
    
    while Error_bits1 < 100
    
        bits  = round(rand(1,100));
        tx1 = qammod(bits,8);
        tx2 = pskmod(bits,8);
        N1 = length(tx1);
        N2 = length(tx2);
        h = sqrt((1/2)*((randn(1,N1)).^2+(randn(1,N1)).^2));

        rx1 = tx1 .* h;
        rx2 = tx2 .* h;

        N0 = 1/10^(SNR(i)/10);
        %noise = 1/sqrt(2) * [randn(1,n) + j*randn(1,n)];
        %N0 = 10 ^ (-Eb_No(i) / 20) * noise;
        rx1 = rx1 + sqrt(N0/2)*(randn(1,N1) + 1i*randn(1,N1));
        rx2 = rx2 + sqrt(N0/2)*(randn(1,N2) + 1i*randn(1,N2));

        % Demodulation
        rx1 = rx1 ./ h;
        rx2 = rx2 ./ h;
        demod1 = qamdemod(rx1,8);
        demod2 = pskdemod(rx2,8);
        
        err1 =  bits - demod1 ;
        Error_bits1 = Error_bits1 + sum(abs(err1));
        Total_bits1 = Total_bits1 + length(bits);
        
        err2 =  bits - demod2 ;
        Error_bits2 = Error_bits2 + sum(abs(err2));
        Total_bits2 = Total_bits2 + length(bits);
        
    end
    %BER(i) = size(find([bits-demod]),2);
    BER1(i) = Error_bits1 / Total_bits1;
    BER2(i) = Error_bits2 / Total_bits2;

end

semilogy(Eb_No,BER1,'b.-');
hold on;
semilogy(Eb_No,BER2,'g-+');
hold on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER Plot for 8 QAM & 8 PSK Modulation');
BerT = 0.5 * erfc( sqrt(10 .^ (Eb_No / 10)) );
semilogy(Eb_No,BerT,'mx-');
grid on;
legend('8 QAM Rayleigh Fading','8 PSK Rayleigh Fading', 'AWGN Channel');
axis([0 20 10^-4 1]);