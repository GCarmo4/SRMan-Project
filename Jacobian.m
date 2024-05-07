function J = Jacobian(pe, p_i, p, z)
% p_i = [d v a alpha offset]
% z from the previous joint
% p from the previuous joint

q=symvar(p_i);        %get symbolic variable from p

if isequal(p_i(1),q)  %if it is a prismatic joint
    J_p = z;
    J_o = [0 0 0]';
else
    J_p = cross(z, (pe - p));
    J_o = z;
end

J = [J_p; J_o];

end