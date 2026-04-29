%%
% simulate_combat_class_bias.m
% Two batches, three feature classes:
%   class 1: batch-2 bias negative on average
%   class 2: batch-2 bias positive on average
%   class 3: mixed positive/negative batch-2 bias
%
% Output:
%   Y          : nSubj x nFeat data matrix
%   batch      : nSubj x 1 batch labels (1 = reference, 2 = batch to correct)
%   class_id   : nFeat x 1 feature-class labels (1/2/3)
%   gamma_true : nFeat x 1 true additive batch-2 effect
%   delta_true : nFeat x 1 true multiplicative batch-2 scale effect
%
% Save the .mat file and feed Y/batch/covariates into your ComBat code.

clear; clc;
rng(42);

%% Design
nPerBatch = 100;
nBatch = 2;
nSubj = nPerBatch * nBatch;

pPerClass = 200;              % features per class
nClass = 3;
nFeat = pPerClass * nClass;

batch = [ones(nPerBatch,1); 2*ones(nPerBatch,1)];

% Optional biological covariate (set to zeros if you do not want one)
age = 50 + 8*randn(nSubj,1);   % example covariate
sex = double(rand(nSubj,1) > 0.5);

%% Feature-wise baseline signal
alpha = 2 + 0.5*randn(1,nFeat);   % feature-specific intercepts

% Optional biological effects, feature-specific
beta_age = 0.02 * randn(1,nFeat);
beta_sex = 0.10 * randn(1,nFeat);


% Residual SD per feature
sigma = 0.35 + 0.10*rand(1,nFeat);

%% Class labels and true batch effects
class_id   = zeros(nFeat,1);
gamma_true = zeros(nFeat,1);   % additive batch-2 effect relative to batch 1
delta_true = ones(nFeat,1);    % multiplicative batch-2 scale effect

for c = 1:nClass
    idx = ( (c-1)*pPerClass + 1 ) : ( c*pPerClass );
    class_id(idx) = c;

    switch c
        case 1
            % Negative bias on average
            gamma_true(idx) = -0.60 + 0.08*randn(pPerClass,1);
        case 2
            % Positive bias on average
            gamma_true(idx) =  0.60 + 0.08*randn(pPerClass,1);
        case 3
            % Mixed class: half negative, half positive
            mixFlag = rand(pPerClass,1) > 0.5;
            gamma_true(idx) = 0;
            gamma_true(idx(mixFlag))  = -0.35 + 0.08*randn(sum(mixFlag),1);
            gamma_true(idx(~mixFlag))  =  0.35 + 0.08*randn(sum(~mixFlag),1);
    end

    % Keep scale effects close to 1, with mild variability
    delta_true(idx) = exp(0.05*randn(pPerClass,1));
end

%% Simulate data matrix Y (subjects x features)
Y = zeros(nSubj, nFeat);

for i = 1:nSubj
    b = batch(i);

    if b == 1
        gamma_i = zeros(1,nFeat);
        delta_i = ones(1,nFeat);
    else
        gamma_i = gamma_true.';
        delta_i = delta_true.';
    end

    mu_i = alpha ...
        + age(i) * beta_age ...
        + sex(i) * beta_sex ...
        + gamma_i;

    eps_i = randn(1,nFeat);
    Y(i,:) = mu_i + delta_i .* (sigma .* eps_i);
end

Mod = [age sex];
%% Quick sanity plots
figure;
tcl1 = tiledlayout(2,1);
title(tcl1,'True delta and gamma')
nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, gamma_true(idx), '.');
end
yline(0,'k-');
xlabel('Feature index');
ylabel('True batch-2 \gamma');
title('True additive batch effects by class');
legend({'Class 1','Class 2','Class 3','Zero'}, 'Location', 'best');

nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, delta_true(idx), '.');
end
yline(1,'k-');
xlabel('Feature index');
ylabel('True batch-2 \delta');
title('True multiplicative batch effects by class');
legend({'Class 1','Class 2','Class 3','One'}, 'Location', 'best');

