function dy = ffast(t, y, Omega, omega)

yf = y(1);
ys = y(2);

dy = [((Omega(1, 1) * (yf^2 - cos(omega * t) - 3) - omega * sin(omega * t)) / yf + Omega(1, 2) * (ys^2 - cos(t) - 2) / ys) / 2; 0];

end
