function jac = jacobianNonlinear(~, y, a, ~)

v1 = 2 * a * y(1) * y(2);
v2 = a * y(1)^2;

jac = [v1, v2; -v1, -v2];

end
