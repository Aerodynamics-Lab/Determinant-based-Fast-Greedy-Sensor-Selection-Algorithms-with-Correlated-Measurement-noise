function F_plot_error(Error)

figure()
[p,num] = size(Error);
sens=1:p;

color_set = turbo(num+1);
hold on
for i = 1:num    
plot(sens,Error(:,i),'Color',color_set(i,:),'LineWidth',1.5) ;
end
hold off

set(gca,'FontSize',18);
set(gca,'FontName','TimesNewRoman');

ylabel('Reconstruction Error','FontSize',24,'Interpreter','Tex');
xlabel('Number of sensors','FontSize',24,'Interpreter','Tex');
box on;
legend('Position',[0.7 0.73 0.2 0.1]);
end