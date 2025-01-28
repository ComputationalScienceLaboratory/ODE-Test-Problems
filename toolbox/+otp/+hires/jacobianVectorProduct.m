function jv = jacobianVectorProduct(~, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, ~)

k1Pr = k1 * v(1, :);
k2Pfr = k2 * v(2, :);
k3Pfr = k3 * v(2, :);
k1PrX = k1 * v(3, :);
k6PrX = k6 * v(3, :);
k2PfrX = k2 * v(4, :);
k4PfrX = k4 * v(4, :);
k1PrXPrime = k1 * v(5, :);
k5PrXPrime = k5 * v(5, :);
k2PfrXPrime = k2 * v(6, :);
k2PfrXPrimeE = k2 * v(7, :);
kMinusPfrXPrimeE = kMinus * v(7, :);
kPlusPfrXPrimeE = kPlus * (y(6) * v(8, :) + y(8) * v(6, :));
jv7 = -k2PfrXPrimeE - (kMinus + kStar) * v(7, :) + kPlusPfrXPrimeE;

jv = [ ...
    -k1Pr + k2Pfr + k6PrX;
    k1Pr - k2Pfr - k3Pfr;
    -k1PrX - k6PrX + k2PfrX + k5PrXPrime;
    k3Pfr + k1PrX - k2PfrX - k4PfrX;
    -k1PrXPrime - k5PrXPrime + k2PfrXPrime + k2PfrXPrimeE;
    k4PfrX + k1PrXPrime - k2PfrXPrime + kMinusPfrXPrimeE - kPlusPfrXPrimeE;
    jv7;
    -jv7];

end
