close all

addpath(genpath(pwd))
inputFilePath = 'inputFile.cfg';
inputData = parseInputFile(inputFilePath);

% Extract roller positions, radius, and directions
rollerPositions = inputData.rollerPositions;
rollerRadius = inputData.rollerRadius;
wrapDirections = inputData.wrapDirections;

% Motor Radius
motor_r = rollerRadius(1);

% Extract initial and final points, and clearance distance
p_f = inputData.p_f;
r_t = inputData.r_t;

trajectory = computeTrajectory(p_f, rollerPositions, rollerRadius, wrapDirections, r_t);
% plotTrajectory(trajectory, rollerPositions, rollerRadius, wrapDirections, r_t);

feedTrajectory = computeFeedTrajectory(p_f, rollerPositions, rollerRadius, wrapDirections, r_t);
feedTrajectory = [trajectory(1,:); feedTrajectory];
% plotTrajectory(trajectoryFeed, rollerPositions, rollerRadius, wrapDirections, 0);

plotBothTrajectories(trajectory, feedTrajectory, rollerPositions, rollerRadius, wrapDirections, r_t)

trajectory = [zeros(size(trajectory, 1), 1), trajectory];
feedTrajectory = [zeros(size(feedTrajectory, 1), 1), feedTrajectory];

% Save the trajectory to a .mat file
save('trajectoryData.mat', 'trajectory');
save('feedTrajectoryData.mat', 'feedTrajectory');