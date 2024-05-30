function plotVelocities(minDistTrajectory, constFeedTrajectory, v_t, v_f, max_cartesian_velocity)
    % Compute velocities for minimum distance trajectory
    minDistVelocities = computeVelocities(minDistTrajectory, v_t);
    minDistVelocitiesColor = [0.8500, 0.3250, 0.0980]; % Red
    
    % Compute velocities for constant feed velocity trajectory
    constFeedVelocities = computeVelocities(constFeedTrajectory, v_f);
    constFeedVelocitiesColor = [0.4660 0.6740 0.1880]; % Green
    
    % Create figure for velocities
    figure;
    
    % Subplot for minimum distance trajectory velocities
    subplot(2, 1, 1);
    plot(minDistVelocities, 'Color', minDistVelocitiesColor, 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', minDistVelocitiesColor);
    title('Tangential Velocities along Minimum Distance Trajectory');
    xlabel('Trajectory Point Index');
    ylabel('Velocity');
    ylim([0, max([minDistVelocities; constFeedVelocities]) + 0.1]); % Consistent y-axis range
    grid on;
    
    % Subplot for constant feed velocity trajectory velocities
    subplot(2, 1, 2);
    plot(constFeedVelocities, 'Color', constFeedVelocitiesColor, 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', constFeedVelocitiesColor);
    title('Tangential Velocities along Constant Feed Velocity Trajectory');
    xlabel('Trajectory Point Index');
    ylabel('Velocity');
    ylim([0, max([minDistVelocities; constFeedVelocities]) + 0.1]); % Consistent y-axis range
    grid on;
end

function velocities = computeVelocities(trajectory, baseVelocity)
    % Initialize velocity array
    velocities = zeros(size(trajectory, 1) - 1, 1);
    
    % Compute velocities between each pair of points
    for i = 1:length(velocities)
        distance = norm(trajectory(i+1, :) - trajectory(i, :));
        velocities(i) = baseVelocity * distance; % Adjust as needed for specific velocity computation
    end
end