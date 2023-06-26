function jac = jacobianFast(t, y, lambda, omega)

yf = y(1);
ys = y(2);

jac = [(lambda(1, 1) * (3 + yf^2 + cos(t*omega)) + omega * sin(t * omega)) / (2 * yf^2), ...
    (lambda(1, 2) * (2 + ys^2 + cos(t))) / (2 * ys^2); ...
    0, 0];

end
