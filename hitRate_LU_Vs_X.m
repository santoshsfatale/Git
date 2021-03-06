%% 
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
close all;
% clc;
%%
NumberOfRequests=10^5;
NumberOfIterations=10^0;
Producers=50*10^2; % Number of Producers (N)
global Pop_producers

global Freshness_requirment
const=10^2*1;
F_a=5;
F_b=const*F_a;
F_c=F_a;
% Freshness_requirment=[F_a F_b F_c];

RemovedProducerClassIndexIndicator=zeros(NumberOfRequests,2);
RemovedProducerRecord=zeros(NumberOfRequests,2);

ProbForSavingVectorR1=1;%0.2:0.2:1.0;%1.0;
DataSize_D=[1 10 20];
CacheSize_C=100*DataSize_D;
CacheSize_X=zeros(length(DataSize_D),length(0:5*max(DataSize_D):max(CacheSize_C)));
for ii=1:length(DataSize_D)
    clear temp1
    temp1=0:5*DataSize_D(ii):CacheSize_C(ii);
    CacheSize_X(ii,1:length(temp1))=temp1;
end
% CacheSize_X=[0:20 25:5:CacheSize_C-20 CacheSize_C-19:CacheSize_C];
% CacheSize_X=[0:20 25:5:Producers-20 Producers-19:Producers];
% CacheSize_X=0:20;
% Factor=1.0
% RouterStorageCapacity=floor(Factor*CacheSize);

global Router1_hit_count %RemovedProducerIndexIndicator RemovedProducer memoryR1_LeastExpeRecord memoryR1_LeastExpeModifiedRecord
% RemovedProducerIndexIndicator=zeros(1,NumberOfRequests);
% RemovedProducer=zeros(1,NumberOfRequests);
% memoryR1_LeastExpeRecord=zeros(2,CacheSize,NumberOfRequests);
% memoryR1_LeastExpeModifiedRecord=zeros(2,CacheSize,NumberOfRequests);


% Prob_a=0.4;%0.25:0.05:0.45;
beta=0.5;%0.5:0.3:1.7;
display(sprintf('beta=%0.2f',beta));
% hit_rate_total_Sim_Uni_LeastExpe=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Uni_LeastExpeModified=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Uni_SMP=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Uni_RAND=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Uni_LRU=zeros(NumberOfIterations,length(CacheSize));

% hit_rate_total_Sim_Zipf_LeastExpe=zeros(length(DataSize_D),length(CacheSize_X));
% hit_rate_total_Sim_Zipf_LeastExpeModified=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Zipf_SMP=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Zipf_RAND=zeros(NumberOfIterations,length(CacheSize));
% hit_rate_total_Sim_Zipf_LRU=zeros(NumberOfIterations,length(CacheSize));

% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

% Characteristic_time_Uni=zeros(Producers,length(CacheSize));
% Characteristic_time_Zipf=zeros(Producers,length(CacheSize));

global memoryR1_LeastExpe Probability_producers %memoryR1_LRU memoryR1_SMP memoryR1_RAND 

global count1 count2% Checks cache is empty or not.


%% ######################################### 3 class Uniform Distribution ################################################

tic;
% Prob_b=0.99*Prob_a;
% Prob_c=ones(1,length(Prob_a))-Prob_a-Prob_b;
% ProducersProbability_Uni=zeros(Producers,length(CacheSize));
% ProducersProbability_UniModified=zeros(Producers,length(CacheSize));
% Freshness_Uni=zeros(Producers,length(CacheSize));
% for ii=1:length(CacheSize)
%     N_a=CacheSize(ii);
%     N_b=CacheSize(ii);
%     N_c=Producers-N_a-N_b;
%     ProducersProbability_Uni(:,ii)=[repmat(Prob_a./N_a,N_a,1);repmat(Prob_b./N_b,N_b,1);repmat(Prob_c./N_c,N_c,1)];
%     Freshness_Uni(:,ii)=[repmat(F_a,N_a,1);repmat(F_b,N_b,1);repmat(F_c,N_c,1)];
%     RemainingProbability=(1-(sum(ProducersProbability_Uni(1:RouterStorageCapacity(ii),ii))))/(Producers-RouterStorageCapacity(ii));
%     ProducersProbability_UniModified(:,ii)=[ProducersProbability_Uni(1:RouterStorageCapacity(ii),ii); ones(Producers-RouterStorageCapacity(ii),1)*RemainingProbability];
% end
% 
% display(sprintf('sum(ProducersProbability_UniModified)=%f',sum(ProducersProbability_UniModified)));

% Freshness_Uni=zeros(Producers,length(CacheSize));
% for ii=1:length(CacheSize)
%     Freshness_Uni(:,ii)=const*ProducersProbability_Uni(1,ii)./ProducersProbability_Uni(:,ii);
% end

