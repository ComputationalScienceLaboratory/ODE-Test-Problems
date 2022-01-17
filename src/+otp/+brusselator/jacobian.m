function jac = jacobian(~, y, a, b)

v1 = 2 * a * y(1) * y(2);
v2 = a * y(1)^2;

jac = [
    v1 - b - 1, v2;
    b - v1, -v2
    ];

end
