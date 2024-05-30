function plotTrajectories(minDistanceTrajectory, feedVelocityTrajectory, rollerPositions, rollerRadii, wrapDirections, p_i, p_f)
    % Create figure for comparison
    figure;
    hold on;
    title('Trajectory Comparison: Minimum Distance vs Constant Feed Velocity');
    % Colors for different elements
    lightBlue = [0, 0.5, 1];  % Lighter Blue
    trajectoryColorMinDist = [0.8500, 0.3250, 0.0980];  % Red
    trajectoryColorConstFeed = [0.4660 0.6740 0.1880];  % Green
    
    % Plot rollers
    for i = 1:length(rollerPositions)
        viscircles(rollerPositions(i,:), rollerRadii(i), 'Color', 'k', 'LineWidth', 2); % Thicker lines for rollers
        plotDirectionArrows(rollerPositions(i,:), rollerRadii(i), wrapDirections{i});
    end
    
    % Plot minimum distance trajectory
    plot(minDistanceTrajectory(:,1), minDistanceTrajectory(:,2), '--', 'Color', 'k', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', trajectoryColorMinDist);
    scatter(minDistanceTrajectory(:,1), minDistanceTrajectory(:,2), 30, trajectoryColorMinDist, 'filled');
    
    % Plot constant feed velocity trajectory
    plot(feedVelocityTrajectory(:,1), feedVelocityTrajectory(:,2), '--', 'Color', 'k', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', trajectoryColorConstFeed);
    scatter(feedVelocityTrajectory(:,1), feedVelocityTrajectory(:,2), 30, trajectoryColorConstFeed, 'filled');
    
    % Highlight the start and end points
    scatter(p_i(1), p_i(2), 50, 'k', 'filled', 'MarkerEdgeColor', 'k');  % Start point
    scatter(p_f(1), p_f(2), 50, 'k', 'filled', 'MarkerEdgeColor', 'k');  % End point
    
    % Add labels for the start and end points
    text(p_i(1), p_i(2), ' p_i', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k');
    text(p_f(1), p_f(2), ' p_f', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'k');
    
    xlabel('X');
    ylabel('Y');
    grid on;
    axis equal;
    hold off;
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