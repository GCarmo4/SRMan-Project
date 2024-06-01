close all

addpath(genpath(pwd))
inputFilePath = 'inputFile.cfg';
inputData = parseInputFile(inputFilePath);

% Extract roller positions, radius, and directions
rollerPositions = inputData.rollerPositions;
rollerRadius = inputData.rollerRadius;
wrapDirections = inputData.wrapDirections;

% Extract initial and final points, and clearance distance
p_f = inputData.p_f;
r_t = inputData.r_t;

trajectory = computeTrajectory(p_f, rollerPositions, rollerRadius, wrapDirections, r_t);
plotTrajectory(trajectory, rollerPositions, rollerRadius, wrapDirections, r_t);