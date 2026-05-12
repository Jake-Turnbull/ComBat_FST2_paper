function plot_var_ratio(group1, group2, columnNames, groupVector, groupNames, mainAx, histAx)

    if size(group1, 2) ~= size(group2, 2)
        error('Both groups must have the same number of features (columns).');
    end

    numFeatures = size(group1, 2);
    cohens_d = zeros(1, numFeatures);
    means_group1 = zeros(1, numFeatures);
    means_group2 = zeros(1, numFeatures);
    var_meannorm1 = zeros(1, numFeatures);
    var_meannorm2 = zeros(1, numFeatures);
    var_group1 = zeros(1, numFeatures);
    var_group2 = zeros(1, numFeatures);

    for f = 1:numFeatures
        x1 = group1(:, f);
        x2 = group2(:, f);
        mean1 = mean(x1, 'omitnan');
        mean2 = mean(x2, 'omitnan');

        means_group1(f) = mean1;
        means_group2(f) = mean2;
        var1 = var(x1, 'omitnan');
        var2 = var(x2, 'omitnan');

        std1 = std(x1,'omitnan');
        std2 = std(x2,'omitnan');

        var_meannorm1(f) = (std1 ./ mean1)^2;
        var_meannorm2(f) = (std2 ./ mean2)^2;

        pooled_std = sqrt(((numel(x1) - 1) * var1 + (numel(x2) - 1) * var2) / (numel(x1) + numel(x2) - 2));
        cohens_d(f) = (mean1 - mean2) / pooled_std;

        var_group1(f) = var1;
        var_group2(f) = var2;

        % T-test ignored here for simplicity, but keep if needed
    end 

    % Use provided axes or default to current axes
    if nargin < 6 || isempty(mainAx)
        mainAx = gca;
    end

    if nargin < 7 || isempty(histAx)
        % Create a histogram next to the main axes
        histAx = axes('Position', insetPosition(mainAx, 0.075, 1));
    end
    var_ratio = (var_group1 ./ var_group2);
    
    var_ratio = (var_group1 ./ var_group2);

    disp(['The mean and standard deviation of the ratio of variance across IDPs were ', ...
        num2str(mean(var_ratio')), ' and ',num2str(std(var_ratio'))])

   
    % Main bar chart
    axes(mainAx); % make sure plotting happens in main axis
    cla(mainAx);
    hold(mainAx,'on');
    plot(mainAx, var_ratio,'-b');
    plot(mainAx,var_ratio,'.r')
    xlim(mainAx, [0, size(var_ratio,2)])
    if max(var_ratio) < 1.35
        ylim(mainAx, [0.75 1.35])
        ylim(histAx, [0.75 1.35])
    end

    % Histogram
    histogram(histAx, var_ratio, 'Orientation', 'horizontal', 'FaceColor', [0.8 0.2 0.2]);
    hold(histAx, 'on');
    xlabel(histAx, 'Proportion');
    yticklabels({})
    set(histAx, 'XDir', 'reverse');
    set(histAx, 'YAxisLocation', 'right');



    yline(mainAx,[1.1, 0.9],'-g','Reference line','LabelHorizontalAlignment','left')
        
    xlabel(mainAx, 'IDP index by category');
    ylabel(mainAx,'Variance ratio: ${\it} (\sigma^{2}_{FST2==1}  / \sigma^{2}_{FST2==0}) $','Interpreter','Latex');
    grid(mainAx, 'on');
    histAx.YLim = mainAx.YLim;

    dcm = datacursormode(gcf);
    set(dcm, 'UpdateFcn', @(obj, event) dataCursorCallback(event, columnNames, cohens_d));
    
    % Group ticks and labels
    if nargin > 4 && ~isempty(groupVector)
        uniqueGroups = unique(groupVector);
        tickPositions = zeros(1, length(uniqueGroups));
        groupEndPositions = zeros(1, length(uniqueGroups));
        
        for i = 1:length(uniqueGroups)
            groupIndices = find(groupVector == uniqueGroups(i));
            tickPositions(i) = mean(groupIndices);
            groupEndPositions(i) = max(groupIndices);
        end

        for i = 1:length(groupEndPositions)-1
            xline(mainAx, groupEndPositions(i), 'k--', 'LineWidth', 1);
        end

        xticks(mainAx, tickPositions);
        xticklabels(mainAx, groupNames);
        xtickangle(mainAx, 45);
    end
end