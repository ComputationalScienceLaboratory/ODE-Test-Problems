function yPrime = f(~, y, k, K, klA, Ks, pCO2, H)

r1 = k(1) * y(1)^4 * sqrt(y(2));
r2 = k(2) * y(3) * y(4);
r3 = k(2) / K * y(1) * y(5);
r4 = k(3) * y(1) * y(4)^2;
r5 = k(4) * y(6)^2 * sqrt(y(2));
Fin = klA * (pCO2 / H - y(2));

yPrime = [ ...
    (-2 * r1 + r2 - r3 -r4); ...
    (-0.5 * (r1 + r5) - r4 + Fin); ...
    (r1 - r2 + r3); ...
    (-r2 + r3 - 2 * r4); ...
    (r2 - r3 + r5); ...
    (Ks * y(1) * y(4) - y(6))];

end
