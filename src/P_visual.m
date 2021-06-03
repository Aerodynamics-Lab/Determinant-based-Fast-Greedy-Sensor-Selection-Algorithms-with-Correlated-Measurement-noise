%% Visualize
%% ///////////////////////////////////////////////////////////////////
% Comments:
% 	Collaborator: Yuji Saito, Keigo Yamada, Taku Nonomura
%                 Kumi Nakai, Takayuki Nagata
% 	Last modified: 2021/6/3

%% ===================================================================

date_now = datestr(now,'mmdd_HHMMSS')

F_fig_SST_sensors_color_compare(rms_sst,mask, [sensors_DG, sensors_DGCN,sensors_BDG])
file_name=(sprintf('%s/fig_sensor_%s',sensordir,date_now));
F_save_fig(file_name)

F_plot_error([Error(:,3),Error(:,6),Error(:,9)])
F_plot_error([Error(:,5),Error(:,8),Error(:,11)])