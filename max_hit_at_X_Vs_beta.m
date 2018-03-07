clear all
clc
beta=[0.5 0.8 1.1 1.4 1.7];
DataSize_D=[1 10 20];
CacheSize_C=100*DataSize_D;
CacheSize_X=zeros(length(DataSize_D),length(0:5*max(DataSize_D):max(CacheSize_C)));
for ii=1:length(DataSize_D)
    clear temp1
    temp1=0:5*DataSize_D(ii):CacheSize_C(ii);
    CacheSize_X(ii,1:length(temp1))=temp1;
end
Freshness=1000;
Producers=1000;
hit_rate_max=zeros(length(beta),length(DataSize_D));
max_hit_at_X=zeros(length(beta),length(DataSize_D));
temp1=cd;
for ii=1:length(beta)
    cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_VariableCache100timesDSize')
    str1=sprintf('cmp_cache_LU_Vs_X_Zipf_%d_Cis100D_F1000.mat',beta(ii)*10);
    load(str1,'hit_rate_total_Sim_Zipf_LeastExpe');
    [C, I]=max(hit_rate_total_Sim_Zipf_LeastExpe);
    for dd=1:length(DataSize_D)
        hit_rate_max(ii,dd)=C(dd);
        max_hit_at_X(ii,dd)=CacheSize_X(dd,I(dd))/CacheSize_C(dd);
    end
    I
    C
%     hit_rate_total_Sim_Zipf_LeastExpe(I)
    clear hit_rate_total_Sim_Zipf_LeastExpe
end
cd(temp1);
xinput=beta;
yinput=max_hit_at_X;
xlabel1=sprintf('\\beta');
ylabel1=sprintf('Normalised Cache Size(X/C)');
% title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness';
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_VariableCache100timesDSize';
legend1=cell(1,length(DataSize_D));
for ii=1:length(DataSize_D)
    legend1{ii}=sprintf('d=%d',DataSize_D(ii));
end
saveFigAs=sprintf('Hit_rateLU_Vs_beta_Cis100D_F%d',Freshness);
xlim1=[min(beta) max(beta)];
ylim1=[min(min(max_hit_at_X)) max(max(max_hit_at_X))];
title1={sprintf('Total N=%d;C=100\\times D;F=%d',Producers,Freshness)};
myplotHitRateVsX(xinput,yinput,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);