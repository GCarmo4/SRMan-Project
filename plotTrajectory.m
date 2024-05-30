function plotTrajectory(trajectory, rollerPositions, rollerRadii, wrapDirections)
    % Create figure
    figure;
    hold on;
    
    % Colors for different elements
    trajectoryColor = [0, 0.4470, 0.7410];  % Blue
    
    % Plot rollers
    for i = 1:length(rollerPositions)
        viscircles(rollerPositions(i,:), rollerRadii(i), 'Color', 'black', 'LineWidth', 1.5);
        % Plot direction arrows
        plotDirectionArrows(rollerPositions(i,:), rollerRadii(i), wrapDirections{i});
    end
    
    % Plot trajectory with markers for tangency points
    % plot(trajectory(:,1), trajectory(:,2), '--', 'Color', trajectoryColor, 'LineWidth', 1);
    % %scatter(trajectory(:,1), trajectory(:,2), 20, tangencyColor, 'filled');  % Tangency points
    plot(trajectory(:,1), trajectory(:,2), '--', 'Color', 'k', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', trajectoryColor);
    scatter(trajectory(:,1), trajectory(:,2), 30, trajectoryColor, 'filled');

    % Highlight the start and end points
    scatter(trajectory(1, 1), trajectory(1, 2), 80, trajectoryColor, 'filled', 'MarkerEdgeColor', 'k');  % Start point
    scatter(trajectory(end, 1), trajectory(end, 2), 80, trajectoryColor, 'filled', 'MarkerEdgeColor', 'k');  % End point
    
    % Add labels for the start and end points
    text(trajectory(1, 1), trajectory(1, 2), ' p_i', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', trajectoryColor);
    text(trajectory(end, 1), trajectory(end, 2), ' p_f', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', trajectoryColor);

    % Title and labels
    title('Trajectory Planning with Roller Contouring');
    xlabel('X');
    ylabel('Y');
    
    % Grid and axis settings
    grid on;
    axis equal;
    set(gca, 'FontSize', 12);  % Increase font size for better readability
    
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