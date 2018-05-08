%% Test validity of Intuition for behavior of top Producers
%###################################################################################################
% 
% 
% Program checks validity of intuition behind behavior of top producers,i.e.,
% hit rate for those produers is close to the hit lower bound given.
% 
% 
% 
% 
%##################################################################################################
% 3 Bucket model and Zipf distribution with three types of users and
% Freshness requirement as follows:
% Freshness=[F_a F_b F_c] where F_b=F_a*10^2 or some higher value.
% Setting is as follows:
% 
% 3 Bucket Uniform Distribution: 
% Prob_a, Prob_b=0.99*Prob_a, Prob_c=1-Prob_a-Prob_b
% Freshness requirement as above
% Number of Producers in each bucket are N_a=C,N_b=C,N_c=N-N_a-N_b where C
% is cache size and N is total number of producers.
% 
% Zipf Distribution:
% Use moderate Zipf parameter beta for probability distribution and use
% remaining setting as 3 Bucket Uniform distribution.
%% Probabilistic Save Implementation
clear all;
% close all;
% clc;
%%
NumberOfRequests=10^4;
NumberOfIterations=10^0;
Producers=5000; % Number of Producers
global Pop_producers

global Freshness_requirment
const=10^2*0.8;
Freshness=1000;
% Freshness_requirment=[F_a F_b F_c];

RemovedProducerClassIndexIndicator=zeros(NumberOfRequests,2);
RemovedProducerRecord=zeros(NumberOfRequests,2);

ProbForSavingVectorR1=1;%0.2:0.2:1.0;%1.0;
CacheSize=100:100:500;


global Router1_hit_count
beta=2.0;%0.5:0.3:1.7;

hit_rate_total_Sim_Zipf_LeastExpe=zeros(NumberOfIterations,length(CacheSize));

% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

% Characteristic_time_Uni=zeros(Producers,length(CacheSize));
% Characteristic_time_Zipf=zeros(Producers,length(CacheSize));

global memoryR1_LeastExpe Probability_producers

global count1 count2% Checks cache is empty or not.

