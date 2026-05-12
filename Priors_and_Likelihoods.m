%% Code to plot the likely hoods and priors for a given class 
% This code will not work without prior loading of the data from ComBat_modified2.m

batch_sizes = accumarray(conf_FST2_final(:)+1, 1);
% ===================== USER INPUT =====================
%feature_idx = 695; % Area IDP example
%feature_idx = 192;

%feature_idx = 1221;        % <-- choose feature here

% Using the posterior cingulate volume, area and thickness
%feature_idx = 199; % LH volume
%feature_idx = 232; % RH volume

%feature_idx = 664; % LH area
%feature_idx = 695; % RH area

%feature_idx = 910; % LH area
feature_idx = 876; % RH area

batch_value = 0;         % batch to visualise

% You MUST provide this
% vector of size [n_batches x 1]
% e.g. from your design matrix
% batch_sizes(b) = number of subjects in batch b
% ------------------------------------------------------
% Example placeholder (REPLACE THIS)
% batch_sizes = [...];

% ===================== HELPERS =====================

inv_gamma_pdf = @(x,a,b) exp(a .* log(b) - gammaln(a) ...
    - (a + 1) .* log(x) - b ./ x);

get_batch_index = @(levels, b) find(levels == b, 1);
delta_mode = @(a,b) b ./ (a + 1);

% ===================== GET BATCH INDEX =====================

idx4 = get_batch_index(priors_4.levels, batch_value);

if isempty(idx4)
    error('Batch %d not found in priors.', batch_value);
end

% ===================== EXTRACT PRIORS =====================

% ----- Method 4 -----
a4 = priors_4.a_prior(idx4);
b4 = priors_4.b_prior(idx4);

% ----- Method 5 (class-specific) -----
nClasses = numel(priors_5);
a5 = NaN(nClasses,1);
b5 = NaN(nClasses,1);

for i = 1:nClasses
    p = priors_5{i};
    idx5 = get_batch_index(p.levels, batch_value);

    if isempty(idx5)
        error('Batch %d not found in priors_5{%d}.', batch_value, i);
    end

    a5(i) = p.a_prior(idx5);
    b5(i) = p.b_prior(idx5);
end

% ===================== FEATURE-SPECIFIC VALUES =====================

% Empirical variance (likelihood anchor)
delta_hat_4_jb = priors_4.delta_hat(idx4, feature_idx);

% Posterior (shrunk)
delta_post_4_jb = delta_4(idx4, feature_idx);

% Batch size
n_b = batch_sizes(idx4);

% Likelihood parameters
a_like = (n_b-1) / 2;
b_like = (n_b-1) * delta_hat_4_jb / 2;

% ===================== BUILD X GRID =====================

% Anchor grid around relevant values
ref_vals = [delta_hat_4_jb, delta_post_4_jb];

ref_vals = ref_vals(isfinite(ref_vals) & ref_vals > 0);

x_min = max(1e-8, min(ref_vals) / 100);
x_max = max(ref_vals) * 100;

xd = logspace(log10(x_min), log10(x_max), 2000);

% ===================== CURVES =====================

prior4_curve = inv_gamma_pdf(xd, a4, b4);
like_curve   = inv_gamma_pdf(xd, a_like, b_like);

% ===================== PLOT =====================

figure('Color','w','Name','Likelihood + Priors','Position',[0 0 1200 800]);
hold on; grid on;

% ----- Method 4 prior -----
plot(xd, prior4_curve, ...
    'b-', 'LineWidth', 2.5, ...
    'DisplayName', 'Method 4 Prior');

% % ----- Method 5 class priors -----
% for i = 1:nClasses
%     if i == IDP_groups(feature_idx)
%         if isfinite(a5(i)) && isfinite(b5(i)) && a5(i) > 0 && b5(i) > 0
%             plot(xd, inv_gamma_pdf(xd, a5(i), b5(i)), ...
%                 '--', 'LineWidth', 1.5, ...
%                 'DisplayName', sprintf('Method 5 Class %d', i));
%         end
%     else
%         if isfinite(a5(i)) && isfinite(b5(i)) && a5(i) > 0 && b5(i) > 0
%             plot(xd, inv_gamma_pdf(xd, a5(i), b5(i)), ...
%                 '--', 'LineWidth', 1.5, ...
%                 'DisplayName', sprintf('Method 5 Class %d', i),'Color',);
% 
%         end
%     end
% end


for i = 1:nClasses
    if isfinite(a5(i)) && isfinite(b5(i)) && a5(i) > 0 && b5(i) > 0
        
        y = inv_gamma_pdf(xd, a5(i), b5(i));
        
        % Plot first and grab handle
        h = plot(xd, y, '--', 'LineWidth', 1.5, ...
            'DisplayName', sprintf('Method 5 Class %d', i));
        
        if i ~= IDP_groups(feature_idx)
            % Get the auto-assigned color
            c = h.Color;
            
            % Reapply with transparency
            h.Color = [c 0.2];
        elseif i == IDP_groups(feature_idx)
            
            post_color = h.Color;
            h.LineWidth = 2.5;

        end
        
    end
end

% ----- Likelihood -----
plot(xd, like_curve, ...
    'k--', 'LineWidth', 1.5, ...
    'DisplayName', 'Likelihood');

% ----- Markers -----
xline(delta_hat_4_jb, '--k', 'LineWidth', 1.5, ...
    'DisplayName', '\delta hat (empirical)');

xline(delta_post_4_jb, '-b', 'LineWidth', 2.5, ...
    'DisplayName', '\delta (Final point estimate of the posterior, M4)');

% ----- Method 5 posterior -----
delta_post_5_jb = delta_5(idx4, feature_idx);


xline(delta_post_5_jb, '--', 'LineWidth', 2.5,'Color',post_color, ...
    'DisplayName', '\delta (Final point estimate of the posterior, M5)');

% ===================== FORMATTING =====================

xlabel('\delta');
ylabel('Density');


title(['IDP shown:',IDP_names_new(feature_idx),sprintf('Batch %d | Class %d', batch_value, IDP_groups(feature_idx))],'Interpreter','none')

legend('Location','best');

set(gca, 'XScale', 'log');   % IMPORTANT for visibility

%xlim([delta_post_4_jb/1.5, delta_post_4_jb*2]);
Q = quantile(xd,[0.025 0.45 0.5 0.6 0.975]);
xlim([Q(2), Q(4)])

% Insert savepath below
disp('Saving to the following path:')
save_path = '/Users/jacob.turnbull/Desktop/Subproject_1_ComBat_T1T2/Paper_Figures_Steve_comments/Ratio_1_1_temp/';
disp(save_path)

if ~exist(save_path, 'dir')
   disp('Directory does not exist, making directory')
   mkdir(save_path)
   if exist(save_path, 'dir')
       disp('Directory made')
    end

end


% Tighten axes padding
ax = gca;
ax.LooseInset = max(ax.TightInset, 0.0001);

% Optional: reduce internal margins further
ax.PositionConstraint = 'innerposition';

% Tight y-limits based on visible data

fontsize('increase')
fontsize('increase')
fontsize('increase')
fontsize('increase')
fontsize('increase')
% Remove excess whitespace around saved figure
set(gcf, 'PaperPositionMode', 'auto');

Name_of_plot = ['Likelihood_',IDP_names_new{feature_idx},'_Batch_',num2str(batch_value)];

print(gcf,'-dpng','-r300','-vector',[save_path, Name_of_plot])

