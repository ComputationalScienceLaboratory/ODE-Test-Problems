function dy = fslow(t, y, Omega, omega)

yf = y(1);
ys = y(2);

dy = [0; ((Omega(2, 2) * (ys^2 - cos(t) - 2) - sin(t)) / ys + Omega(2, 1) * (yf^2 - cos(omega * t) - 3) / yf) / 2];

end
