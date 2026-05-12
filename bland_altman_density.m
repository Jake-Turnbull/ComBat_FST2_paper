function bland_altman_density(data1,data2,custom_color_range,data1_name,data2_name,num_bins,row_names,col_names)

if nargin < 4 || isempty(data1_name)
    data1_name = 'A';
end
if nargin <5 || isempty(data2_name)
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
if nargin < 6 || isempty(row_names)
    row_names = strcat("Row", string(1:size(data1,1)));
end

if nargin < 7 || isempty(col_names)
    col_names = strcat("Col", string(1:size(data1,2)));
end
    Mvals = (data1+data2)/2;
    Dvals = data1-data2;
    
    M = (data1(:) + data2(:)) / 2;
    
    M = replaceNaNsWithZero(M);
    M = replaceInfWithHigh(M);

    D = data1(:) - data2(:);
    D = replaceNaNsWithZero(D);
    D = replaceInfWithHigh(D);


    % Compute statistics
    meanDiff = mean(D(:));
    stddiff = std(D(:));
    upper_limit = meanDiff + 1.96 * stddiff;
    lower_limit = meanDiff - 1.96 * stddiff;
    disp(['Upper limit is ', num2str(upper_limit)])
    disp(['Lower limit is ', num2str(lower_limit)])
    disp(['Mean of differences is ', num2str(meanDiff)])
    disp(['Standard deviation of differences is ', num2str(stddiff)])

    % Define bin edges
    x_edges = linspace(min(M(:)), max(M(:)), num_bins);
    y_edges = linspace(min(D(:)), max(D(:)), num_bins);

    % Compute histogram counts
    counts = histcounts2(M(:), D(:), x_edges, y_edges);
    counts = log10(counts + 1);

    % Normalize counts
    counts = (counts - min(counts(:))) / (max(counts(:)) - min(counts(:)));

    % Map each (x, y) point to its corresponding bin and assign density
    x_bin = discretize(M(:), x_edges);
    y_bin = discretize(D(:), y_edges);

    x_bin(x_bin == 0 | x_bin > size(counts, 1)) = size(counts, 1);
    y_bin(y_bin == 0 | y_bin > size(counts, 2)) = size(counts, 2);

    % Compute densities
    densities = counts(sub2ind(size(counts), x_bin, y_bin));
    densities(isnan(densities)) = 0;
    % Normalize densities for colormap
    densities_normalized = (densities - min(densities(:))) / (max(densities(:)) - min(densities(:)));

    % Map normalized densities to colors
    idx = round(densities_normalized * (size(custom_color_range, 1) - 1)) + 1;
    point_colours = custom_color_range(idx, :);

    % Plot the data, main plotting data define  explicitely 
    figure;

    set(gcf, 'Position', [100 100 1250 700]);
    ax2 = axes('Position', [0.15, 0.15, 0.8, 0.7]); % Left, Bottom, Width, Height
    scatter(ax2, M(:), D(:), 3, point_colours);
    hold on;

    % Add statistical lines
    yline(ax2,meanDiff, '--k', 'LineWidth', 0.8, 'DisplayName', sprintf('Mean difference = %.6f', meanDiff));
    yline(ax2,upper_limit, '--b', 'LineWidth', 0.8, 'DisplayName', sprintf('Upper limit = %.6f', upper_limit));
    yline(ax2,lower_limit, '--b', 'LineWidth', 0.8, 'DisplayName', sprintf('Lower limit = %.6f', lower_limit));

    % Labels and title

    xlabel(['Mean of ',data1_name,' and ', data2_name]);
    ylabel([data1_name, '-', data2_name]);
    title([data1_name, ' vs ', data2_name, ' Bland-Altman Plot']);
    colormap(custom_color_range);

    % Add colorbar
    c = colorbar;
    c.Label.String = 'Normalized log scale of point density';
    ticks = linspace(0, 1, 10);
    tick_labels = 10.^(ticks * (max(counts(:)) - min(counts(:))) + min(counts(:)));
    c.Ticks = ticks;
    c.TickLabels = round(tick_labels, 2);
   
    legend('show');
    grid on;

    % Manually create axes for the histogram
    ax1 = axes('Position', [0.05, 0.15, 0.05, 0.7]); % Left, Bottom, Width, Height
    
    histogram(ax1, D,100, 'Orientation', 'horizontal', 'FaceColor', [0.8 0.2 0.2]);
    hold on;
    set(gca,'Xscale','log')
    
    set(ax1, 'XDir', 'reverse'); % Flip the histogram orientation
    set(ax1, 'YAxisLocation', 'right'); % Align y-axis on the right side for the flipped histogram
    xlabel(ax1,'Log10(Count of difference)')
    hold off;

    linkaxes([ax1, ax2], 'y'); % Synchronize the y-axes
    ylim(ax1, ylim(ax2));      % Match y-axis limits
    dcm = datacursormode(gcf);
    set(dcm,'UpdateFcn',@(obj,event) dataCursorText(event,Mvals,Dvals,row_names,col_names,data1,data2));


end

% --- Helper function for point hover labels
function txt = dataCursorText(event,Mvals,Dvals,row_names,col_names,data1,data2)
    pos = event.Position;
    idx = find(Mvals(:) == pos(1) & Dvals(:) == pos(2), 1, 'first');
    if isempty(idx)
        txt = {['X: ', num2str(pos(1))], ['Y: ', num2str(pos(2))]};
        return;
    end
    [r,c] = ind2sub(size(Mvals), idx);
    txt = {
        ['Row: ', char(row_names(r))], ...
        ['Column: ', char(col_names(c))], ...
        ['Data1: ', num2str(data1(r,c))], ...
        ['Data2: ', num2str(data2(r,c))]
    };
end

function outputMatrix = replaceNaNsWithZero(inputMatrix)
% replaceNaNsWithZero Replaces NaN values in a matrix with 0
%
%   outputMatrix = replaceNaNsWithZero(inputMatrix)
%
%   inputMatrix  - Numeric matrix that may contain NaN values
%   outputMatrix - Same as inputMatrix but with NaNs replaced by 0

    % Replace NaNs with 0
    outputMatrix = inputMatrix;
    outputMatrix(isnan(outputMatrix)) = 1e-13;

end

function outputMatrix = replaceInfWithHigh(inputMatrix)
% replaceNaNsWithZero Replaces NaN values in a matrix with 0
%
%   outputMatrix = replaceNaNsWithZero(inputMatrix)
%
%   inputMatrix  - Numeric matrix that may contain NaN values
%   outputMatrix - Same as inputMatrix but with NaNs replaced by 0

    % Replace NaNs with 0
    outputMatrix = inputMatrix;
    outputMatrix(isinf(outputMatrix)) = 0;

end
