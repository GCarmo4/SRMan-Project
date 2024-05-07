function [T, J] = DKin( Robot )
%DKin Homogeneous Transformation Matrix for Robot Direct Kinematics and
%   T=[R p; 0 1]

n=size(Robot,1);      %get number of robot joints
q=symvar(Robot);      %get names of robot coordinates

%The base frame (frame b) is different from the zeroth frame (frame 0)
A = [ 0   0  -1   0;
      1   0   0   0;
      0  -1   0  0.756; %1106 - 35 - 315 [mm]
      0   0   0   1];

% Initalize matrix T with the same size as J

%Direct kinematics for first link
T= A * DHTransf(Robot(1,:));

%Geometric Jacobian for the first link
syms pe_x pe_y pe_z real;
pe = [pe_x, pe_y, pe_z]'; %position of end-effector wrt frame 0
z0 = [0 0 1]';
p0 = [0 0 0]';

J = sym(zeros(6, n));
J(:, 1) = Jacobian(pe, Robot(1,:), p0, z0);

for i=2:n
    %Calculation of the geometric Jacobian
    z = T(1:3, 3);
    p = T(1:3, 4);
    J(:, i) = Jacobian(pe, Robot(i,:), p, z);
    T = T * DHTransf(Robot(i,:));
end

J = subs(J, pe, T(1:3, 4));
T = [T; zeros(2, 4)]; %same number of columns as J

%Simplify
T = simplify(T);
J = simplify(J);

end