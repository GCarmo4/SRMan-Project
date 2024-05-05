function [T, J] = DKin( Robot )
%DKin Homogeneous Transformation Matrix for Robot Direct Kinematics and
%   T=[R p; 0 1]

n=size(Robot,1);      %get number of robot joints
q=symvar(Robot);      %get names of robot coordinates

%The base frame (frame b) is different from the zeroth frame (frame 0)
A = [ 0   0  -1   0;
      1   0   0   0;
      0  -1   0 756; %1106 - 35 - 315 [mm]
      0   0   0   1];

% Initalize matrix T with the same size as J

%Direct kinematics for first link
T= A * DHTransf(Robot(1,:));

% First column of the Jacobian only depends on z0
z0 = [0 0 1]';
p0 = [0 0 0]';
J = [z0; p0]; %prismatic
z = T(1:3, 1:3) * z0;
p = T(1:3, 4);

for i=2:n
    %Direct kinematics for remaining links
    T=T*DHTransf(Robot(i,:));
end

%Simplify
T = simplify(T);
p_e = T(1:3, 4);

for i=2:n
    %Calculation of the geometric Jacobian
    J_ = [cross(z, (p_e - p)); z];
    J = [J, J_]; %add new column to the Jacobian matrix
    T_ = DHTransf(Robot(i-1,:));
    z = T_(1:3, 1:3) * z;
    p = p + T_(1:3, 4);
end

T = [T; zeros(2, 4)]; %same number of columns as J

J = simplify(J);

end