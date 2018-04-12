close all
clear all
clc

NumberOfRequests=10^5;
NumberOfIterations=10^0;

global Freshness_requirment count1 count2 Router1_hit_count memoryR1_LeastExpe Probability_producers

ProbForSavingVectorR1=1;
DataSize_D=[1 5 10 15 20];
CacheSize_C=100*DataSize_D;
beta=0.5;
ProbForSavingVectorR1=1;
NumberOfProducers_N=5000;
nn=1:NumberOfProducers_N;
ProducersProbability_Zipf(:,1)=(nn.^(-beta))/sum(nn.^(-beta));

optimalX_sim_LowerBound=zeros(1,length(DataSize_D));
optimalX_sim_LU=zeros(1,length(DataSize_D));
LowerBound_LeastExpected=zeros(length(1:5:max(CacheSize_C)),length(DataSize_D));
hit_rate_total_Max_Sim_Zipf_LeastExpe=zeros(length(0:5:max(CacheSize_C)),length(DataSize_D));

%% Optimal X (xStar) calculation Theorotical
optimalX_theo=floor(CacheSize_C./(DataSize_D+1)); % size is same as DataSize_D

%% Uniform Freshness
Freshness=500;
Freshness_Zipf(:,1)=Freshness*ones(NumberOfProducers_N,1);%UniformFreshness
 
%% Exponential inter-arrival time
time=cumsum(exprnd(1,NumberOfRequests,1));
producersRequest_Zipf(:,1)=datasample(1:NumberOfProducers_N,NumberOfRequests,'Weights',ProducersProbability_Zipf');

requests_Zipf=zeros(NumberOfProducers_N,1);
for ii=1:NumberOfRequests
    requests_Zipf(producersRequest_Zipf(ii,1),:)=requests_Zipf(producersRequest_Zipf(ii,1),:)+1;
end

%% Least Expected Variables :::::::::::::::::::::::::::::::::::::::::::::::

% N_min_Zipf_LeastExpe=zeros(1,length(DataSize_D));
% N_max_Zipf_LeastExpe=zeros(1,length(DataSize_D));

tic
 for dd=1:length(DataSize_D)
    display(sprintf('DataSize=%d',DataSize_D(dd)));
%     N_min=0;
%     N_max=0;
    X=0:5:CacheSize_C(dd);
    R1_hit_count_Zipf_LeastExpe=zeros(NumberOfProducers_N,length(X));
    for xx=1:length(X)
    %% Zipf distribution with parameter beta Least Expected
        RemainingProbability=(1-sum(ProducersProbability_Zipf(1:X(xx),1)))/(NumberOfProducers_N-X(xx));
        Probability_producers(:,1)=[ProducersProbability_Zipf(1:X(xx),1); RemainingProbability*ones(NumberOfProducers_N-X(xx),1)];
%         display(sprintf('Optimal X for DataSize=%d is %d',DataSize_D(dd),X(xx)));
    
    %% Calculate Lower Bound at optimalX
        temp=zeros(NumberOfProducers_N,3);
        temp(:,1)=Probability_producers;
        temp(:,2)=Freshness_Zipf;
        temp(:,3)=temp(:,1).*temp(:,2);
    
        Freshness_requirment=Freshness_Zipf(:,1);

        ProbForSavingR1=ProbForSavingVectorR1;

        memoryR1_LeastExpe=zeros(floor((CacheSize_C(dd)-X(xx))/DataSize_D(dd)),2);%zeros(floor((CacheSize_C(dd)-optimalX(dd))/DataSize_D(dd)),2);
        [memoryR1Length, memoryR1Width]=size(memoryR1_LeastExpe);    
        display(sprintf('Size of memoryR1_LeastExpe is %d x %d',memoryR1Length,memoryR1Width));
        
        if memoryR1Length==0
            LowerBound_LeastExpected(xx,dd)=0;
            continue;
        end
    
        Freshness_cap(:,1)=temp(:,2)-(temp(memoryR1Length,3)./temp(:,1));
        LowerBound_LeastExpected(xx,dd)=sum(((temp(1:memoryR1Length,1).^2).*Freshness_cap(1:memoryR1Length))./(1+(temp(1:memoryR1Length,1).*Freshness_cap(1:memoryR1Length))));

    %     display(Freshness_cap(1:memoryR1Length));

        Router1_hit_count=zeros(NumberOfProducers_N,1);

        count1=0;
        count2=0;

        message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
                        ,CacheSize_C(dd),ProbForSavingR1,beta);
        h=msgbox(message);
        clear message

        N_min_temp=0;
        N_max_temp=0;
