% Complex Baseband BPSK Model
% AWGN Channel with dsss
% T. O'Farrell modified by David Tetenji
% 2015.07.23

% aim: to model BPSK in awgn

%initialisation
clc % clears the screen
clear all % clears all variables
randn('seed',0); % sets a seed for randn generator or rng(0);

% Variable parameters
% EbN0dB=10;
EbN0dB=[0,1,2,3,4,5,6,7,8,9,10]; % initialise the EbN0 loop 
PkLenBytes=100; % initialise the packet length in bytes
PkNum=1000; % initialise the number of packets to be transmitted
pn=[1,1,-1,1];
S=1*length(pn); % initialise the transmit signal power
% Derived Parameters
PkLenBits=8*PkLenBytes;
TxSignalLen=PkLenBits;

% EbN0 loop
for EbN0Index=1:length(EbN0dB)

    % Loop derived parameters
    EbN0=10^(EbN0dB(EbN0Index)/10); % set EbN0 value
    StDev=sqrt(S/EbN0); % set the noise standard deviation

    % Pk Loop
    for PkIndex=1:PkNum
    
        %Transmitter
        TxData=rand(PkLenBits,1)>0.5; % generate the data
        %TxData2= xor(pn,TxData);
        TxSymbol=2*TxData-1; % BPSK modulate the data
        TxSymbol = pn.*TxSymbol;
          TxSymbol= TxSymbol';
          TxSymbol= TxSymbol(:);
      
        %noise
        noise=(StDev)*(randn((TxSignalLen*length(pn)),1)+j*randn((TxSignalLen*length(pn)),1))/sqrt(2); % complex baseband awgn vector
      
        %Channel impairment
        RxSymbol=TxSymbol+noise; % Add awgn to transmitted signal

        %Receiver
        RxSymbol = vec2mat(RxSymbol,length(pn));
        RxData= pn.*RxSymbol; 
        RxData=sum(RxData,2)/4;
        RxData=real(RxData)>0; % zero threshold detect on the I component
        %parity checker
       
        %RxData=(RxData)>=2;
        %  RxData=(sum(RxData,2))>1;
        %Ber measurement
        BitErrors(PkIndex)=sum(xor(TxData,RxData));
       
        PkErrors(PkIndex)=BitErrors(PkIndex)>0;
        
    end
    
    %Error Rates
    ber(EbN0Index)=sum(BitErrors)/(PkNum*PkLenBits);
    per(EbN0Index)=sum(PkErrors)/PkNum;
    tber(EbN0Index)=erfc(sqrt(EbN0))/2; % theoretical BPSK BER performance
    tper(EbN0Index)=1-(1-tber(EbN0Index))^PkLenBits; % theoretical BPSK PER performance
end
figure
semilogy(EbN0dB,ber,'bd',EbN0dB,tber,'r-');
xlabel('EbNo(dB)');      %Label for x-axis
ylabel('BER');      %Label for y-axis
title('BER vs SNR For BPSK');
legend('simulated','theoretical');
grid on     
figure
title('PER vs SNR');
semilogy(EbN0dB,per,'bd',EbN0dB,tper,'r-');
xlabel('EbNo(dB)');%Label for x-axis
ylabel('PER');%Label for y-axis
title('PER vs SNR For Bpsk');
legend('simulated','theoretical');
grid on  
%figure
 %scatter(real(TxSymbol),imag(TxSymbol),'b');
 %ax = gca;
 %ax.XAxisLocation= 'origin'; 
 %ax.YAxisLocation= 'origin';
 %grid on;
 %hold on;
 %scatter (real(RxSymbol),imag(RxSymbol),'r');
 %xlabel('In phase axis I(t)');%Label for x-axis
%ylabel('Quadrature axis Q(t)');%Label for y-axis
%title('constellation diagram for Bpsk with snr of 10db');
