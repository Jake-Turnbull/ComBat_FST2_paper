function bland_altman_density_fast(data1, data2, custom_color_range, data1_name, data2_name, num_bins,Axes,ShowHist)
    % Default arguments
    if nargin < 4 || isempty(data1_name)
        data1_name = 'A';
    end
    if nargin < 5 || isempty(data2_name)
        data2_name = 'B';
    end
    if nargin < 3 || isempty(custom_color_range)
        % default blue-red colormap; this can be used instead of below
        % values:

        % custom_color_range = jet(256);

        red=[linspace(1,1,128)',linspace(0,0,128)',linspace(0,0,128)'];
        red_yellow =[linspace(1,1,128)',linspace(1,0,128)',linspace(0,0,128)'];
        yellow = [linspace(1,1,128)',linspace(1,1,128)',linspace(0,0,128)'];
        yellow_green=[linspace(0,1,128)',linspace(1,1,128)',linspace(0,0,128)'];
        green = [linspace(0,0,64)',linspace(1,1,64)',linspace(0,0,64)'];
        green_blue = [linspace(0,0,128)',linspace(0,1,128)',linspace(1,0,128)'];
        blue = [linspace(0,0,128)',linspace(0,0,128)',linspace(1,1,128)'];
        custom_color_range = [blue; green_blue; green; yellow_green;yellow;red_yellow; red];

    end
    if nargin < 6 || isempty(num_bins)
        num_bins = 200;
    end

    if nargin < 7 || isempty(Axes)
       figure('Position',[100 100 1250 700],'Color','w'); % white background
       axMain = axes;
    else
       axMain = Axes;
    end
    
    if nargin < 8 || isempty(ShowHist)
        ShowHist = false;
    end
    
    axes(axMain); 
    hold(axMain,'on');
    grid(axMain,'on');


    % Mean (x) and Difference (y)
    M = (data1(:) + data2(:)) / 2;
    D = data1(:) - data2(:);

    % Compute statistics
    meanDiff   = mean(D);
    stddiff    = std(D);
    upperLimit = meanDiff + 1.96 * stddiff;
    lowerLimit = meanDiff - 1.96 * stddiff;

    % Define bin edges
    x_edges = linspace(min(M), max(M), num_bins);
    y_edges = linspace(min(D), max(D), num_bins);

    % Compute 2D histogram
    counts = histcounts2(M, D, x_edges, y_edges);
    counts = log10(counts + 1); % log scale to compress extremes

    % Normalize for color mapping
    counts_norm = (counts - min(counts(:))) / (max(counts(:)) - min(counts(:)));

        % --- PLOTTING ---

    % Density heatmap
    hImg = imagesc(axMain,x_edges, y_edges, counts'); % use raw log counts, not normalized
    axis(axMain, 'xy');

    
    colormap(axMain,custom_color_range);
    hold on;

    % Match colormap to log(counts)
    caxis(axMain,[min(counts(:)) max(counts(:))]);

    % Overlay downsampled scatter
    N = numel(M);

    maxPoints = 1e3; % adjust for performance
    if N > maxPoints
        idx = randperm(N, maxPoints);
    else
        idx = 1:N;
    end
    %scatter(M(idx), D(idx), 3, 'k.', 'MarkerEdgeAlpha', 0.2);

    % Add statistical lines
    yline(axMain,meanDiff,   '--k', 'LineWidth', 1.0, ...
        'DisplayName', sprintf('Mean = %.6f', meanDiff));
    yline(axMain,upperLimit, '--b', 'LineWidth', 1.0, ...
        'DisplayName', sprintf('Upper limit = %.6f', upperLimit));
    yline(axMain,lowerLimit, '--b', 'LineWidth', 1.0, ...
        'DisplayName', sprintf('Lower limit = %.6f', lowerLimit));

    % Labels and title
    xlabel(axMain,['Mean of ', data1_name, ' and ', data2_name]);
    ylabel(axMain,[data1_name, ' - ', data2_name]);
    title(axMain,[data1_name, ' vs ', data2_name, ' Bland-Altman Plot']);


    % Colorbar with correct bin counts
    c = colorbar(axMain);
    c.Label.String = 'Count per bin (log10 scale)';
    % Use log10 tick spacing
    rawMin = min(counts(:));
    rawMax = max(counts(:));
    ticks = linspace(rawMin, rawMax, 10); % 10 ticks
    c.Ticks = ticks;
    c.TickLabels = round(10.^ticks); % convert back from log10 to counts
    grid(axMain,'on');

    legend(axMain,'show','Location','best');
    set(gca,'layer','top')
    grid on;
    
    hold off;
    
    if ShowHist==true 
        outerPos_c = c.Position;
        outerPos = axMain.OuterPosition;
        histWidth = 0.16 * outerPos(3);
        axHist = axes('Position',[outerPos(1) outerPos_c(:,2)-histWidth outerPos_c(:,3) outerPos_c(:,4)]);

        histogram(axHist, D, 50, 'Orientation','horizontal','FaceColor',[0.8 0.2 0.2]);
        set(axHist,'XScale','log','XDir','reverse','YAxisLocation','right'); 
        xlabel(axHist,'Log10(Count)')
        axHist.XTick([]);
        ylim(axHist, ylim(axMain));
        linkaxes([axHist axMain],'y');
    end
    % set(gca,'fontsize',14)
    % YL = get(gca, 'YLimit');
    % maxlim = max(abs(YL));
    % set(gca, 'YLimit', [-maxlim maxlim])
end