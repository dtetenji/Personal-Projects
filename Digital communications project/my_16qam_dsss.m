% Complex Baseband 16QAM Model with DSSS
% AWGN Channel
% David O. Tetenji
% 16/12/2019
% aim: to model 16 QAM in awgn(Receiver)
%initialisation
clc % clears the screen
clear all % clears all variables
randn('seed',0); % sets a seed for randn generator

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
        sp=[];o1=[];o2=[];clear i;
    for i=1:4:800;
        sp=[TxData(i:i+3,1)];  % Serial to Parallel 4-bit Register
        I=sp(1,1);          % Separation of I and Q bits
        Id=sp(2,1);
        Q=sp(3,1);
        Qd=sp(4,1);
    
        if I==0 && Id == 0 % Assigning Amplitude levels for I-channel
             o1=[o1 -3]; % if input is 00, output is -3
        elseif I==0 && Id == 1
                o1=[o1 -1]; % if input is 01, output is -1
        elseif I==1 && Id == 0
                o1=[o1 3]; % if input is 10, output is 1
        elseif I==1 && Id == 1
                o1=[o1 1]; % if input is 11, output is 3
            end
              
    if Q==0 && Qd == 0 % Assigning Amplitude levels for I-channel
             o2=[o2 -3]; % if input is 00, output is -3
        elseif Q==0 && Qd == 1
                o2=[o2 -1]; % if input is 01, output is -1
        elseif Q==1 && Qd == 0
                o2=[o2 3]; % if input is 10, output is 1
        elseif Q==1 && Qd == 1
                o2=[o2 1]; % if input is 11, output is 3
            end
              
    %clear sp, clear I, clear Id, clear Q, clear Qd; 
    end
        o3=o1'; o4=o2';
        TxSymbol1=(o3 + j*o4);%to represent theoretical qpsk 
        TxSymbol2= TxSymbol1*(1/sqrt(10));% TO normalise transmit power to 1
        TxSymbol2= pn.*TxSymbol2;
        TxSymbol2= TxSymbol2.';
        TxSymbol2= TxSymbol2(:);
        %noise
        noise=StDev*(randn((TxSignalLen*length(pn))/4,1)+j*randn((TxSignalLen*length(pn))/4,1))/sqrt(8); % complex baseband awgn vector
          % w=(1/sqrt(2*EbNo(n)))*(randn(1,l)+j*randn(1,l));  %Random noise generation
        %Channel impairment
        RxSymbol=TxSymbol2+noise; % Add awgn to transmitted signal

        %Receiver
         RxSymbol = vec2mat(RxSymbol,length(pn));
        RxSymbol= pn.*RxSymbol; 
       RxSymbol=sum(RxSymbol,2)/4;
       RxData=rand(PkLenBits,1);

        %this for loop is for graycode decoding of received signals
        for Rxindex=1:length(RxSymbol)
            n=Rxindex;
            z=(4*n)-1;y=(4*n)-2;x=(4*n)-3;
            if real(RxSymbol(Rxindex,1))>0 && real(RxSymbol(Rxindex,1))<0.63245
            q0=1;q1=1;   
            elseif real(RxSymbol(Rxindex,1))>0.6324 
            q0=1;q1=0;        
            elseif real(RxSymbol(Rxindex,1))<0 && real(RxSymbol(Rxindex,1))>-0.6324
            q0=0;q1=1;        
            elseif real(RxSymbol(Rxindex,1))<-0.6324  
            q0=0;q1=0;  
            end
            if imag(RxSymbol(Rxindex,1))>0 && imag(RxSymbol(Rxindex,1))<0.63245
            q2=1;q3=1;   
            elseif imag(RxSymbol(Rxindex,1))>0.6324 
            q2=1;q3=0;        
            elseif imag(RxSymbol(Rxindex,1))<0 && imag(RxSymbol(Rxindex,1))>-0.6324
            q2=0;q3=1;        
            elseif imag(RxSymbol(Rxindex,1))<-0.6324  
            q2=0;q3=0;  
            end
           %then put whatever received 2 bits in the first and second 
           RxData(x)=q0;
           RxData(y)=q1;
           RxData(z)=q2;
           RxData(4*n)=q3;
           
         
          % RxData(2*n)=evenlsb_rx;        
        %RxData=real(RxSymbol)>0; 
        % zero threshold detect on the I component
        end
  RxData=RxData>0.5;
        %Ber measurement
        BitErrors(PkIndex)=sum(xor(TxData,RxData));
        PkErrors(PkIndex)=BitErrors(PkIndex)>0;
        
    end
    
    %Error Rates
    ber(EbN0Index)=sum(BitErrors)/(PkNum*PkLenBits);
    per(EbN0Index)=sum(PkErrors)/PkNum;
    tber(EbN0Index)=(1/4)*(3/2)*erfc(sqrt(0.4*EbN0)); % theoretical BPSK BER performance
    % theoryBer = (1/k)*3/2*erfc(sqrt(k*0.1*(10.^(Eb_N0_dB/10))));
    tper(EbN0Index)=1-(1-tber(EbN0Index))^PkLenBits; % theoretical BPSK PER performance
end
figure
semilogy(EbN0dB,ber,'bd',EbN0dB,tber,'r-');
xlabel('EbNo(dB)');  %Label for x-axis
ylabel('BER');      %Label for y-axis
title('BER vs SNR For 16 QAM');
legend('simulated','theoretical');
grid on     
figure
title('PER vs SNR');
semilogy(EbN0dB,per,'bd',EbN0dB,tper,'r-');
xlabel('EbNo(dB)');%Label for x-axis
ylabel('PER');%Label for y-axis
title('PER vs SNR For 16 QAM');
legend('simulated','theoretical');
grid on  
figure
 scatter(real(TxSymbol2),imag(TxSymbol2),'b');
 ax = gca;
 ax.XAxisLocation= 'origin'; 
 ax.YAxisLocation= 'origin';
 grid on;
 hold on;
 scatter (real(RxSymbol),imag(RxSymbol),'y');
 xlabel('In phase axis I(t)');%Label for x-axis
ylabel('Quadrature axis I(t)');%Label for y-axis
title('constellation diagram for 16 qam with snr of 10db');