%     display(sprintf('memoryR1_Size=%d',length(memoryR1_LeastExpe)))
%                 display('Zipf Distribution');
        for ii=1:length(time)
    %                 display(t_inst);
            produ=producersRequest_Zipf(ii,1);
            t_inst=time(ii);
    %                 Frshness=Freshness(t_inst,1);
            [N_min_temp,N_max_temp]=router1_LeastExpe_plain_3class(produ,t_inst,...
                                                        ProbForSavingR1,N_min_temp,N_max_temp);

    %                     if mod(ii,500)==0
    %                         memoryR1_LeastExpe
    %                         display('Here');
    %                     end

        end
%         N_min=N_min_temp; % jj-> row number; kk-> column number
%         N_max=N_max_temp;

        delete(h);
        clear('h');

        R1_hit_count_Zipf_LeastExpe(:,xx)=Router1_hit_count;
        
    end
    clear temp;
    temp(1,:)=sum(R1_hit_count_Zipf_LeastExpe)/NumberOfRequests;
    [~, index]=max(temp);
    hit_rate_total_Max_Sim_Zipf_LeastExpe(dd,1:length(X))=temp;
    optimalX_sim_LU(1,dd)=X(index);
    clear temp;
    temp(1,:)=LowerBound_LeastExpected(:,dd);
    [~, index]=max(temp);
    optimalX_sim_LowerBound(1,dd)=X(index);

%         N_min_Zipf_LeastExpe(1,dd)=N_min;
%         N_max_Zipf_LeastExpe(1,dd)=N_max;
        toc
 end
% hit_rate_total_Max_Sim_Zipf_LeastExpe(:,:)=sum(R1_hit_count_Zipf_LeastExpe)/NumberOfRequests; % Columns represents hit rate for different data size (CacheSize is PROPORTIONAL to DataSize)

clear hit_rate_Simul_Zipf_LeastExpe N_min_Zipf_LeastExpe N_max_Zipf_LeastExpe produ t_inst N_min N_max N_min_temp N_max_temp
 
 %%
temp1=cd;
xinput(:,1)=DataSize_D;
yinputMatrix=[hit_rate_total_Max_Sim_Zipf_LeastExpe' LowerBound_LeastExpected'];
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Uni_LeastExpe_stdDev',hit_rate_total_Sim_Uni_LRU_stdDev',hit_rate_total_Sim_Uni_RAND_stdDev',hit_rate_total_Sim_Uni_SMP_stdDev');
xlabel1=sprintf('Data size (d)');
ylabel1=sprintf('Cache Hit Ratio');
% title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_hitRate_Vs_X\UniformFreshness\LowerBoundAndActaulHitRatioComparision';
legend1={sprintf('CacheHitLU@x*'),sprintf('LowerBound@x*')};
saveFigAs=sprintf('Hit_rate_Vs_DataSizeD_Zipf_beta%d_C%d_F%d_N_%d',beta*10,CacheSize_C(1),Freshness,NumberOfProducers_N);
xlim1=[10 40];
ylim1=[0 0.45];
title1={sprintf('\\beta=%0.2f;Total N=%d;C=%d\\timesD;F=%d',beta,NumberOfProducers_N,CacheSize_C(1),Freshness)};
myplotHitRateVsX(xinput,yinputMatrix,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);

% cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_hitRate_Vs_X');
% save(sprintf('hitRate_Vs_X_C%d',CacheSize_C));