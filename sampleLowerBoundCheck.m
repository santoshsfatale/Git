clear temp
temp=zeros(Producers,3);
lowerBound=zeros(1,length(CacheSize));
for cc=1:length(F_a)
    temp(:,1)=ProducersProbability_Zipf(1,:);
    temp(:,2)=Freshness_Zipf(:,cc);
    temp(:,3)=temp(:,1).*temp(:,2);
    [~,indices]=sort(temp(:,3),'descend');
    temp=temp(indices,:);
    Freshness_cap(:,1)=temp(:,2)-(temp(CacheSize,1)*temp(CacheSize,2)./(temp(:,1)));
    clear temp2
    temp2(:,1)=temp(1:CacheSize-1,1).*Freshness_cap(1:CacheSize-1,1);
    lowerBound(1,cc)=sum(((temp(1:CacheSize-1,1).*temp2))...
                          ./(1+(temp2)));
end