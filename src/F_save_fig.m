function F_save_fig(file_name)

    saveas(gcf, file_name,'png');
    saveas(gcf, file_name);
    if verLessThan('matlab','9.8')
    else
        exportgraphics(gcf,[file_name,'.pdf'],'BackgroundColor','none','ContentType','vector')
    end
    if ispc==1
        saveas(gcf, file_name,'meta');
    end
end