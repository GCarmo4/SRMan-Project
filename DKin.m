function [T] = DKin( Robot )
%DKin Homogeneous Transformation Matrix for Robot Direct Kinematics and
%   T=[R p; 0 1]

n=size(Robot,1);      %get number of robot joints
q=symvar(Robot);      %get names of robot coordinates

%The base frame (frame b) is different from the zeroth frame (frame 0)
A = [ 0   0  -1   0;
      1   0   0   0;
      0  -1   0 756; %1106 - 35 - 315 [mm]
      0   0   0   1];

%Direct kinematics for first link
T= A * DHTransf(Robot(1,:));

% First column of the Jacobian only depends of z0 (7cols 6rows)
% revolucao: [0 0 1] * (pe - pi-1)
% prismatica: [0 0 1]

for i=2:n
    % Calculate the first matrix (4x4)
    % Complete i+1 column of jacobian (start at second column)

    %Direct kinematics for remaining links
    T=T*DHTransf(Robot(i,:));
end

%Simplify
T=simplify(T);
end