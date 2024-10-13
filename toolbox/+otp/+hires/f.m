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

% yPrime = [
%     -1.71 * y(1) + 0.43 * y(2) + 8.32 * y(3) + 0.0007;
%     1.71 * y(1) - 8.75 * y(2);
%     -10.03 * y(3) + 0.43 * y(4) + 0.035 * y(5);
%     8.32 * y(2) + 1.71 * y(3) - 1.12 * y(4);
%     -1.745 * y(5) + 0.43 * y(6) + 0.43 * y(7);
%     -280 * y(6) * y(8) + 0.69 * y(4) + 1.71 * y(5) - 0.43 * y(6) + 0.69 * y(7);
%     280 * y(6) * y(8) - 1.81 * y(7);
%     -280 * y(6) * y(8) + 1.81 * y(7)];

end
