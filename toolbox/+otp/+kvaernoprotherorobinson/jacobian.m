function J = jacobian(t, y, lambda, omega)

yf = y(1);
ys = y(2);

J = [(lambda(1, 1) * (3 + yf^2 + cos(t*omega)) + omega * sin(t * omega)) / (2 * yf^2), ...
    (lambda(1, 2) * (2 + ys^2 + cos(t))) / (2 * ys^2); ...
    (lambda(2, 1) * (3 + yf^2 + cos(t * omega))) / (2 * yf^2), ...
    (lambda(2, 2) * (2 + ys^2 + cos(t)) + sin(t)) / (2 * ys^2)];

end