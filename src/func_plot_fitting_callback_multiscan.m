function func_plot_fitting_callback(gcbo,eventdata,plotting_vars)




%plotting_vars = {data,axis_info,filename,k};

FM_data= plotting_vars{1};
filename= plotting_vars{3};
axis_info= plotting_vars{2};
k= plotting_vars{4};
exp_params = plotting_vars{5};
xAx = plotting_vars{6};
yAx = plotting_vars{7};


cP = get(gca,'Currentpoint');
x = cP(1,1);
y = cP(1,2);
dx = axis_info.(xAx).um(2)-axis_info.(xAx).um(1);
dy = axis_info.(yAx).um(2)-axis_info.(yAx).um(1);
x_sel = find(0.5*dx+axis_info.(xAx).um>x,1);
y_sel = find(0.5*dy+axis_info.(yAx).um>y,1);
if x>max(axis_info.(xAx).um)
    x_sel=axis_info.xpts;
end
if y>max(axis_info.(yAx).um)
    y_sel=axis_info.ypts;
end
if x<min(axis_info.(xAx).um)
    x_sel=1;
end
if y<min(axis_info.(yAx).um)
    y_sel=1;
end
if isempty(x_sel)
    x_sel=axis_info.xpts;
end
if isempty(y_sel)
    y_sel=axis_info.ypts;
end
[ x x_sel y y_sel];

subplot(2,3,1);h2=get(gca,'Children');set(h2(1),'Xdata',axis_info.(xAx).um(x_sel),'YData',axis_info.(yAx).um(y_sel));
subplot(2,3,2);h2=get(gca,'Children');set(h2(1),'Xdata',axis_info.(xAx).um(x_sel),'YData',axis_info.(yAx).um(y_sel));
subplot(2,3,3);h2=get(gca,'Children');set(h2(1),'Xdata',axis_info.(xAx).um(x_sel),'YData',axis_info.(yAx).um(y_sel));
subplot(2,3,4);h2=get(gca,'Children');set(h2(1),'Xdata',axis_info.(xAx).um(x_sel),'YData',axis_info.(yAx).um(y_sel));
subplot(2,3,5);h2=get(gca,'Children');set(h2(1),'Xdata',axis_info.(xAx).um(x_sel),'YData',axis_info.(yAx).um(y_sel));
subplot(2,3,6);plot(FM_data.t,squeeze(FM_data.data_array{k}(y_sel,x_sel,:)),FM_data.t,squeeze(FM_data.traces_fit{k}(y_sel,x_sel,:)),FM_data.t,squeeze(FM_data.residuals{k}(y_sel,x_sel,:)));
legend('tr','fit','err');drawnow
if exp_params.figure_save ==1
    fig_name = strcat(strip_suffix(filename.con,'.con'),'_FMA_plot_',num2str(k));
    set(gcf,'paperpositionmode','auto');
    print('-dpng',strcat(fig_name,'.png'));
    print('-depsc',strcat(fig_name,'.eps'));
end
