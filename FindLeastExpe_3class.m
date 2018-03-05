function [Value,index2]=FindLeastExpe_3class(producers,t_stamps,t_inst)
global Probability_producers Pop_producers Freshness_requirment
% producers
% clear temp1;
temp1(:,1)=Probability_producers(producers);
temp2=zeros(length(producers),1);
for ii=1:length(producers)
%     index1=sum(producers(ii)>cumsum([0 Pop_producers]));
    temp2(ii,1)=t_stamps(ii)+Freshness_requirment(producers(ii))-t_inst;
end
% temp2
% temp1.*temp2
[Value,index2]=min(temp1.*temp2);

