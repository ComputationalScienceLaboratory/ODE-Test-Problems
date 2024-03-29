function jac = jacobianNonlinear(~, y, ~, ~)

v1 = 2 * y(1) * y(2);
v2 = y(1)^2;

jac = [v1, v2; -v1, -v2];

end
