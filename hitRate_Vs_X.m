clear all
clc
 CacheSize_C=400;
 DataSize_D=1:5;
 beta=0.5;
 NumberOfProducers_N=400;
 nn=1:NumberOfProducers_N;
 const=20;
 F_a=5;
 F_b=const*F_a;
 F_c=F_a;
 N_a=100;%CacheSize_C;
 N_b=100;%CacheSize_C;
 N_c=NumberOfProducers_N-N_a-N_b;
 parameter=10;
 Freshness=nn'+parameter;%[repmat(F_a,N_a,1);repmat(F_b,N_b,1);repmat(F_c,N_c,1)];
 ProducersProbability(:,1)=(nn.^(-beta))/sum(nn.^(-beta));
 CacheForPopularity_X=CacheSize_C:-1:1;
 data=0;
%  Freshness_cap=zeros(NumberOfProducers_N,length(DataSize_D));
 LowerBound_LeastExpected=zeros(CacheSize_C,length(DataSize_D));
 
 for dd=1:length(DataSize_D)
     data=0;
     for pp=CacheSize_C:-1:1
         temp=zeros(NumberOfProducers_N,3);
         temp(1:pp,1)=ProducersProbability(1:pp,1);
         RemainingProbability=(1-sum(ProducersProbability(1:pp,1)))/(NumberOfProducers_N-pp);
         temp(pp+1:NumberOfProducers_N,1)=ones(NumberOfProducers_N-pp,1)*RemainingProbability;
         temp(:,2)=Freshness;
         temp(:,3)=temp(:,1).*temp(:,2);
         
         [~,indices]=sort(temp(:,3),'descend');
         temp=temp(indices,:);
         
%          display(sprintf('Probability=%f',sum(temp(:,1))));
         
         if mod(CacheSize_C-pp,DataSize_D(dd))==0
             data=data+1;
             display('Here2')
         end

         if data==0
             LowerBound_LeastExpected(CacheSize_C-pp+1,dd)=0;
             display('Here1')
             continue;
         end
         clear temp1 temp2
         
         Freshness_cap(:,1)=temp(:,2)-(temp(data,3)./temp(:,1));
         temp1(:,1)=temp(:,1).*Freshness_cap;
         LowerBound_LeastExpected(CacheSize_C-pp+1,dd)=sum((temp(1:data-1,1).*temp1(1:data-1,1))./(1+temp1(1:data-1,1)));
     
     end
 end

 %%
 temp1=cd;
xinput(:,1)=CacheForPopularity_X;
yinputMatrix=LowerBound_LeastExpected;
% yinputMatrix_stdDev=horzcat(hit_rate_total_Sim_Uni_LeastExpe_stdDev',hit_rate_total_Sim_Uni_LRU_stdDev',hit_rate_total_Sim_Uni_RAND_stdDev',hit_rate_total_Sim_Uni_SMP_stdDev');
xlabel1=sprintf('Cache to store Popularity (x)');
ylabel1=sprintf('Cache hit ratio (lower bound)');
% title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_hitRate_Vs_X\LinearFreshness';
legend1={sprintf('d=1'),sprintf('d=2'),sprintf('d=3'),sprintf('d=4'),sprintf('d=5')};
saveFigAs=sprintf('Hit_rate_Lower_Bound_Vs_Cache_to_Store_Popularity_Zipf_C%d_F_a%d_parameter_%2.0f',CacheSize_C,F_a,parameter);
xlim1=[10 40];
ylim1=[0 0.45];
title1={sprintf('beta=%0.2f;Total N=%d;C=%d;F_{i}=i+%d',beta,NumberOfProducers_N,CacheSize_C,parameter)};
myplotHitRateVsX(xinput,yinputMatrix,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);

cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_hitRate_Vs_X');
save(sprintf('hitRate_Vs_X_C%d',CacheSize_C));