function [N_min,N_max]=router1_SMP_3class(produ,t_inst,ProbForSavingR1,N_min,N_max)%,Sele_1,Sele_2)
global memoryR1_SMP Pop_producers  Freshness_requirment Router1_hit_count %count1%memoryR1_LRU memoryR1_Random;

%% Least Frequently Used (LFU) Policy
% Remove the least popular data from memory.
% Algorithm is as follows:
% if (cache empty)
%     store the content
% else
%     remove data of least popular content
% end
% 
% 
% 
% C_min will get increamented if data is found in memoryR1 else C_inter 
% will get increamented, indicates that data is not available and need 
% retrieval from memoryR2.

% Data of most length(Cache) producers will be always in memory, even if it
% is stale. Thus index2 can have 0 value indicating cache is full and
% producer is not from most popular producer OR count1 value indicating
% cache is having some empty space to store the producer OR location of
% producer which is not enough popular to be in cache.

% Variable discription
% memoryR1_SMP: Cache for storing data
%           column1: Producers; column2: t_stamp
% count1: Temprary variable for checking empty cache
%         if count1>length(cache) => Not empty
% Router1_hit_count: Global variable to count Router1 hit count
% FreshnessMin/FreshnessMax: Global varaibel for freshness
% produ: Producer number requested.
% t_inst: time instant of request
% ProbForSavingR1: Proabbaility for saving at Router1
% ProbForSavingR2: Proabbaility for saving at Router2
% Pop_producers: Number of popular producers
% N_min,N_inter,N_max: Number of requests served by Router1, Router2 and
%                      Producers

%################ TO REMOVE EXPIRED/STALE PRODUCER CONTENT ######################
% To remove expired producer content
% t_inst
% memoryR1_SMP
% indices1=find(memoryR1_SMP(:,1)>3); % Identifying less popular users
% indices2=find(t_inst - memoryR1_SMP(indices1,2)>FreshnessMax);
% memoryR1_SMP(indices1(indices2),:)=0;
% clear indices1 indices2
% 
% indices1=find(memoryR1_SMP(:,1)<4); % Identifying more popular users
% indices2=find(t_inst - memoryR1_SMP(indices1,2)>FreshnessMin);
% memoryR1_SMP(indices1(indices2),:)=0;
% clear indices1 indices2
% memoryR1_SMP

%########################### END REMOVING #################################



index=find(memoryR1_SMP(:,1) ==produ,1,'first'); % Check for the producer

%         index
if ~isempty(index) % True implies producer is present
%     temp2=memoryR1_SMP(index,2);
%     memoryR1_LRU(index,1)=t_inst;
%     Router1_hit_count(produ)=Router1_hit_count(produ)+1;
%     temp1=sum(produ>cumsum([0 Pop_producers])); % gives type of producer: Bucket1/Bucket2/Bucket3
    if (t_inst-memoryR1_SMP(index,2))<=Freshness_requirment(produ)
%         display('Producer present with data at R1')
        N_min=N_min+1;
        Router1_hit_count(produ)=Router1_hit_count(produ)+1;
    else % MISS HAPPENED
%         display('Producer present without data at R1')
        N_max=N_max+1;
        memoryR1_SMP(index,2)=t_inst;
    end
else % Case when producer is not present in CacheR1
%     display('producer not present at R1')
% Check for empty location and index of least frequently used producer       
%             memory(:,1)=memoryR1_SMP(:,1);
%             Freshness=Frequency_R1;
%     count1=count1+1;
    N_max=N_max+1;
    ProbForSaving1=0;
%     if count1>length(memoryR1_SMP)
    if produ > length(memoryR1_SMP)
        index2=0;
    else
        index2=produ; % gives location of first element greather than produ.
    end
%     else
%         index2=count1;
%     end
%             [ProbForSaving1,index2]=FindLRU(memoryR1_LRU(:,1),ProbForSavingR1);

% Genrate choice variable according to probabilty ProbForSaving
    if rand()<max(ProbForSavingR1,ProbForSaving1)
        choice=1;             
    else
        choice=0;
    end
    t_stamp=t_inst;
%             display('Router1 Choice');
%             choice

    if choice==1 && index2~=0
        memoryR1_SMP(index2,:)=[produ,t_stamp];
    end
end
%         memoryR1_SMP
%         Freshness_R1

% memoryR1_SMP(size(memoryR1_SMP,1),:)=[1,produ,Frshness];
%         [~,d2]=sort(memoryR1_SMP(:,1),'descend');
%         memoryR1_SMP=memoryR1_SMP(d2,:);

end