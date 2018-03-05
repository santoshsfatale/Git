function [N_min,N_max]=router1_RAND_plain_3class(produ,t_inst,ProbForSavingR1,N_min,N_max)%,Sele_1,Sele_2)
global memoryR1_RAND Router1_hit_count Pop_producers Freshness_requirment count1%memoryR1_LRU memoryR1_Random;

%% RANDOM (RAND) Policy

% Remove data randomly uniformaly. Use followings conditions for
% implementation.

% if cache empty
%     store the data
% else
%     if data exist without freshness
%         replace data with new one (CONSIDER IT AS MISS)
%     else
%         Choose randomly any data and replace that data with the new one.
%     end
% end

% N_min will get increamented if data is found in memoryR1 else C_inter 
% will get increamented, indicates that data is not available and need 
% retrieval from memoryR2.

% Variable discription
% memoryR1_RAND: Cache for storing data
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
% memoryR1_LRU
% indices1=find(memoryR1_LRU(:,2)>Pop_producers); % Identifying less popular users
% indices2=find(t_inst - memoryR1_LRU(indices1,3)>FreshnessMax); % Identifying stale data
% memoryR1_LRU(indices1(indices2),:)=0;
% clear indices1 indices2
% 
% indices1=find(memoryR1_LRU(:,2)<Pop_producers+1); % Identifying more popular users
% indices2=find(t_inst - memoryR1_LRU(indices1,3)>FreshnessMin); % Identifying stale data
% memoryR1_LRU(indices1(indices2),:)=0;
% clear indices1 indices2
% % memoryR1_LFU
% [~,indices1]=sort(memoryR1_LRU(:,1),'descend');
% memoryR1_LRU=memoryR1_LRU(indices1,:);
% memoryR1_LRU
%########################### END REMOVING #################################


% temp1(:,1)=memoryR1_LFU(:,1); % Considering Producers Only
index=find(memoryR1_RAND(:,1) ==produ,1,'first'); % Check for the producer
% Frequency_R1(produ,1)=Frequency_R1(produ,1)+1; % Increament the Frequency for Producer
%         index
    if ~isempty(index) % True implies producer is present
%             temp2=memoryR1_LFU(index,2);
%             memoryR1_LRU(index,1)=t_inst;
%             Router1_hit_count(produ)=Router1_hit_count(produ)+1;
%         temp1=sum(produ>cumsum([0 Pop_producers])); % gives type of producer: Bucket1/Bucket2/Bucket3
        if (t_inst-memoryR1_RAND(index,2))<=Freshness_requirment(produ)
    %         display('Producer present with data at R1')
            N_min=N_min+1;
            Router1_hit_count(produ)=Router1_hit_count(produ)+1;
        else % MISS HAPPENED
    %         display('Producer present without data at R1')
            N_max=N_max+1;
            memoryR1_RAND(index,2)=t_inst;
        end

    else % Case when producer is not present in CacheR1
%             display('producer not present at R1')
  % Check for empty location and index of least frequently used producer       
%             memory(:,1)=memoryR1_LFU(:,1);
%             Freshness=Frequency_R1;
        count1=count1+1;
        ProbForSaving1=0;
        if count1>length(memoryR1_RAND)
            index2=randi(length(memoryR1_RAND));
        else
            index2=count1;
        end
%             [ProbForSaving1,index2]=FindLRU(memoryR1_LRU(:,1),ProbForSavingR1);

% Genrate choice variable according to probabilty ProbForSaving
        t_stamp=t_inst;
        if rand()<max(ProbForSavingR1,ProbForSaving1)
            choice=1;             
        else
            choice=0;
        end
%             index2
%             display('Router1 Choice');
%             choice
        if choice==1
            memoryR1_RAND(index2,:)=[produ,t_stamp];
        end

        % Sorting content in memory in decreasing order of
        % time_stamp it is being used i.e. according to column 1.
%             [~,indices1]=sort(memoryR1_LRU(:,1),'descend');
%             memoryR1_LRU=memoryR1_LRU(indices1,:);

    end
%         memoryR1_RAND
    clear temp1 temp2

end