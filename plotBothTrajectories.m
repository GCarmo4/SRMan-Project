function plotBothTrajectories(trajectory1, trajectory2, rollerPositions, rollerRadius, wrapDirections, r_t)
    % Create figure
    figure;
    hold on;
    
    % Colors for different trajectories
    trajectoryColor1 = [0, 0.4470, 0.7410];  % Blue
    trajectoryColor2 = [0.8500, 0.3250, 0.0980];  % Red

    % Plot rollers and direction arrows
    plotRollersAndDirections(rollerPositions, rollerRadius, wrapDirections, r_t);

    % Plot first trajectory with markers for tangency points
    plot(trajectory1(:,1), trajectory1(:,2), '--', 'Color', trajectoryColor1, 'LineWidth', 2);
    scatter(trajectory1(1, 1), trajectory1(1, 2), 80, trajectoryColor1, 'filled', 'MarkerEdgeColor', 'k');  % Start point
    scatter(trajectory1(end, 1), trajectory1(end, 2), 80, trajectoryColor1, 'filled', 'MarkerEdgeColor', 'k');  % End point
    text(trajectory1(1, 1) + r_t, trajectory1(1, 2) + r_t, ' p_i', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'black');
    text(trajectory1(end, 1) + r_t, trajectory1(end, 2) + r_t, ' p_f', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'black');
    
    % Plot second trajectory with markers for tangency points
    plot(trajectory2(:,1), trajectory2(:,2), '--', 'Color', trajectoryColor2, 'LineWidth', 2);
    scatter(trajectory2(1, 1), trajectory2(1, 2), 80, trajectoryColor2, 'filled', 'MarkerEdgeColor', 'k');  % Start point
    scatter(trajectory2(end, 1), trajectory2(end, 2), 80, trajectoryColor2, 'filled', 'MarkerEdgeColor', 'k');  % End point

    % Title and labels
    title('Trajectory Planning');
    xlabel('Y');
    ylabel('Z');
    
    % Grid and axis settings
    grid on;
    axis equal;
    set(gca, 'FontSize', 12);  % Increase font size for better readability
    
    hold off;
end

function plotRollersAndDirections(rollerPositions, rollerRadius, wrapDirections, r_t)
    % Colors for different elements
    rollerColor = [0, 0, 0];  % Black

    % Plot motor
    viscircles(rollerPositions(1,:), rollerRadius(1), 'Color', rollerColor, 'LineWidth', 1.5);
    plotDirectionArrows(rollerPositions(1,:), rollerRadius(1), wrapDirections{1});
    viscircles(rollerPositions(1,:), rollerRadius(1)+r_t, 'Color', rollerColor, 'LineWidth', 4);
    
    % Plot rollers
    for i = 2:length(rollerPositions)
        viscircles(rollerPositions(i,:), rollerRadius(i), 'Color', rollerColor, 'LineWidth', 1.5);
        % Plot direction arrows
        plotDirectionArrows(rollerPositions(i,:), rollerRadius(i), wrapDirections{i});
    end
end

function plotDirectionArrows(rollerPos, rollerRadius, wrapDirection)
    % Define arrow length
    arrowLength = rollerRadius * 0.8;  % Increase arrow length to 80% of roller radius
    
    % Number of arrows to plot
    numArrows = 8;
    
    % Generate angles for arrows
    angles = linspace(0, 2 * pi, numArrows + 1);
    angles(end) = [];
    
    % Plot arrows for CW or CCW direction
    for i = 1:numArrows
        % Compute arrow base position
        x_base = rollerPos(1) + rollerRadius * cos(angles(i));
        y_base = rollerPos(2) + rollerRadius * sin(angles(i));
        
        % Compute arrow direction
        if strcmpi(wrapDirection, 'CW')
            x_dir = sin(angles(i)) * arrowLength;
            y_dir = -cos(angles(i)) * arrowLength;
        else
            x_dir = -sin(angles(i)) * arrowLength;
            y_dir = cos(angles(i)) * arrowLength;
        end
        
        % Plot the arrow
        quiver(x_base, y_base, x_dir, y_dir, 'k', 'MaxHeadSize', 2, 'LineWidth', 1.5);
    end
end
