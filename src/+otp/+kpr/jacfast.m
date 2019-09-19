function jac = jacfast(t, y, Omega, omega)

yf = y(1);
ys = y(2);

jac = [(Omega(1, 1) * (3 + yf^2 + cos(t*omega)) + omega * sin(t * omega)) / (2 * yf^2), ...
    (Omega(1, 2) * (2 + ys^2 + cos(t))) / (2 * ys^2); ...
    0, 0];

end
