function J = Jacobian(pe, robot_i, p, z)
% robot_i = [d v a alpha offset]
% z from the previous joint
% p from the previuous joint

q = symvar(robot_i);        %get symbolic variable from p

if isequal(robot_i(1), q)  %if it is a prismatic joint
    J_p = z;
    J_o = sym(zeros(3, 1));
else
    J_p = cross(z, (pe - p));
    J_o = z;
end

J = [J_p; J_o];

end