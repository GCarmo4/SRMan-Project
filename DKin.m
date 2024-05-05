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
p_i = Robot(1,:);
T= A * DHTransf(p_i);
z = [0 0 1]';
p = [0 0 0]';

for i=2:n
    %Direct kinematics for remaining links
    T=T*DHTransf(Robot(i,:));
end

%Simplify
T = simplify(T);
p_n = T(1:3, 4);
J = Jacobian(p_n, p_i, p, z);

for i=2:n
    p_i = Robot(i,:);
    %Calculation of the geometric Jacobian
    J_ = Jacobian(p_n, p_i, p, z);
    J = [J, J_]; %add new column to the Jacobian matrix
    T_ = DHTransf(p_i);
    z = T_(1:3, 3);
    p = T(1:3, 4);
end

T = [T; zeros(2, 4)]; %same number of columns as J

J = simplify(J);

end