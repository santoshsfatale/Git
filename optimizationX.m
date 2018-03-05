% function [optimumX valueAtoptimumX]=optimizationX(CacheSize,DataSizeD,Popularity,Freshness)
clear all
clc

Producers=200
CacheSize=20
DataSizeD=1
nn=1:Producers;
beta=0.2;
ProducersProbability_Zipf(1,:)=(nn.^-beta)/sum((nn.^-beta));
Popularity=ProducersProbability_Zipf;

F_a=5;
F_b=100;
F_c=5;
N_a=CacheSize;
N_b=CacheSize;
N_c=Producers-N_a-N_b;
Freshness_Zipf(:,1)=[repmat(F_a,N_a,1);repmat(F_b,N_b,1);repmat(F_c,N_c,1)];
clear F_a F_b F_c N_a N_b N_c
Freshness=Freshness_Zipf;

% setC_dash=[]; % set of Popularities of producers s.t. \lambda_i*F_i < \lambda_j*F_j for all i < j
setC=[]; % Set of proudcers whose data is saved in Cache s.t. \lambda_i*F_i < \lambda_j*F_j for all i < j
C=0;
setP(:,1)=Popularity(1:CacheSize);
temp1=0;
%     temp2=0;
NumberofIterations=CacheSize;
for ii=1:NumberofIterations
    ii
    if isempty(setC)
        clear temp3
        temp3(1,:)=setP;
        clear setP
        setP(1,:)=temp3(1,1:CacheSize-DataSizeD);
        clear temp3
%     end
% 
%     if mod(abs(CacheSize-length(setP)),DataSizeD)==0
        C=C+1;
        display('Here 1')
    end

    BasicSetC=createSetC(setP,Freshness,Popularity); % Column1: modified Popularity; Column2: Freshness; Column3: Popularity*Freshness
    modifiedFreshness(1:C,1)=BasicSetC(1:C,2)-(BasicSetC(C,1)*BasicSetC(C,2)./BasicSetC(1:C,1));
    setC(1:C,1)=BasicSetC(1:C,1).*modifiedFreshness; %Popularity*modifiedFreshness 
    temp2=sum(setC(1:C-1,1)./(1+setC(1:C-1,1)))
    
    if isempty(modifiedFreshness(1:C-1,1))
        temp4=length(setP);
        temp3=setP;
        clear setP
        setP(1,:)=temp3(1,1:temp4-1);
        clear temp4 temp3
        display('Here 2')
        if mod(abs(CacheSize-length(setP)),DataSizeD)==0
            C=C+1;
        end
        continue        
    end

    if temp2>=temp1
        temp4=length(setP);
        temp3=setP;
        clear setP
        setP(1,:)=temp3(1,1:temp4-1);
        clear temp4 temp3
        temp1=temp2;
        display('Here 3')
        if mod(abs(CacheSize-length(setP)),DataSizeD)==0
            C=C+1;
        end
        continue;
    else
        display('Here 4')
        break
    end
    
end
valueAtoptimumX=temp1
optimumX=length(setP);
    
        

