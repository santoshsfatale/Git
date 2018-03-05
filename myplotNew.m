function myplotNew(xinput,yinputMatrix_avg,yinputMatrix_stdDev,xlabel1,ylabel1,legend1,xlim1,ylim1,saveFigAs,directory)
% make sure that yinputMatrix and xinput have same length. legend1 and
% yinputMatrix have same order in terms of data.
%
%
% Argument discription
% xinput: data for x-axis
% yinputMatrix_avg: Average data for y-axis
% yinputMatrix_stdDev: Standard Deviation data for y-axis
% xlabel1: string for xlabel
% ylabel1: string for ylabel
% title1: string for title
% legend: cell structure for legend
% saveFigAs: string used as name for saving the fig
% 
% 
% 
h=figure;
[~,width]=size(yinputMatrix_avg);
LineVector={'-o','-^','-s','-d','-p','-h','-o','->'};
% LineVector={'-o','-','--','-.',':','-h','-o','->'};
ColorVecor={[0 0 0]/255,[255 0 0]/255,[0 128 0]/255,[0 0 255]/255,[153 50 204]/255,[255 185 15]/255,[150 0 150]/255};
for ii=1:width
    plot(xinput,yinputMatrix_avg(:,ii),LineVector{ii},'color',ColorVecor{ii},'LineWidth',2,'MarkerFaceColor',ColorVecor{ii});
    hold on;
end

% for ii=2:width
%     errorbar(xinput,yinputMatrix_avg(:,ii),3*yinputMatrix_stdDev(:,ii-1),LineVector{ii},'color',ColorVecor{ii},'LineWidth',2);
%     hold on;
% end

grid on;
% xlabel1=strcat('\rm',xlabel1);
% ylabel1=strcat('\rm',ylabel1);
xlabel(xlabel1,'Fontsize',12);%,'FontName','MS Serif');
ylabel(ylabel1,'Fontsize',12);%,'FontName','MS Serif');
% set(get(gca,'ylabel'),'rotation',180)
% set(h1,'FontName','MS Serif');
% set(h2,'FontName','MS Serif');
% title(title1,'Fontsize',14);
legend(legend1);
% xlim(xlim1);
% ylim(ylim1);
title('\beta=0.5, Total cache size= ,N= ,')
hold off;
cd(directory)
str1=strcat(saveFigAs,'.fig');
saveas(h,str1);
clear str1;
% str1=strcat(saveFigAs,'.eps');
saveas(h,saveFigAs,'epsc');
str1=strcat(saveFigAs,'.pdf');
saveas(h,str1);
