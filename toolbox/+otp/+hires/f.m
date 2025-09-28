function yPrime = f(~, y, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks)

k1Pr = k1 * y(1, :);
k2Pfr = k2 * y(2, :);
k3Pfr = k3 * y(2, :);
k1PrX = k1 * y(3, :);
k6PrX = k6 * y(3, :);
k2PfrX = k2 * y(4, :);
k4PfrX = k4 * y(4, :);
k1PrXPrime = k1 * y(5, :);
k5PrXPrime = k5 * y(5, :);
k2PfrXPrime = k2 * y(6, :);
k2PfrXPrimeE = k2 * y(7, :);
kMinusPfrXPrimeE = kMinus * y(7, :);
kPlusPfrXPrimeE = kPlus * y(6, :) * y(8, :);
yPrime7 = -k2PfrXPrimeE - (kMinus + kStar) * y(7, :) + kPlusPfrXPrimeE;

yPrime = [ ...
    -k1Pr + k2Pfr + k6PrX + oks;
    k1Pr - k2Pfr - k3Pfr;
    -k1PrX - k6PrX + k2PfrX + k5PrXPrime;
    k3Pfr + k1PrX - k2PfrX - k4PfrX;
    -k1PrXPrime - k5PrXPrime + k2PfrXPrime + k2PfrXPrimeE;
    k4PfrX + k1PrXPrime - k2PfrXPrime + kMinusPfrXPrimeE - kPlusPfrXPrimeE;
    yPrime7;
    -yPrime7];

end
