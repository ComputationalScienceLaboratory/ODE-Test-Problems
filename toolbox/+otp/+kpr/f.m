function dy = f(t, y, lambda, omega)
yf = y(1);
ys = y(2);

dy = lambda * [(-3 + yf^2 - cos(omega * t)) / (2 * yf); (-2 + ys^2 -cos(t)) / (2 * ys)] ...
    - [omega * sin(omega * t) / (2 * yf); sin(t) / (2 * ys)];
end