disp('Saved combat_simulation.mat');
disp('Y is subjects x features.');
saveas(gcf,'True delta and gamma.png')
%% Setup
addpath('/Users/jacob.turnbull/Documents/MATLAB/ComBatHarmonization-master/Matlab/scripts/ComBat-M/')

bidx = 2;  % batch 2 is the one being corrected relative to reference batch 1

%% Run separately for each class
delta_star_class = nan(nFeat,1);
gamma_star_class = nan(nFeat,1);

for c = 1:nClass
    idx = find(class_id == c);

    % Y(:,idx)' gives features x subjects for this class
    [bayesdata, delta_star2, gamma_star2, t2, gamma_hat, delta_hat, a_prior, b_prior] = ...
        combat_modified(Y(:,idx)', batch, Mod, 1);

    % Extract batch 2 estimates for this class
    delta_star_class(idx) = delta_star2(bidx, :)';
    gamma_star_class(idx) = gamma_star2(bidx, :)';
end

figure;
tiledlayout(2,1);
tcl2 = tiledlayout(2,1);
title(tcl2,'Delta and gamma from class specific combat')

nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, gamma_star_class(idx), '.');
end
yline(0,'k-');
xlabel('Feature index');
ylabel('\gamma (batch 2)');
title('Predicted additive batch effects by class');
legend({'Class 1','Class 2','Class 3','Zero'}, 'Location', 'best');

nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, delta_star_class(idx), '.');
end
yline(1,'k-');
xlabel('Feature index');
ylabel('\delta (batch 2)');
title('Predicted multiplicative batch effects by class');
legend({'Class 1','Class 2','Class 3','One'}, 'Location', 'best');
saveas(gcf,'Delta and gamma from class specific combat.png')

%% Run all at once
[bayesdata_all, delta_star_all, gamma_star_all, t2_all, gamma_hat_all, delta_hat_all, a_prior_all, b_prior_all] = ...
    combat_modified(Y', batch, Mod, 1);

% Extract batch 2 estimates for all features
delta_star_all = delta_star_all(bidx, :)';
gamma_star_all = gamma_star_all(bidx, :)';

figure;
tiledlayout(2,1);
tcl3 = tiledlayout(2,1);
title(tcl3,'Delta and gamma from Non-class specific combat')


nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, gamma_star_all(idx), '.');
end
yline(0,'k-');
xlabel('Feature index');
ylabel('\gamma (batch 2)');
title('Predicted additive batch effects by class');
legend({'Class 1','Class 2','Class 3','Zero'}, 'Location', 'best');

nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, delta_star_all(idx), '.');
end
yline(1,'k-');
xlabel('Feature index');
ylabel('\delta (batch 2)');
title('Predicted multiplicative batch effects by class');
legend({'Class 1','Class 2','Class 3','One'}, 'Location', 'best');
saveas(gcf,'Delta and gamma from Non-class specific combat.png')

%% Error relative to truth
gamma_err_class = gamma_star_class - gamma_true;
delta_err_class = delta_star_class - delta_true;

gamma_err_all = gamma_star_all - gamma_true;
delta_err_all = delta_star_all - delta_true;

figure;
tcl4 = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
title(tcl4,'ComBat estimate error relative to truth');

% Gamma error
nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, gamma_err_class(idx), '.', 'DisplayName', sprintf('Class %d: class-specific', c));
    plot(idx, gamma_err_all(idx), 'x', 'DisplayName', sprintf('Class %d: pooled', c));
end
yline(0,'k-','HandleVisibility','off');
xlabel('Feature index');
ylabel('\gamma_{est} - \gamma_{true}');
title('Additive batch-effect error');
legend('Location','best');

% Delta error
nexttile;
hold on;
for c = 1:nClass
    idx = find(class_id == c);
    plot(idx, delta_err_class(idx), '.', 'DisplayName', sprintf('Class %d: class-specific', c));
    plot(idx, delta_err_all(idx), 'x', 'DisplayName', sprintf('Class %d: pooled', c));
end
yline(0,'k-','HandleVisibility','off');
xlabel('Feature index');
ylabel('\delta_{est} - \delta_{true}');
title('Multiplicative batch-effect error');
legend('Location','best');

saveas(gcf,'ComBat_estimation_error.png')