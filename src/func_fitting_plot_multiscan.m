
function [figure_handles]=func_fitting_plot_multiscan(FM_data,axis_info,filename,exp_params, plot_params)
display('Fitting Method plotting starting');
x_sel =1;
y_sel =1;
for sI = FM_data.scan_idxs
    sc = sprintf('scan%i',sI);
    yAx = 'axis1';
    xAx = sprintf('axis%i',1+find(axis_info.(sc).axis_pts(2:end) == max(axis_info.(sc).axis_pts(2:end)),1));
    for k=1:length(FM_data.(sc).A);
        exp_params.figure_save = plot_params.figure_save;
        plotting_vars = {FM_data.(sc),axis_info.(sc),filename,k,exp_params, xAx, yAx};
        
        figure_handles(k) = figure('position',[25+(k-1)*800 25 1200 600]);
        
        subplot(2,3,1);imagesc(axis_info.(sc).(xAx).um,axis_info.(sc).(yAx).um,FM_data.(sc).A{k});% % axis image;
        a = get(gca,'position');c =colorbar('location','westoutside');set(gca,'position',a);
        set(gca,'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars});                 %assign call back function when mouse clicked in figur
        set(get(gca,'Children'),'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars}); %apply to data in the figure as well
        title(sprintf('A %d',k));
        hold on;plot(axis_info.(sc).(xAx).um(x_sel),axis_info.(sc).(yAx).um(y_sel),'wx','markersize',8,'linewidth',2);hold off
        subplot(2,3,2);imagesc(axis_info.(sc).(xAx).um,axis_info.(sc).(yAx).um,FM_data.(sc).alpha{k},[median(FM_data.(sc).alpha{k}(:))*[0.2 5]]);% axis image;
        a = get(gca,'position');c =colorbar('location','westoutside');set(gca,'position',a);
        set(gca,'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars});                 %assign call back function when mouse clicked in figur
        set(get(gca,'Children'),'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars}); %apply to data in the figure as well
        title('\alpha ');
        hold on;plot(axis_info.(sc).(xAx).um(x_sel),axis_info.(sc).(yAx).um(y_sel),'wx','markersize',8,'linewidth',2);hold off
        subplot(2,3,3);imagesc(axis_info.(sc).(xAx).um,axis_info.(sc).(yAx).um,FM_data.(sc).amp{k},[median(FM_data.(sc).amp{k}(:))*[0.2 5]]);% axis image;
        a = get(gca,'position');c =colorbar('location','westoutside');set(gca,'position',a);
        set(gca,'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars});                 %assign call back function when mouse clicked in figur
        set(get(gca,'Children'),'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars}); %apply to data in the figure as well
        title('amp');
        hold on;plot(axis_info.(sc).(xAx).um(x_sel),axis_info.(sc).(yAx).um(y_sel),'wx','markersize',8,'linewidth',2);hold off
        subplot(2,3,4);imagesc(axis_info.(sc).(xAx).um,axis_info.(sc).(yAx).um,FM_data.(sc).phi{k},[-pi pi]);% axis image;
        a = get(gca,'position');c =colorbar('location','westoutside');set(gca,'position',a);
        set(gca,'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars});                 %assign call back function when mouse clicked in figur
        set(get(gca,'Children'),'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars}); %apply to data in the figure as well
        title('phi ');
        hold on;plot(axis_info.(sc).(xAx).um(x_sel),axis_info.(sc).(yAx).um(y_sel),'wx','markersize',8,'linewidth',2);hold off
        subplot(2,3,5);imagesc(axis_info.(sc).(xAx).um,axis_info.(sc).(yAx).um,FM_data.(sc).freq{k},[exp_params.f_min,exp_params.f_max]);% axis image;
        a = get(gca,'position');c =colorbar('location','westoutside');set(gca,'position',a);
        set(gca,'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars});                 %assign call back function when mouse clicked in figur
        set(get(gca,'Children'),'interruptible','off','BusyAction','cancel','ButtonDownFcn', {@func_plot_fitting_callback_multiscan,plotting_vars}); %apply to data in the figure as well
        title('freq ');;
        hold on;plot(axis_info.(sc).(xAx).um(x_sel),axis_info.(sc).(yAx).um(y_sel),'wx','markersize',8,'linewidth',2);hold off
        
        subplot(2,3,6);plot(FM_data.(sc).t,squeeze(FM_data.(sc).data_array{k}(y_sel,x_sel,:)),FM_data.(sc).t,squeeze(FM_data.(sc).traces_fit{k}(y_sel,x_sel,:)),FM_data.(sc).t,squeeze(FM_data.(sc).residuals{k}(y_sel,x_sel,:)));
        legend('tr','fit','err');
        
%         if sI == 2
%             error('aaaa')
%         end
        
        if plot_params.figure_save ==1
            fig_name = strcat(strip_suffix(filename.con,'.con'),'_FMA_plot_',num2str(k));
            set(gcf,'paperpositionmode','auto');
            print('-dpng',strcat(fig_name,'.png'));
            print('-depsc',strcat(fig_name,'.eps'));
            print('-dsvg',strcat(fig_name,'.svg'));   % added by fernando 8/dec/17
        end
        
    end
end