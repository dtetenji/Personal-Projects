% Complex Baseband QPSK Model
% AWGN Channel
% David O. Tetenji
% 16/12/2019

% aim: to model QPSK in awgn(Receiver)

%initialisation
clc % clears the screen
clear all % clears all variables
randn('seed',0); % sets a seed for randn generator

% Variable parameters
% EbN0dB=10;
EbN0dB=[0,1,2,3,4,5,6,7,8,9,10]; % initialise the EbN0 loop 
PkLenBytes=100; % initialise the packet length in bytes
PkNum=1000; % initialise the number of packets to be transmitted
S=1; % initialise the transmit signal power

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
        bpskconvert=2*TxData-1; % BPSK modulate the data
        %for qpsk the next step is to seperate the transmitted symbol into
        %odd and even sequence odd representing
        odd_MSB=bpskconvert(1:2:length(TxData));
        even_LSB=bpskconvert(2:2:length(TxData));
        odd_MSB=odd_MSB/sqrt(2);even_LSB=even_LSB/sqrt(2);
        TxSymbol=(odd_MSB + j*even_LSB);%to represent theoretical qpsk 
       
        %noise
        noise=StDev*(randn(TxSignalLen/2,1)+j*randn(TxSignalLen/2,1))/sqrt(4); % complex baseband awgn vector
          % w=(1/sqrt(2*EbNo(n)))*(randn(1,l)+j*randn(1,l));  %Random noise generation
        %Channel impairment
        RxSymbol=TxSymbol+noise; % Add awgn to transmitted signal
          
        %Receiver
       RxData=rand(PkLenBits,1);
       % compoundCondInd = real(RxSymbol)>0 & imag(RxSymbol)>0;
      % int  oddmsb_rx,evenlsb_rx
        %this first loop is for graycode mapping of received signals
        for Rxindex=1:length(RxSymbol)
            n=Rxindex;
            x=(2*n)-1;
            if real(RxSymbol(Rxindex,1))>0 && imag(RxSymbol(Rxindex,1))>0
            oddmsb_rx=1;
            evenlsb_rx=1;    
            elseif real(RxSymbol(Rxindex,1))>0 && imag(RxSymbol(Rxindex,1))<0
            oddmsb_rx=1;
            evenlsb_rx=0;        
            elseif real(RxSymbol(Rxindex,1))<0 && imag(RxSymbol(Rxindex,1))>0
            oddmsb_rx=0;
            evenlsb_rx=1;         
            elseif real(RxSymbol(Rxindex,1))<0 && imag(RxSymbol(Rxindex,1))<0 
            oddmsb_rx=0;
            evenlsb_rx=0;  
            end
            
           %then put whatever received 2 bits in the first and second 
           RxData(x)=oddmsb_rx;
           RxData(2*n)=evenlsb_rx;
         
           RxData=RxData>0.5;
          % RxData(2*n)=evenlsb_rx;        
        %RxData=real(RxSymbol)>0; 
        % zero threshold detect on the I component
        end

        %Ber measurement
        BitErrors(PkIndex)=sum(xor(TxData,RxData));
        PkErrors(PkIndex)=BitErrors(PkIndex)>0;
        
    end
    
    %Error Rates
    ber(EbN0Index)=sum(BitErrors)/(PkNum*PkLenBits);
    per(EbN0Index)=sum(PkErrors)/PkNum;
    tber(EbN0Index)=erfc(sqrt(EbN0))/2; % theoretical QPSK BER performance
    tper(EbN0Index)=1-(1-tber(EbN0Index))^PkLenBits; % theoretical BPSK PER performance
end
figure
semilogy(EbN0dB,ber,'bd',EbN0dB,tber,'r-');
xlabel('EbNo(dB)');      %Label for x-axis
ylabel('BER');      %Label for y-axis
title('BER vs SNR For QPSK');
legend('simulated','theoretical');
grid on  

figure
title('PER vs SNR');
semilogy(EbN0dB,per,'bd',EbN0dB,tper,'r-');
xlabel('EbNo(dB)');%Label for x-axis
ylabel('PER');%Label for y-axis
title('PER vs SNR For QPSK');
legend('simulated','theoretical');
grid on  
figure
 scatter(odd_MSB,even_LSB,'b');
 ax = gca;
 ax.XAxisLocation= 'origin'; 
 ax.YAxisLocation= 'origin';
 grid on;
 hold on;
 scatter (real(RxSymbol),imag(RxSymbol),'r');
 xlabel('In phase axis I(t)');%Label for x-axis
ylabel('Quadrature axis I(t)');%Label for y-axis
title('constellation diagram for qpsk with snr of 10db');
