function [ ] = F_fig_SST_sensors_color_compare(sensi,mask, sensors)
[~,num] = size(sensors);
f1=figure();
f1.Units='pixels';
%display_sensors Template for displaying image data
%   Displays enso sensors on white w/ black continents
%    close all;
%    set(gcf,'PaperPositionMode','auto')
   snapshot = NaN*zeros(360*180,1);
    x=sensi';
    snapshot(mask==1) = x;
    C = reshape(real(snapshot),360,180)';
    b = imagesc(C,'AlphaData',(~isnan(C)+0.1.*isnan(C)));
    shading interp;
    jetmod=jet(256);
    jetmod(1,:)=0;
    colormap(jetmod);
    %colormap(jet);
     %%
%     %{
    c=colorbar;
    if verLessThan('matlab','9.8')
    else
        f1.OuterPosition=[201 401 560 550];
        axis off
        c=colorbar();
        c.FontSize = 14;
        c.Label.String = 'RMS of Temperature [K]';
        c.Label.FontName = 'TimesNewRoman';
        c.Label.FontSize = 16;
%         c.Location='northoutside'
        daspect([1.3 1 1])
    end
    %}
    axis off
    caxis([0 1.2]);
%     caxis([-10 30]);
    %%
    set(gca, 'FontName', 'Times','Color','white', 'FontSize', 20);
    
    sensors_location = zeros(360,180);
    I=[];J=[];
    hold on
    color_set = bone(num+1);
    for i=1:num
        P = zeros(size(x)); 
        pivot=sensors(:,i);
        P(pivot)=1:length(pivot);
        sensors_location(mask==1) = P;
        S = reshape(real(sensors_location)',360*180,1);
        [~,IC,~] = unique(S);
        [I,J] = ind2sub(size(sensors_location'),IC(2:end));
        plot(J,I,'o','MarkerSize', 4,'LineWidth', 2, 'MarkerFaceColor', color_set(i,:),'MarkerEdgeColor',color_set(i,:),'MarkerFaceColor','none');
    end
    legend
end
