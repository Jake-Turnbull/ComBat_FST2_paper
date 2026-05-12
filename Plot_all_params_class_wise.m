%% Plot the combat model parameters for different N on one axis

addpath('Tests_of_variance/')

load("ComBat_Params_modified_100_Ns20_reps_ratio_1_983_ClassWise.mat")
% Add a path for figures to save
disp('Saving to the following path:')
save_path = '/Users/jacob.turnbull/Desktop/';
disp(save_path)

%%
Fig1 = figure;
Fig1.Position = [100 100 1400 1200];  % taller figure helps a lot
t = tiledlayout(4,2,'TileSpacing','loose','Padding','loose');
figname = 'Delta_with_diff_N_combat_m_classwise.png';

load("ComBat_Params_modified_100_Ns20_reps_ratio_1_983_ClassWise.mat","batch_size","batch_size2","delta_star_T1_mean","delta_star_T1T2_var","ratio_T2_NoT2","delta_star_T1T2_mean","delta_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,1);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,910),delta_star_T1_var(:,910),delta_star_T1T2_mean(:,910),delta_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,2);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,695),delta_star_T1_var(:,695),delta_star_T1T2_mean(:,695),delta_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_2_1966_ClassWise.mat","batch_size","batch_size2","delta_star_T1_mean","delta_star_T1T2_var","ratio_T2_NoT2","delta_star_T1T2_mean","delta_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,3);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,910),delta_star_T1_var(:,910),delta_star_T1T2_mean(:,910),delta_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,4);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,695),delta_star_T1_var(:,695),delta_star_T1T2_mean(:,695),delta_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_5_4915_ClassWise.mat","batch_size","batch_size2","delta_star_T1_mean","delta_star_T1T2_var","ratio_T2_NoT2","delta_star_T1T2_mean","delta_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,5);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,910),delta_star_T1_var(:,910),delta_star_T1T2_mean(:,910),delta_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,6);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding

plot_all_params(ax1,batch_size,delta_star_T1_mean(:,695),delta_star_T1_var(:,695),delta_star_T1T2_mean(:,695),delta_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_10_9830_ClassWise.mat","batch_size","batch_size2","delta_star_T1_mean","delta_star_T1T2_var","ratio_T2_NoT2","delta_star_T1T2_mean","delta_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,7);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding
plot_all_params(ax1,batch_size,delta_star_T1_mean(:,910),delta_star_T1_var(:,910),delta_star_T1T2_mean(:,910),delta_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,8);
%set(gca, 'LooseInset', max(get(gca,'TightInset'), 0.06))   % reduces white padding
plot_all_params(ax1,batch_size,delta_star_T1_mean(:,695),delta_star_T1_var(:,695),delta_star_T1T2_mean(:,695),delta_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
exportgraphics(gcf, fullfile(save_path, figname), 'Resolution',300, 'ContentType','image', 'BackgroundColor','white')

%% Gamma change

Fig2 = figure;
Fig.Position = [100 100 1400 1200];  % taller figure helps a lot
t = tiledlayout(4,2,'TileSpacing','loose','Padding','loose');
figname = 'Gamma_with_diff_N_combat_m_classwise.png';
Fig2 = figure;
Fig2.Position = [100 900 1400 1200];

load("ComBat_Params_modified_100_Ns20_reps_ratio_1_983_ClassWise.mat","batch_size","batch_size2","gamma_star_T1_mean","gamma_star_T1T2_var","ratio_T2_NoT2","gamma_star_T1T2_mean","gamma_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,1);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,910),gamma_star_T1_var(:,910),gamma_star_T1T2_mean(:,910),gamma_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,2);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,695),gamma_star_T1_var(:,695),gamma_star_T1T2_mean(:,695),gamma_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_2_1966_ClassWise.mat","batch_size","batch_size2","gamma_star_T1_mean","gamma_star_T1T2_var","ratio_T2_NoT2","gamma_star_T1T2_mean","gamma_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,3);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,910),gamma_star_T1_var(:,910),gamma_star_T1T2_mean(:,910),gamma_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,4);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,695),gamma_star_T1_var(:,695),gamma_star_T1T2_mean(:,695),gamma_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_5_4915_ClassWise.mat","batch_size","batch_size2","gamma_star_T1_mean","gamma_star_T1T2_var","ratio_T2_NoT2","gamma_star_T1T2_mean","gamma_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,5);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,910),gamma_star_T1_var(:,910),gamma_star_T1T2_mean(:,910),gamma_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,6);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,695),gamma_star_T1_var(:,695),gamma_star_T1T2_mean(:,695),gamma_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load("ComBat_Params_modified_100_Ns20_reps_ratio_10_9830_ClassWise.mat","batch_size","batch_size2","gamma_star_T1_mean","gamma_star_T1T2_var","ratio_T2_NoT2","gamma_star_T1T2_mean","gamma_star_T1_var")
legend1 = ['FST2 = 0, N = ', num2str(min(batch_size2)) ,'-> ',num2str(max(batch_size2))];
legend2 = ['FST2 = 1, N = ', num2str(min(batch_size)) ,'-> ',num2str(max(batch_size))];
total_batch = batch_size+batch_size2;
% Strong batch effect
ax1=subplot(4,2,7);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,910),gamma_star_T1_var(:,910),gamma_star_T1T2_mean(:,910),gamma_star_T1T2_var(:,910),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
% Weak batch effect
ax1=subplot(4,2,8);
plot_all_params(ax1,batch_size,gamma_star_T1_mean(:,695),gamma_star_T1_var(:,695),gamma_star_T1T2_mean(:,695),gamma_star_T1T2_var(:,695),ratio_T2_NoT2)
legend(ax1,legend1,legend2,'Location', 'Best')
exportgraphics(gcf, fullfile(save_path, figname), 'Resolution',300, 'ContentType','image', 'BackgroundColor','white')

%% Plotting script

function plot_all_params2(ax,batch_size,meanT1,varT1,meanT1T2,varT1T2,ratio_T2_NoT2)
hold on;

errorbar(ax,batch_size,meanT1,varT1)
errorbar(ax,batch_size,meanT1T2,varT1T2)
yl = ylim();
xl = xlim();
xt = xticks();
fs = get(ax,'FontSize');
yl_tot =abs(yl(1)-yl(2));

xlabel('Sample size of the FST2==0 batch', ...
    'VerticalAlignment','bottom', ...
   'FontSize',10,'Position',[(xl(1)+0.06*xl(1)) (yl(2)+0.08*yl_tot) 0],'HorizontalAlignment','left')
grid on;
% decrease the axes height a little, to make room for the new "xlabel"
ax.Position(4) = 0.93*ax.Position(4);
% create tick labels at the top of the plot:
text(xt,yl(2)*ones(numel(xt),1),string(round(xt/ratio_T2_NoT2)), ...
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','center', ...
    'FontSize',fs)
% create a new "xlabel":
text(mean(xlim()),yl(2)+0.08*(yl(2)-yl(1)),'Sample size of the FST2==1 batch', ...
    'VerticalAlignment','top', ...
    'FontSize',10,'Position',[(xl(1)+0.06*xl(1)) (yl(1)-0.1*yl_tot) 0],'HorizontalAlignment','left')

end

function plot_all_params(ax,batch_size,meanT1,varT1,meanT1T2,varT1T2,ratio_T2_NoT2)

    hold(ax,'on')

    h1 = errorbar(ax,batch_size,meanT1,varT1,'o-','LineWidth',1,'MarkerSize',4);
    h2 = errorbar(ax,batch_size,meanT1T2,varT1T2,'s-','LineWidth',1,'MarkerSize',4);

    grid(ax,'on')
    box(ax,'on')
    ax.Layer    = 'top';
    ax.TickDir  = 'out';
    ax.FontSize = 9;
    ax.LineWidth = 0.75;

    % Bottom axis ticks
    xt = unique(round(linspace(min(batch_size), max(batch_size), 5)));
    ax.XLim = [min(batch_size) max(batch_size)];
    ax.XTick = xt;
    ax.XTickLabel = compose('%d', xt);

    % Bottom label
    xlabel(ax,{'Sample size of the FST2 = 0 batch';''},'FontSize',9)
    ax.XLabel.Units = 'normalized';
    ax.XLabel.Position = [0.5 -0.1 0];

    % Top axis
    yl = ylim(ax);
    axTop = axes('Position', ax.Position, ...
                 'Color', 'none', ...
                 'XAxisLocation', 'top', ...
                 'YAxisLocation', 'right', ...
                 'XLim', ax.XLim, ...
                 'YLim', yl, ...
                 'XTick', xt, ...
                 'XTickLabel', compose('%d', round(xt ./ ratio_T2_NoT2)), ...
                 'YTick', [], ...
                 'Box', 'off', ...
                 'TickDir', 'out', ...
                 'FontSize', 9, ...
                 'LineWidth', 0.75, ...
                 'HitTest', 'off', ...
                 'PickableParts', 'none');

    xlabel(axTop,'Sample size of the FST2 = 1 batch','FontSize',9)
    axTop.XLabel.Units = 'normalized';
    axTop.XLabel.Position = [0.5 1.1 0];

    linkaxes([ax axTop],'y')
    uistack(axTop,'top')

    legend(ax,[h1 h2],{'FST2 = 1','FST2 = 0'},'Location','best')
end