% for kk=1:NumberOfIterations
%     display(sprintf('Iteration Number=%d',kk));
%     %% Exponential inter-arrival time
%     time=cumsum(exprnd(1,NumberOfRequests,1));
%     producersRequest_Uni=zeros(NumberOfRequests,length(CacheSize));
%     for ii=1:length(CacheSize)
%         producersRequest_Uni(:,ii)=datasample(1:Producers,NumberOfRequests,'Weights',ProducersProbability_Uni(:,ii));
%     end
% 
% %     Freshness_const=Freshness_Uni.*ProducersProbability_Uni;
% 
%     
%     %% Least Expected Variables :::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Uni_LeastExpe=zeros(Producers,length(CacheSize));
% 
%     N_min_3class_LeastExpe=zeros(length(CacheSize),1);
%     N_max_3class_LeastExpe=zeros(length(CacheSize),1);
% 
% 
%     %% 3 class Uniform Distribution Least Expected
% 
%     for nn=1:length(Prob_a)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         for cache=1:length(CacheSize)
%             Probability_producers(1,:)=ProducersProbability_Uni(:,cache);
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Uni(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%     % First Column: Producer number
%     % Second Column: t_inst at which it is being fetched from producer
% 
%                 memoryR1_LeastExpe=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f Probability_a=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,Prob_a(nn));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('3 class Uniform Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Uni(ii,cache);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_LeastExpe_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
%                     memoryR1_LeastExpeRecord(1,:,ii)=memoryR1_LeastExpe(:,1);
%                     memoryR1_LeastExpeRecord(2,:,ii)=memoryR1_LeastExpe(:,2);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end        
% 
%             R1_hit_count_Uni_LeastExpe(:,cache)=Router1_hit_count;
%         end
%         N_min_3class_LeastExpe(:,nn)=N_min;
%         N_max_3class_LeastExpe(:,nn)=N_max;
%     end
%     toc
%     
%     requests_Uni=zeros(Producers,length(CacheSize));
%     for cache=1:length(CacheSize)
%         for ii=1:NumberOfRequests
%             requests_Uni(producersRequest_Uni(ii,cache),cache)=requests_Uni(producersRequest_Uni(ii,cache),cache)+1;
%         end
%     end
%     
%     
%     hit_rate_total_Sim_Uni_LeastExpe(kk,:)=sum(R1_hit_count_Uni_LeastExpe)/NumberOfRequests;
% 
%     RemovedProducerClassIndexIndicator(:,1)=RemovedProducerIndexIndicator;
%     RemovedProducerRecord(:,1)=RemovedProducer;
%     %% Least ExpectedModified Variables :::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Uni_LeastExpeModified=zeros(Producers,length(CacheSize));
% 
%     N_min_3class_LeastExpeModified=zeros(length(CacheSize),1);
%     N_max_3class_LeastExpeModified=zeros(length(CacheSize),1);
% 
%     RemovedProducerIndexIndicator=zeros(1,NumberOfRequests);
%     RemovedProducer=zeros(1,NumberOfRequests);
%     %% 3 class Uniform Distribution Least ExpectedModified
% 
%     for nn=1:length(Prob_a)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         for cache=1:length(CacheSize)
%             Probability_producers(1,:)=ProducersProbability_UniModified(:,cache);
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Uni(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%     % First Column: Producer number
%     % Second Column: t_inst at which it is being fetched from producer
% 
%                 memoryR1_LeastExpe=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f Probability_a=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,Prob_a(nn));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('3 class Uniform Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Uni(ii,cache);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_LeastExpe_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
%                     memoryR1_LeastExpeModifiedRecord(1,:,ii)=memoryR1_LeastExpe(:,1);
%                     memoryR1_LeastExpeModifiedRecord(2,:,ii)=memoryR1_LeastExpe(:,2);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end        
% 
%             R1_hit_count_Uni_LeastExpeModified(:,cache)=Router1_hit_count;
%         end
%         N_min_3class_LeastExpeModified(:,nn)=N_min;
%         N_max_3class_LeastExpeModified(:,nn)=N_max;
%     end
%     toc
%     
%     RemovedProducerClassIndexIndicator(:,2)=RemovedProducerIndexIndicator;
%     RemovedProducerRecord(:,2)=RemovedProducer;
% 
%     % delete(h1);
%     % clear('h1');
% %     display('Done Uniform');
% 
% 
%     % requests_Uni(1:3,1);
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for  2 class Uniform Distribution')
%     % temp1./temp2
%     % temp2=repmat(requests_Uni,1,length(CacheSize));
%     
% %     hit_rate_Simul_Uni_LeastExpe=R1_hit_count_Uni_LeastExpe./requests_Uni;
%     clear temp1 temp2
%     hit_rate_total_Sim_Uni_LeastExpeModified(kk,:)=sum(R1_hit_count_Uni_LeastExpeModified)/NumberOfRequests;
% 
%     %% SMP Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Uni_SMP=zeros(Producers,length(CacheSize));
% 
%     N_min_3class_SMP=zeros(length(CacheSize),1);
%     N_max_3class_SMP=zeros(length(CacheSize),1);
% 
%     %% 3 class Uniform Distribution SMP (Least Frequently Used)
% 
%     for nn=1:length(Prob_a)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         for cache=1:length(CacheSize)
%             Probability_producers(1,:)=ProducersProbability_Uni(:,cache);
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Uni(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%     % First Column: Producer number
%     % Second Column: t_inst at which it is being fetched from producer
% 
%                 memoryR1_SMP=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f Probability_a=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,Prob_a(nn));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('3 class Uniform Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Uni(ii,cache);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_SMP_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end        
% 
%             R1_hit_count_Uni_SMP(:,cache)=Router1_hit_count;
%         end
%         N_min_3class_SMP(:,nn)=N_min;
%         N_max_3class_SMP(:,nn)=N_max;
%     end
%     toc
% 
%     % delete(h1);
%     % clear('h1');
% %     display('Done Uniform');
% 
%     % requests_Uni(1:3,1);
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for  2 class Uniform Distribution')
%     % temp1./temp2
%     % temp2=repmat(requests_Uni,1,length(CacheSize));
%     
%     % hit_rate_Simul_Uni_SMP=R1_hit_count_Uni_SMP./requests_Uni;
%     clear temp1 temp2
%     hit_rate_total_Sim_Uni_SMP(kk,:)=sum(R1_hit_count_Uni_SMP)/NumberOfRequests;
% 
% 
%     %% RAND Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Uni_RAND=zeros(Producers,length(CacheSize));
% 
%     N_min_3class_RAND=zeros(length(CacheSize),1);
%     N_max_3class_RAND=zeros(length(CacheSize),1);
% 
%     %% 3 class Uniform Distribution RAND (Random)
% 
%     for nn=1:length(Prob_a)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         for cache=1:length(CacheSize)
%             Probability_producers(1,:)=ProducersProbability_Uni(:,cache);
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Uni(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%     % First Column: Producer number
%     % Second Column: t_inst at which it is being fetched from producer
% 
%                 memoryR1_RAND=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f Probability_a=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,Prob_a(nn));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('3 class Uniform Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Uni(ii,cache);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_RAND_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end        
% 
%             R1_hit_count_Uni_RAND(:,cache)=Router1_hit_count;
%         end
%         N_min_3class_RAND(:,nn)=N_min;
%         N_max_3class_RAND(:,nn)=N_max;
%     end
%     toc
% 
%     % delete(h1);
%     % clear('h1');
% %     display('Done Uniform');
% 
%     % requests_Uni(1:3,1);
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for  2 class Uniform Distribution')
%     % temp1./temp2
%     % temp2=repmat(requests_Uni,1,length(CacheSize));
%     % hit_rate_Simul_Uni_RAND=R1_hit_count_Uni_RAND./requests_Uni;
%     clear temp1 temp2
%     hit_rate_total_Sim_Uni_RAND(kk,:)=sum(R1_hit_count_Uni_RAND)/NumberOfRequests;
% 
% 
%     %% LRU Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Uni_LRU=zeros(Producers,length(CacheSize));
% 
%     N_min_3class_LRU=zeros(length(CacheSize),1);
%     N_max_3class_LRU=zeros(length(CacheSize),1);
% 
%     %% 3 class Uniform Distribution LRU (Least Recently Used)
%     for nn=1:length(Prob_a)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         for cache=1:length(CacheSize)
%             Probability_producers(1,:)=ProducersProbability_Uni(:,cache);
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Uni(:,cache);
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LRU have following structure.
%     % First Column: t_stamp
%     % Second Column: Producer number
%     % Third Column: t_inst at which it is being fetched from producer
%                 memoryR1_LRU=zeros(CacheSize(cache),3);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and Probability_a=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,Prob_a(nn));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('3 class Uniform Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Uni(ii,cache);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_LRU_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);%,Sele_1,Sele_2);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end
% 
%             R1_hit_count_Uni_LRU(:,cache)=Router1_hit_count;
%         end
% 
%         N_min_3class_LRU(:,nn)=N_min;
%         N_max_3class_LRU(:,nn)=N_max;
%     end
%     toc
% 
% 
% %     display('Done Uniform');
% 
%     % hit_rate_Simul_Uni_LRU=R1_hit_count_Uni_LRU./requests_Uni;
%     clear temp1 temp2
%     hit_rate_total_Sim_Uni_LRU(kk,:)=sum(R1_hit_count_Uni_LRU)/NumberOfRequests;
% end
% hit_rate_total_Sim_Uni_LeastExpe_Average=mean(hit_rate_total_Sim_Uni_LeastExpe,1);
% hit_rate_total_Sim_Uni_LeastExpeModified_Average=mean(hit_rate_total_Sim_Uni_LeastExpeModified,1);
% hit_rate_total_Sim_Uni_LeastExpe_stdDev=std(hit_rate_total_Sim_Uni_LeastExpe,1,1);
% 
% hit_rate_total_Sim_Uni_LRU_Average=mean(hit_rate_total_Sim_Uni_LRU,1);
% hit_rate_total_Sim_Uni_LRU_stdDev=std(hit_rate_total_Sim_Uni_LRU,1,1);
% 
% hit_rate_total_Sim_Uni_RAND_Average=mean(hit_rate_total_Sim_Uni_RAND,1);
% hit_rate_total_Sim_Uni_RAND_stdDev=std(hit_rate_total_Sim_Uni_RAND,1,1);
% 
% hit_rate_total_Sim_Uni_SMP_Average=mean(hit_rate_total_Sim_Uni_SMP,1);
% hit_rate_total_Sim_Uni_SMP_stdDev=std(hit_rate_total_Sim_Uni_SMP,1,1);
% 
% clear hit_rate_Simul_Uni_LeastExpe hit_rate_Simul_Uni_LRU hit_rate_Simul_Uni_RAND hit_rate_Simul_Uni_SMP
% clear R1_hit_count_Uni_LeastExpe R1_hit_count_Uni_LRU R1_hit_count_Uni_RAND R1_hit_count_Uni_SMP
% clear N_min_3class_LeastExpe N_min_3class_LRU N_min_3class_RAND N_min_3class_SMP N_max_3class_LeastExpe N_max_3class_LRU N_max_3class_RAND N_max_3class_SMP
% clear produ t_inst N_min N_max N_min_temp N_max_temp


%% Therotical Upper Bound 3 class Distribution

% upperBound1_Uni=sum(((ProducersProbability_Uni.^2).*Freshness_Uni)./(ones(Producers,length(CacheSize))+ProducersProbability_Uni.*Freshness_Uni));
% upperBound2_Uni=zeros(1,length(CacheSize));
% for cache=1:length(CacheSize)
%     upperBound2_Uni(1,cache)=sum(ProducersProbability_Uni(1:CacheSize(cache),cache));
% end
% 
% upperBoundMin_Uni=min(upperBound1_Uni,upperBound2_Uni);

%% Result Plot
% myplotNew(xinput,yinputMatrix_avg,yinputMatrix_stdDev,xlabel1,ylabel1,title1,legend1,xlim1,ylim1,saveFigAs,directory)
% myplotNew will take care of 3\sigma error-bar in plot.


% clear temp1;
% temp1=cd;
% xinput(:,1)=CacheSize;
% yinputMatrix_avg=horzcat(hit_rate_total_Sim_Uni_LeastExpe_Average',hit_rate_total_Sim_Uni_LeastExpeModified_Average',hit_rate_total_Sim_Uni_LRU_Average',hit_rate_total_Sim_Uni_RAND_Average',hit_rate_total_Sim_Uni_SMP_Average');
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Uni_LeastExpe_stdDev',hit_rate_total_Sim_Uni_LRU_stdDev',hit_rate_total_Sim_Uni_RAND_stdDev',hit_rate_total_Sim_Uni_SMP_stdDev');
% xlabel1=sprintf('Cache size');
% ylabel1=sprintf('Cache hit ratio');
% % title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_F_b_400';
% legend1={sprintf('LU'),sprintf('LU(modified)'),sprintf('LRU'),sprintf('RAND'),sprintf('SMP')};
% saveFigAs=sprintf('Hit_rate_Vs_Cache_Size_policies_Uniform_%d',Factor*10);
% xlim1=[10 40];
% ylim1=[0 0.45];
% myplotNew(xinput,yinputMatrix_avg,yinputMatrix_stdDev,xlabel1,ylabel1,legend1,xlim1,ylim1,saveFigAs,directory);
% cd(temp1);

% clear yinputMatrix_avg yinputMatrix_stdDev
% yinputMatrix_avg=horzcat(hit_rate_total_Sim_Uni_LeastExpe_Average',hit_rate_total_Sim_Uni_LRU_Average',hit_rate_total_Sim_Uni_RAND_Average',hit_rate_total_Sim_Uni_SMP_Average');
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Uni_LeastExpe_stdDev',hit_rate_total_Sim_Uni_LRU_stdDev',hit_rate_total_Sim_Uni_RAND_stdDev',hit_rate_total_Sim_Uni_SMP_stdDev');
% [v,I]=max(yinputMatrix_stdDev);
% display('Standard Deviation for 3-class Model for CacheSize');
% (v./[yinputMatrix_avg(I(1),1) yinputMatrix_avg(I(2),2) yinputMatrix_avg(I(3),3) yinputMatrix_avg(I(4),4)])*100
% clear yinputMatrix_avg yinputMatrix_stdDev

%% always change the dataname for saving. Keep it simple and discriptive.
% temp1=cd;
% cd('D:\IoT\IoT\31Jan\LeastExpected\NCC_Results\New')
% save('cmp_cache_policies_3Class');


%% ###################################### Zipf Distribution with parameter beta #######################################
nn=1:Producers;
ProducersProbability_Zipf(:,1)=(nn.^-beta)/sum((nn.^-beta));
% ProducersProbability_ZipfModified=zeros(length(CacheSize),Producers);
% producersRequest_Zipf(:,1)=datasample(1:Producers,NumberOfRequests,'Weights',ProducersProbability_Zipf');
% temp1=repmat(ProducersProbability_Zipf',1,length(CacheSize));
% Freshness_Zipf=Freshness_const./temp1;

%% Linear Freshness
% Freshness_Zipf(:,1)=nn+1;%LinearFreshness

%% Uniform Freshness
Freshness=1000;
Freshness_Zipf(:,1)=Freshness*ones(Producers,1);%UniformFreshness

%% Uniform 3 Class Freshness
% Freshness_Zipf(:,1)=zeros(Producers,length(CacheSize));
% for ii=1:length(CacheSize)
%     N_a=CacheSize(ii);
%     N_b=CacheSize(ii);
%     N_c=Producers-N_a-N_b;
%     Freshness_Zipf(:,ii)=[repmat(F_a,N_a,1);repmat(F_b,N_b,1);repmat(F_c,N_c,1)];
%     RemainingProbability=(1-sum(ProducersProbability_Zipf(1,1:RouterStorageCapacity(ii))))/(Producers-RouterStorageCapacity(ii));
%     ProducersProbability_ZipfModified(ii,:)=[ProducersProbability_Zipf(1,1:RouterStorageCapacity(ii)) ones(1,Producers-RouterStorageCapacity(ii))*RemainingProbability];
% end

% display(sprintf('sum(ProducersProbability_ZipfModified)=%f',sum(ProducersProbability_ZipfModified)));

clear temp1;

%% Exponential inter-arrival time
time=cumsum(exprnd(1,NumberOfRequests,1));
producersRequest_Zipf(:,1)=datasample(1:Producers,NumberOfRequests,'Weights',ProducersProbability_Zipf');

requests_Zipf=zeros(Producers,1);
for ii=1:NumberOfRequests
    requests_Zipf(producersRequest_Zipf(ii,1),:)=requests_Zipf(producersRequest_Zipf(ii,1),:)+1;
end


%% Least Expected Variables :::::::::::::::::::::::::::::::::::::::::::::::
R1_hit_count_Zipf_LeastExpe=zeros(Producers,length(CacheSize_X(1,:)),length(DataSize_D));

N_min_Zipf_LeastExpe=zeros(length(CacheSize_X(1,:)),length(DataSize_D));
N_max_Zipf_LeastExpe=zeros(length(CacheSize_X(1,:)),length(DataSize_D));



for dd=1:length(DataSize_D)
    display(sprintf('DataSize=%d',DataSize_D(dd)));
    N_min=zeros(length(CacheSize_X(1,:)),1);
    N_max=zeros(length(CacheSize_X(1,:)),1);

    %% Zipf distribution with parameter beta Least Expected
    for xx=1:length(CacheSize_X(dd,:))
        RemainingProbability=(1-sum(ProducersProbability_Zipf(1:CacheSize_X(dd,xx),1)))/(Producers-CacheSize_X(dd,xx));
        Probability_producers(:,1)=[ProducersProbability_Zipf(1:CacheSize_X(dd,xx),1); RemainingProbability*ones(Producers-CacheSize_X(dd,xx),1)];
        display(sprintf('CacheSize_X=%d',CacheSize_X(dd,xx)));

%         for cache=1:length(CacheSize)
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
            Freshness_requirment=Freshness_Zipf(:,1);

%             for jj=1:length(ProbForSavingVectorR1)
                ProbForSavingR1=ProbForSavingVectorR1;
        % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
        % First Column: latest time_instant when data was being used under
        % condition it was fresh.
        % Second Column: Producer number
        % Third Column: time_stamp at ehich data for corresponding producer was
        % being fetched and stored.
                memoryR1_LeastExpe=zeros(floor((CacheSize_C(dd)-CacheSize_X(dd,xx))/DataSize_D(dd)),2);

                Router1_hit_count=zeros(Producers,1);

                count1=0;
                count2=0;

                message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
                                ,CacheSize_C(dd),ProbForSavingR1,beta);
                h=msgbox(message);
                clear message

                N_min_temp=0;
                N_max_temp=0;
                display(sprintf('memoryR1_Size=%d',length(memoryR1_LeastExpe)))
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
                N_min(xx,1)=N_min_temp; % jj-> row number; kk-> column number
                N_max(xx,1)=N_max_temp;

                delete(h);
                clear('h');
%             end

            R1_hit_count_Zipf_LeastExpe(:,xx,dd)=Router1_hit_count;
%         end
        
    end
    
    N_min_Zipf_LeastExpe(:,dd)=N_min;
    N_max_Zipf_LeastExpe(:,dd)=N_max;
    toc
%     display('Done Zipf');

    
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
hit_rate_total_Sim_Zipf_LeastExpe(:,:)=sum(R1_hit_count_Zipf_LeastExpe)/NumberOfRequests; % Columns represents hit rate for different cache size

%     %% Least ExpectedModified Variables :::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Zipf_LeastExpeModified=zeros(Producers,length(CacheSize));
% 
%     N_min_Zipf_LeastExpeModified=zeros(length(CacheSize),1);
%     N_max_Zipf_LeastExpeModified=zeros(length(CacheSize),1);
% 
%     %% Zipf distribution with parameter beta Least ExpectedModified
%     for xx=1:length(beta)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
% 
%         for cache=1:length(CacheSize)
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Zipf(:,cache);
%             Probability_producers(1,:)=ProducersProbability_ZipfModified(xx,:);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%         % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%         % First Column: latest time_instant when data was being used under
%         % condition it was fresh.
%         % Second Column: Producer number
%         % Third Column: time_stamp at ehich data for corresponding producer was
%         % being fetched and stored.
%                 memoryR1_LeastExpe=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,beta(xx));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('Zipf Distribution');
%                 for ii=1:length(time)
%         %                 display(t_inst);
%                     produ=producersRequest_Zipf(ii,xx);
%                     t_inst=time(ii);
%         %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_LeastExpe_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp; % jj-> row number; kk-> column number
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end
% 
%             R1_hit_count_Zipf_LeastExpeModified(:,cache)=Router1_hit_count;
%         end
%         N_min_Zipf_LeastExpeModified(:,xx)=N_min;
%         N_max_Zipf_LeastExpeModified(:,xx)=N_max;
%     end
%     toc
% %     display('Done Zipf');
% 
% %     requests_Zipf=zeros(Producers,length(CacheSize));
% %     for ii=1:NumberOfRequests
% %         requests_Zipf(producersRequest_Zipf(ii,1),:)=requests_Zipf(producersRequest_Zipf(ii,1),:)+1;
% %     end
% 
% 
%     % requests_Uni(1:3,1)
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for Zipf Distribution')
%     % temp1./temp2
%     % R1_hit_count_Zipf./requests_Zipf
%     % temp2=repmat(requests_Zipf,1,1,length(CacheSize));
% 
% %     hit_rate_Simul_Zipf_LeastExpe=R1_hit_count_Zipf_LeastExpe./requests_Zipf;
% %     clear temp1 temp2
%     hit_rate_total_Sim_Zipf_LeastExpeModified(dd,:)=sum(R1_hit_count_Zipf_LeastExpeModified)/NumberOfRequests;
% 
%     %% SMP Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Zipf_SMP=zeros(Producers,length(CacheSize));
% 
%     N_min_Zipf_SMP=zeros(length(CacheSize),1);
%     N_max_Zipf_SMP=zeros(length(CacheSize),1);
%     
%     %% Zipf distribution with parameter beta SMP (Least Frequently Used)
%     
%     for xx=1:length(beta)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         Probability_producers(1,:)=ProducersProbability_Zipf(xx,:);
% 
%         for cache=1:length(CacheSize)
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Zipf(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%         % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%         % First Column: latest time_instant when data was being used under
%         % condition it was fresh.
%         % Second Column: Producer number
%         % Third Column: time_stamp at ehich data for corresponding producer was
%         % being fetched and stored.
%                 memoryR1_SMP=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,beta(xx));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('Zipf Distribution');
%                 for ii=1:length(time)
%         %                 display(t_inst);
%                     produ=producersRequest_Zipf(ii,xx);
%                     t_inst=time(ii);
%         %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_SMP_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp; % jj-> row number; kk-> column number
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end
% 
%             R1_hit_count_Zipf_SMP(:,cache)=Router1_hit_count;
%         end
%         N_min_Zipf_SMP(:,xx)=N_min;
%         N_max_Zipf_SMP(:,xx)=N_max;
%     end
%     toc
% %     display('Done Zipf');
% 
% 
%     % requests_Uni(1:3,1)
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for Zipf Distribution')
%     % temp1./temp2
%     % R1_hit_count_Zipf./requests_Zipf
%     % temp2=repmat(requests_Zipf,1,1,length(CacheSize));
% 
% %     hit_rate_Simul_Zipf_SMP=R1_hit_count_Zipf_SMP./requests_Zipf;
% %     clear temp1 temp2
%     hit_rate_total_Sim_Zipf_SMP(dd,:)=sum(R1_hit_count_Zipf_SMP)/NumberOfRequests;
% 
%     %% RAND Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Zipf_RAND=zeros(Producers,length(CacheSize));
% 
%     N_min_Zipf_RAND=zeros(length(CacheSize),1);
%     N_max_Zipf_RAND=zeros(length(CacheSize),1);
%     
%     %% Zipf distribution with parameter beta RAND (RANDOM)
%     for xx=1:length(beta)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         Probability_producers(1,:)=ProducersProbability_Zipf(xx,:);
% 
%         for cache=1:length(CacheSize)
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Zipf(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%         % memoryR1_LeastExpe and memoryR2_LeastExpe have following structure.
%         % First Column: latest time_instant when data was being used under
%         % condition it was fresh.
%         % Second Column: Producer number
%         % Third Column: time_stamp at ehich data for corresponding producer was
%         % being fetched and stored.
%                 memoryR1_RAND=zeros(CacheSize(cache),2);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 count1=0;
%                 count2=0;
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,beta(xx));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('Zipf Distribution');
%                 for ii=1:length(time)
%         %                 display(t_inst);
%                     produ=producersRequest_Zipf(ii,xx);
%                     t_inst=time(ii);
%         %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_RAND_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp; % jj-> row number; kk-> column number
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end
% 
%             R1_hit_count_Zipf_RAND(:,cache)=Router1_hit_count;
%         end
%         N_min_Zipf_RAND(:,xx)=N_min;
%         N_max_Zipf_RAND(:,xx)=N_max;
%     end
%     toc
% %     display('Done Zipf');
% 
% 
%     % requests_Uni(1:3,1)
%     % R1_hit_count_Uni(1:3,1)
%     % temp1(:,1)=R1_hit_count(1:3,1);
%     % temp2(:,1)=requests(1:3,1);
%     % display('Hit rate Simulation for Zipf Distribution')
%     % temp1./temp2
%     % R1_hit_count_Zipf./requests_Zipf
%     % temp2=repmat(requests_Zipf,1,1,length(CacheSize));
% 
% %     hit_rate_Simul_Zipf_RAND=R1_hit_count_Zipf_RAND./requests_Zipf;
% %     clear temp1 temp2
%     hit_rate_total_Sim_Zipf_RAND(dd,:)=sum(R1_hit_count_Zipf_RAND)/NumberOfRequests;
% 
%     %% LRU Variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%     R1_hit_count_Zipf_LRU=zeros(Producers,length(CacheSize));
% 
%     N_min_Zipf_LRU=zeros(length(CacheSize),1);
%     N_max_Zipf_LRU=zeros(length(CacheSize),1);
% 
%     %% Zipf distribution with parameter beta LRU (Least Recently Used)
%     for xx=1:length(beta)
%         N_min=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         N_max=zeros(length(ProbForSavingVectorR1),length(CacheSize));
%         Probability_producers(1,:)=ProducersProbability_Zipf(xx,:);
% 
%         for cache=1:length(CacheSize)
%             N_a=CacheSize(cache);
%             N_b=CacheSize(cache);
%             N_c=Producers-N_a-N_b;
%             Pop_producers=[N_a N_b N_c];
%             Freshness_requirment=Freshness_Zipf(:,cache);
% 
%             for jj=1:length(ProbForSavingVectorR1)
%                 ProbForSavingR1=ProbForSavingVectorR1(jj);
%     % memoryR1_LRU and memoryR2_LRU have following structure.
%     % First Column: latest time_instant when data was being used under
%     % condition it was fresh.
%     % Second Column: Producer number
%     % Third Column: time_stamp at which data for corresponding producer was
%     % being fetched and stored.
%                 memoryR1_LRU=zeros(CacheSize(cache),3);
% 
%                 Router1_hit_count=zeros(Producers,1);
% 
%                 message=sprintf('Running for Cache Size=%d and ProbForSavingR1=%f and beta=%f'...
%                                 ,CacheSize(cache),ProbForSavingR1,beta(xx));
%                 h=msgbox(message);
%                 clear message
% 
%                 N_min_temp=0;
%                 N_max_temp=0;
% %                 display('Zipf Distribution');
%                 for ii=1:length(time)
%     %                 display(t_inst);
%                     produ=producersRequest_Zipf(ii,xx);
%                     t_inst=time(ii);
%     %                 Frshness=Freshness(t_inst,1);
%                     [N_min_temp,N_max_temp]=router1_LRU_plain_3class(produ,t_inst,...
%                                                                 ProbForSavingR1,N_min_temp,N_max_temp);%,Sele_1,Sele_2);
% 
%                 end
%                 N_min(jj,cache)=N_min_temp;
%                 N_max(jj,cache)=N_max_temp;
% 
%                 delete(h);
%                 clear('h');
%             end
% 
%             R1_hit_count_Zipf_LRU(:,cache)=Router1_hit_count;
%         end
%         N_min_Zipf_LRU(:,xx)=N_min;
%         N_max_Zipf_LRU(:,xx)=N_max;
%     end
%     toc
% %     display('Done Zipf');
% 
%     % temp2=repmat(requests_Zipf,1,1,length(CacheSize));
%     
% %     hit_rate_Simul_Zipf_LRU=R1_hit_count_Zipf_LRU./requests_Zipf;
% %     clear temp1 temp2
%     hit_rate_total_Sim_Zipf_LRU(dd,:)=sum(R1_hit_count_Zipf_LRU)/NumberOfRequests;
% end
% hit_rate_total_Sim_Zipf_LeastExpe_Average=mean(hit_rate_total_Sim_Zipf_LeastExpe,1);
% hit_rate_total_Sim_Zipf_LeastExpeModified_Average=mean(hit_rate_total_Sim_Zipf_LeastExpeModified,1);
% hit_rate_total_Sim_Zipf_LeastExpe_stdDev=std(hit_rate_total_Sim_Zipf_LeastExpe,1,1);

% hit_rate_total_Sim_Zipf_LRU_Average=mean(hit_rate_total_Sim_Zipf_LRU,1);
% hit_rate_total_Sim_Zipf_LRU_stdDev=std(hit_rate_total_Sim_Zipf_LRU,1,1);
% 
% hit_rate_total_Sim_Zipf_RAND_Average=mean(hit_rate_total_Sim_Zipf_RAND,1);
% hit_rate_total_Sim_Zipf_RAND_stdDev=std(hit_rate_total_Sim_Zipf_RAND,1,1);
% 
% hit_rate_total_Sim_Zipf_SMP_Average=mean(hit_rate_total_Sim_Zipf_SMP,1);
% hit_rate_total_Sim_Zipf_SMP_stdDev=std(hit_rate_total_Sim_Zipf_SMP,1,1);

clear hit_rate_Simul_Zipf_LeastExpe hit_rate_Simul_Zipf_LRU hit_rate_Simul_Zipf_RAND hit_rate_Simul_Zipf_SMP
clear R1_hit_count_Zipf_LRU R1_hit_count_Zipf_RAND R1_hit_count_Zipf_SMP
clear N_min_Zipf_LeastExpe N_min_Zipf_LRU N_min_Zipf_RAND N_min_Zipf_SMP N_max_Zipf_LeastExpe N_max_Zipf_LRU N_max_Zipf_RAND N_max_Zipf_SMP
clear produ t_inst N_min N_max N_min_temp N_max_temp

%% Therotical Upper Bound Zipf Distribution

% clear temp1;
% temp1=repmat(ProducersProbability_Zipf',1,length(CacheSize));
% upperBound1_Zipf=sum(((temp1.^2).*Freshness_Zipf)./(ones(Producers,length(CacheSize))+temp1.*Freshness_Zipf));
% 
% upperBound2_Zipf=zeros(1,length(CacheSize));
% for cache=1:length(CacheSize)
%     upperBound2_Zipf(1,cache)=sum(temp1(1:CacheSize(cache),cache));
% end
% 
% upperBoundMin_Zipf=min(upperBound1_Zipf,upperBound2_Zipf);
% clear temp1

%% Result Plot
% myplotNew(xinput,yinputMatrix_avg,yinputMatrix_stdDev,xlabel1,ylabel1,title1,legend1,xlim1,ylim1,saveFigAs,directory)
% myplotNew will take care of 3\sigma error-bar in plot.
clear temp1;
temp1=cd;
xinput(:,1)=CacheSize_X(1,:);
yinputMatrix_avg=hit_rate_total_Sim_Zipf_LeastExpe;
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Zipf_LeastExpe_stdDev',hit_rate_total_Sim_Zipf_LRU_stdDev',hit_rate_total_Sim_Zipf_RAND_stdDev',hit_rate_total_Sim_Zipf_SMP_stdDev');
xlabel1=sprintf('Normalized Cache size (X/D)');
ylabel1=sprintf('Cache hit ratio (LU)');
% title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness';
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_VariableCache100timesDSize';
legend=cell(1,length(DataSize_D));
for ii=1:length(DataSize_D)
    legend1{ii}=sprintf('d=%d',DataSize_D(ii));
end
saveFigAs=sprintf('Hit_rateLU_Vs_Cache_Size_X_Zipf_%d_Cis100D_F%d',beta*10,Freshness);
% xlim1=[10 40];
% ylim1=[0 1];
title1={sprintf('beta=%0.2f;Total N=%d;C=%d;F=%d',beta,Producers,CacheSize_C,Freshness)};
myplotHitRateVsX(xinput,yinputMatrix_avg,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);

% clear yinputMatrix_avg yinputMatrix_stdDev
% yinputMatrix_avg=horzcat(hit_rate_total_Sim_Zipf_LeastExpe_Average',hit_rate_total_Sim_Zipf_LRU_Average',hit_rate_total_Sim_Zipf_RAND_Average',hit_rate_total_Sim_Zipf_SMP_Average');
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Zipf_LeastExpe_stdDev',hit_rate_total_Sim_Zipf_LRU_stdDev',hit_rate_total_Sim_Zipf_RAND_stdDev',hit_rate_total_Sim_Zipf_SMP_stdDev');
% [v, I]=max(yinputMatrix_stdDev);
% display('Standard Deviation for Zipf for CacheSize');
% (v./[yinputMatrix_avg(I(1),1) yinputMatrix_avg(I(2),2) yinputMatrix_avg(I(3),3) yinputMatrix_avg(I(4),4)])*100
% clear yinputMatrix_avg yinputMatrix_stdDev

%% always change the dataname for saving. Keep it simple and discriptive.
% temp1=cd;
% cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness')
cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_VariableCache100timesDSize')
save(sprintf('cmp_cache_LU_Vs_X_Zipf_%d_C%d_F%d',beta*10,CacheSize_C,Freshness));
toc

%% Result Plot
% myplot(xinput,yinputMatrix,xlabel1,ylabel1,title1,legend1,saveFigAs)
% clear temp1;
% temp1=cd;
% xinput(:,1)=CacheSize;
% yinputMatrix=horzcat(upperBoundMin_Uni',avg_h_LU',hit_rate_total_Sim_Uni_LRU',hit_rate_total_Sim_Uni_RAND',hit_rate_total_Sim_Uni_SMP');
% xlabel1=sprintf('Cache size');
% ylabel1=sprintf('Hit rate');
% % title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\New_Results24092017';
% legend1={sprintf('UB'),sprintf('LU'),sprintf('LRU'),sprintf('RAND'),sprintf('SMP')};
% saveFigAs=sprintf('Hit_rate_Vs_Cache_Size_policies_Uniform');
% myplot(xinput,yinputMatrix,xlabel1,ylabel1,legend1,saveFigAs,directory);
% cd(temp1);
% 
% %%
% yinputMatrix=horzcat(upperBoundMin_Zipf',hit_rate_total_Sim_Zipf_LeastExpe',hit_rate_total_Sim_Zipf_LRU',hit_rate_total_Sim_Zipf_RAND',hit_rate_total_Sim_Zipf_SMP');
% xlabel1=sprintf('Cache size');
% ylabel1=sprintf('Hit rate');
% % title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\New_Results24092017';
% legend1={sprintf('UB'),sprintf('LU'),sprintf('LRU'),sprintf('RAND'),sprintf('SMP')};
% saveFigAs=sprintf('Hit_rate_Vs_Cache_Size_policies_Zipf');
% myplot(xinput,yinputMatrix,xlabel1,ylabel1,legend1,saveFigAs,directory);
% %% always change the dataname for saving. Keep it simple and discriptive.
% % temp1=cd;
% cd('D:\IoT\IoT\31Jan\LeastExpected\New_Results24092017\Data')
% save('cmp_cache_policies_3Class_Sqrt_Freshness');


%%
% clear avg_h_LU var_h_LU
% h_LU=sum()