close all

addpath(genpath(pwd))
inputFilePath = 'inputFile.cfg';
inputData = parseInputFile(inputFilePath);

% Extract roller positions, radius, and directions
rollerPositions = inputData.rollerPositions;
rollerRadius = inputData.rollerRadius;
wrapDirections = inputData.wrapDirections;

% Extract initial and final points, and clearance distance
p_i = inputData.p_i;
p_f = inputData.p_f;
r_t = inputData.r_t;

v_t = 0.8; % Tangential speed
v_f = 1.0; % Feed velocity
max_cartesian_velocity = 2.0; % Max cartesian velocity

% Compute the minimum distance trajectory
minDistanceTrajectory = computeMinimumDistanceTrajectory(p_i, p_f, rollerPositions, rollerRadius, wrapDirections, r_t, v_t);
% plotTrajectory(minDistanceTrajectory, rollerPositions, rollerRadius, wrapDirections);

% Compute the feed velocity trajectory
feedVelocityTrajectory = computeConstantFeedVelocityTrajectory(p_i, p_f, rollerPositions, rollerRadius, wrapDirections, r_t, v_f, max_cartesian_velocity);
% plotTrajectory(feedVelocityTrajectory, rollerPositions, rollerRadius, wrapDirections);

% Compute and plot velocities
plotVelocities(minDistanceTrajectory, feedVelocityTrajectory, v_t, v_f);

% Plot trajectories
plotTrajectories(minDistanceTrajectory, feedVelocityTrajectory, rollerPositions, rollerRadius, wrapDirections, p_i, p_f);