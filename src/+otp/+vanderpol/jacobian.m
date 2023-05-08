function J = jacobian(~, y, epsilon)

y1 = y(1);
y2 = y(2);
J = [0, 1; -(2 * y1 * y2 + 1) / epsilon, (1 - y1^2) / epsilon];

end
