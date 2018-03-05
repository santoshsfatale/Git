clear all
clc
beta=[0.5 0.8 1.1 1.4 1.7];
d=1:5:50;
CacheSize_C=100;
X=0:5:CacheSize_C;
Freshness=1000;
Producers=1000;
hit_rate_max=zeros(length(beta),length(d));
max_hit_at_X=zeros(length(beta),length(d));
temp1=cd;
for ii=1:length(beta)
    cd('D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_100')
    str1=sprintf('cmp_cache_LU_Vs_X_Zipf_%d_C100_F1000.mat',beta(ii)*10);
    load(str1,'hit_rate_total_Sim_Zipf_LeastExpe');
    [C, I]=max(hit_rate_total_Sim_Zipf_LeastExpe);
    hit_rate_max(ii,:)=C;
    max_hit_at_X(ii,:)=X(I);
    I
    C
%     hit_rate_total_Sim_Zipf_LeastExpe(I)
    clear hit_rate_total_Sim_Zipf_LeastExpe
end
cd(temp1);
xinput=beta;
yinput=max_hit_at_X;
xlabel1=sprintf('\\beta');
ylabel1=sprintf('Cache Size(X)');
% title1=sprintf('Hit rate (p_{hit}) Vs Cache size');
% directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness';
directory='D:\IoT\IoT\31Jan\LeastExpected\CheckCodes\Results_HitRateLU_Vs_X\UniformFreshness\new0_100';
legend1=cell(1,length(d));
for ii=1:length(d)
    legend1{ii}=sprintf('d=%d',d(ii));
end
saveFigAs=sprintf('Hit_rateLU_Vs_beta_C%d_F%d',CacheSize_C,Freshness);
xlim1=[min(beta) max(beta)];
ylim1=[min(min(max_hit_at_X))-1 max(max(max_hit_at_X))+1];
title1={sprintf('Total N=%d;C=%d;F=%d',Producers,CacheSize_C,Freshness)};
myplotHitRateVsX(xinput,yinput,xlabel1,ylabel1,legend1,xlim1,ylim1,title1,saveFigAs,directory);
cd(temp1);