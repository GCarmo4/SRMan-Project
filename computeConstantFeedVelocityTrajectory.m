function trajectory = computeConstantFeedVelocityTrajectory(p_i, p_f, rollerPositions, rollerRadii, wrapDirections, r_t, v_f, max_cartesian_velocity)
    % Initialize the trajectory with the starting point
    trajectory = p_i;
    
    % Current position starts at the initial point
    currentPosition = p_i;
    
    % Iterate through each roller
    for k = 1:length(rollerPositions)-1
        P1 = rollerPositions(k, :);
        P2 = rollerPositions(k+1, :);
        r1 = rollerRadii(k) + r_t; % w/ clearance radius
        r2 = rollerRadii(k+1) + r_t; % w/ clearance radius
        wrapDirection1 = wrapDirections{k};
        wrapDirection2 = wrapDirections{k+1};
        
        % Compute distance between rollers
        P12 = P2 - P1;
        d = norm(P12);
        
        % Calculate gamma based on wrapping directions
        if (strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CCW')) || ...
           (strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CW'))
            gamma = acos((r1 + r2) / d);
        elseif (strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CW')) || ...
               (strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CCW'))
            gamma = acos((r1 - r2) / d);
        else
            error('Unexpected wrapping direction combination');
        end
        
        % Normalize P12 to get direction
        P12_dir = P12 / d;
        P12_perp = [-P12_dir(2), P12_dir(1)];  % Perpendicular vector
        
        % Compute tangency points
        if strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CCW')
            t1 = P1 + r1 * (cos(gamma) * P12_dir + sin(gamma) * P12_perp);
            t2 = P2 - r2 * (cos(gamma) * P12_dir + sin(gamma) * P12_perp);
        elseif strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CW')
            t1 = P1 + r1 * (cos(gamma) * P12_dir - sin(gamma) * P12_perp);
            t2 = P2 - r2 * (cos(gamma) * P12_dir - sin(gamma) * P12_perp);
        elseif strcmpi(wrapDirection1, 'CW') && strcmpi(wrapDirection2, 'CW')
            t1 = P1 + r1 * (cos(gamma) * P12_dir - sin(gamma) * P12_perp);
            t2 = P2 + r2 * (cos(gamma) * P12_dir + sin(gamma) * P12_perp);
        elseif strcmpi(wrapDirection1, 'CCW') && strcmpi(wrapDirection2, 'CCW')
            t1 = P1 + r1 * (cos(gamma) * P12_dir + sin(gamma) * P12_perp);
            t2 = P2 + r2 * (cos(gamma) * P12_dir - sin(gamma) * P12_perp);
        else
            error('Unexpected wrapping direction combination');
        end
        
        % Compute the required tangential velocity
        v_t1 = v_f * r1;
        v_t2 = v_f * r2;
        
        % Check if tangential velocities exceed the maximum Cartesian velocity
        if v_t1 > max_cartesian_velocity
            v_t1 = max_cartesian_velocity;
        end
        if v_t2 > max_cartesian_velocity
            v_t2 = max_cartesian_velocity;
        end
        
        % Add debug statements
        fprintf('Roller %d -> %d\n', k, k+1);
        fprintf('Prev Position: (%.2f, %.2f), Curr Position: (%.2f, %.2f)\n', P1, P2);
        fprintf('Prev Radius: %.2f, Curr Radius: %.2f\n', r1, r2);
        fprintf('Distance: %.2f, Gamma: %.2f\n', d, gamma);
        fprintf('Tangency Point Out: (%.2f, %.2f)\n', t1);
        fprintf('Tangency Point In: (%.2f, %.2f)\n', t2);
        fprintf('Tangential Velocities: %.2f, %.2f\n', v_t1, v_t2);
        
        % Generate the arc from current position to the tangency point
        arcToT1 = generateArc(currentPosition, t1, P1, r1, wrapDirection1);
        trajectory = [trajectory; arcToT1];
        
        % Add the outgoing tangency point to the trajectory
        trajectory = [trajectory; t1];
        
        % Generate the arc between the tangency points
        arcPoints = generateArc(t1, t2, P2, r2, wrapDirection2);
        trajectory = [trajectory; arcPoints];
        
        % Add the incoming tangency point to the trajectory
        trajectory = [trajectory; t2];
        
        % Update the current position
        currentPosition = t2;
    end
    
    % Handle the last roller to final point transition
    P_last = rollerPositions(end, :);
    r_last = rollerRadii(end) + r_t; % w/ clearance radius
    wrapDirection_last = wrapDirections{end};
    
    % Generate the arc from the last tangency point to the final point
    arcToPf = generateArc(currentPosition, p_f, P_last, r_last, wrapDirection_last);
    trajectory = [trajectory; arcToPf];
    
    % Finally, add the final point to the trajectory
    trajectory = [trajectory; p_f];
    
    % Interpolate trajectory for constant feed velocity
    trajectory = interpolateTrajectoryForConstantFeedVelocity(trajectory, v_f);
end

function interpolatedTrajectory = interpolateTrajectoryForConstantFeedVelocity(trajectory, v_f)
    % Initialize the interpolated trajectory
    interpolatedTrajectory = [];
    
    % Loop through each segment in the trajectory
    for i = 1:size(trajectory, 1) - 1
        % Extract start and end points of the segment
        startPoint = trajectory(i, :);
        endPoint = trajectory(i + 1, :);
        
        % Compute the distance between the points
        distance = norm(endPoint - startPoint);
        
        % Compute the number of points needed for the given feed velocity
        numPoints = ceil(distance / v_f);
        
        % Interpolate points along the segment
        for j = 0:numPoints
            interpolatedPoint = startPoint + j * (endPoint - startPoint) / numPoints;
            interpolatedTrajectory = [interpolatedTrajectory; interpolatedPoint];
        end
    end
end