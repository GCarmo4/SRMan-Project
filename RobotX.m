function Robot = RobotX()
%   Returns D-H table of parameters for Robotic Arm
%   Robot=[d v a alpha offset;
%          d v a alpha offset;
%          . . .   .   offset;
%          d v a alpha offset];
%   Use symbolic variables for each joint coordinate of the robot: in the d
%   column for a prismatic joint and in the v column for a rotational
%   joint. Name the variables from q1 to qn. In the last column, insert the
%   coordinate offset for the manipulator Home position.

a2 = 25e-3;
a3 = 315e-3;
a4 = 35e-3;
d5 = 365e-3;
d7 = 80e-3;

syms q1 q2 q3 q4 q5 q6 q7 real;
Robot = [ q1     0     0   -pi/2    0;
           0    q2    a2    pi/2    0;
           0    q3    a3     0   -pi/2;
           0    q4    a4    pi/2    0;
         -d5   q5     0   -pi/2    0;
           0    q6     0    pi/2    0;
         -d7    q7     0     0      0];
end