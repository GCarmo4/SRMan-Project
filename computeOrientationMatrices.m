function orientationMatrices = computeOrientationMatrices(trajectory)
    % Initialize the matrices
    numPoints = size(trajectory, 1);
    orientationMatrices = zeros(3, 3, numPoints);

    % Iterate through each point in the trajectory
    for k = 1:numPoints-1
        % Compute tangent vector at current point
        tangent_vector = trajectory(k+1, :) - trajectory(k, :);

        % Check if tangent vector is zero
        if norm(tangent_vector) < eps
            tangent_vector = [0, 1, 0];  % Assign a default direction if zero
        end
        
        % Normalize tangent_vector
        tangent_vector = tangent_vector / norm(tangent_vector);

        % Define the Z axis
        zAxis = [0, tangent_vector(1), tangent_vector(2)];
        
        % Define the X axis as [1, 0, 0] since it's perpendicular to the YZ plane
        xAxis = [1, 0, 0];
        
        % Define the Y axis as a vector perpendicular to both X and Z axes
        yAxis = cross(zAxis, xAxis);
        
        % Check if yAxis is zero and fix it
        if norm(yAxis) < eps
            yAxis = [0, 1, 0];  % Assign a default direction if zero
        else
            yAxis = yAxis / norm(yAxis);
        end
        
        % Recalculate the Z axis to ensure orthogonality
        zAxis = cross(xAxis, yAxis);
        zAxis = zAxis / norm(zAxis);
        
        % Construct the orientation matrix
        orientationMatrices(:,:,k) = [xAxis; yAxis; zAxis];
        
        % Debug statements
        fprintf('Point %d:\n', k);
        fprintf('Tangent Vector: (%.2f, %.2f, %.2f)\n', tangent_vector);
        fprintf('Orientation Matrix:\n');
        disp(orientationMatrices(:,:,k));
    end

    % For the last point, use the same orientation as the second to last point
    orientationMatrices(:,:,numPoints) = orientationMatrices(:,:,numPoints-1);

    % Save orientation matrices to a file
    save('orientationMatrices.mat', 'orientationMatrices');
end