%% ###################################### Zipf Distribution with parameter beta #######################################
nn=1:Producers;
ProducersProbability_Zipf(1,:)=(nn.^-beta)/sum((nn.^-beta));
ProducersProbability_ZipfModified=zeros(length(CacheSize),Producers);
% producersRequest_Zipf(:,1)=datasample(1:Producers,NumberOfRequests,'Weights',ProducersProbability_Zipf');
% temp1=repmat(ProducersProbability_Zipf',1,length(CacheSize));
% Freshness_Zipf=Freshness_const./temp1;
Freshness_Zipf=ones(Producers,1)*Freshness;

display(sprintf('sum(ProducersProbability_ZipfModified)=%f',sum(ProducersProbability_ZipfModified)));

clear temp1;

tic
for kk=1:NumberOfIterations
    display(sprintf('Iteration Number=%d',kk));
    %% Exponential inter-arrival time
    time=cumsum(exprnd(1,NumberOfRequests,1));
    producersRequest_Zipf(:,1)=datasample(1:Producers,NumberOfRequests,'Weights',ProducersProbability_Zipf');

    %% Least Expected Variables :::::::::::::::::::::::::::::::::::::::::::::::
    R1_hit_count_Zipf_LeastExpe=zeros(Producers,length(CacheSize));

    N_min_Zipf_LeastExpe=zeros(length(CacheSize),1);
    N_max_Zipf_LeastExpe=zeros(length(CacheSize),1);

    %% Zipf distribution with parameter beta Least Expected/Useful
    for nn=1:length(beta)
        N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
        N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
        Probability_producers(1,:)=ProducersProbability_Zipf(nn,:);

        for cache=1:length(CacheSize)
            Freshness_requirment=Freshness_Zipf;

            for jj=1:length(ProbForSavingVectorR1)
                ProbForSavingR1=ProbForSavingVectorR1(jj);
        % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
        % First Column: latest time_instant when data was being used under
        % condition it was fresh.
        % Second Column: Producer number
        % Third Column: time_stamp at ehich data for corresponding producer was
        % being fetched and stored.
                memoryR1_LeastExpe=zeros(CacheSize(cache),2);

                Router1_hit_count=zeros(Producers,1);

                count1=0;
                count2=0;

                message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
                                ,CacheSize(cache),ProbForSavingR1,beta(nn));
                h=msgbox(message);
                clear message

                N_min_temp=0;
                N_max_temp=0;
%                 display('Zipf Distribution');
                for ii=1:length(time)
        %                 display(t_inst);
                    produ=producersRequest_Zipf(ii,nn);
                    t_inst=time(ii);
        %                 Frshness=Freshness(t_inst,1);
                    [N_min_temp,N_max_temp]=router1_LeastExpe_plain_3class(produ,t_inst,...
                                                                ProbForSavingR1,N_min_temp,N_max_temp);

                end
                N_min(jj,cache)=N_min_temp; % jj-> row number; kk-> column number
                N_max(jj,cache)=N_max_temp;

                delete(h);
                clear('h');
            end

            R1_hit_count_Zipf_LeastExpe(:,cache)=Router1_hit_count;
        end
        N_min_Zipf_LeastExpe(:,nn)=N_min;
        N_max_Zipf_LeastExpe(:,nn)=N_max;
    end
    toc
%     display('Done Zipf');

    requests_Zipf=zeros(Producers,length(CacheSize));
    for ii=1:NumberOfRequests
        requests_Zipf(producersRequest_Zipf(ii,1),:)=requests_Zipf(producersRequest_Zipf(ii,1),:)+1;
    end


    % requests_Uni(1:3,1)
    % R1_hit_count_Uni(1:3,1)
    % temp1(:,1)=R1_hit_count(1:3,1);
    % temp2(:,1)=requests(1:3,1);
    % display('Hit rate Simulation for Zipf Distribution')
    % temp1./temp2
    % R1_hit_count_Zipf./requests_Zipf
    % temp2=repmat(requests_Zipf,1,1,length(CacheSize));

%     hit_rate_Simul_Zipf_LeastExpe=R1_hit_count_Zipf_LeastExpe./requests_Zipf;
%     clear temp1 temp2
    hit_rate_total_Sim_Zipf_LeastExpe(kk,:)=sum(R1_hit_count_Zipf_LeastExpe)/sum(requests_Zipf);%NumberOfRequests;

end

%% Elapsed time is 14.621220 seconds.

%% Lower Bound
Freshness_cap=zeros(Producers,length(CacheSize));
for ii=1:length(CacheSize)
    Freshness_cap(1:CacheSize(ii),ii)=Freshness*(1-(ProducersProbability_Zipf(CacheSize(ii))./ProducersProbability_Zipf(1:CacheSize(ii))));
end
lowerBound=zeros(1,length(CacheSize));
for ii=1:length(CacheSize)
    lowerBound(ii)=sum((ProducersProbability_Zipf(1:CacheSize(ii)).^2.*Freshness_cap(1:CacheSize(ii)))...
                 ./(1+ProducersProbability_Zipf(1:CacheSize(ii)).*Freshness_cap(1:CacheSize(ii))));
end



%% Upper Bound
upperBound1=zeros(1,length(CacheSize));
upperBound2=zeros(1,length(CacheSize));
for ii=1:length(CacheSize)
    upperBound1(ii)=sum(((ProducersProbability_Zipf(1:CacheSize(ii)).^2).*Freshness)./(1+(ProducersProbability_Zipf(1:CacheSize(ii)).*Freshness)));
    upperBound2(ii)=sum(ProducersProbability_Zipf(1:CacheSize(ii)));
end
% upperBound2=ProducersProbability_Zipf(1:CacheSize);
clear N_min_Zipf_LeastExpe N_min_Zipf_LRU N_min_Zipf_RAND N_min_Zipf_SMP N_max_Zipf_LeastExpe N_max_Zipf_LRU N_max_Zipf_RAND N_max_Zipf_SMP
clear produ t_inst N_min N_max N_min_temp N_max_temp

%% Result Plot
% myplotNew(xinput,yinputMatrix_avg,yinputMatrix_stdDev,xlabel1,ylabel1,title1,legend1,xlim1,ylim1,saveFigAs,directory)
% myplotNew will take care of 3\sigma error-bar in plot.
clear temp1;
temp1=cd;
xinput(:,1)=1:CacheSize;
yinputMatrix_avg=horzcat(R1_hit_count_Zipf_LeastExpe(1:CacheSize,1)./requests_Zipf(1:CacheSize,1),lowerBound',upperBound1');
xlabel1=sprintf('Producer Index');
ylabel1=sprintf('Probability of Hit');
title1=sprintf(sprintf('Comparision of hits beta =%1.2f(simulation and Lower Bound)',beta));
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_F_b_400';
legend1={sprintf('Simulation'),sprintf('Lower Bound'),sprintf('Upper Bound')};
saveFigAs=sprintf('Hit_rate_Vs_Cache_Size_policies_Zipf');
xlim1=[10 40];
ylim1=[0 1];
myplotHitRateVsX(xinput,yinputMatrix_avg,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);
