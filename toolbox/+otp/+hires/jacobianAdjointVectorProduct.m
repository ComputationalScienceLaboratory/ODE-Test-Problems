function vj = jacobianAdjointVectorProduct(~, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, ~)

kPlusPfrXPrime = conj(kPlus * y(6));
kPlusE = conj(kPlus * y(8));
kSum = conj(k2 + kMinus + kStar);

vj = [ ...
    conj(k1) * (v(2) - v(1));
    conj(k2) * v(1) - conj(k2 + k3) * v(2) + conj(k3) * v(4);
    conj(k6) * v(1) - conj(k1 + k6) * v(3) + conj(k1) * v(4);
    conj(k2) * v(3) - conj(k2 + k4) * v(4) + conj(k4) * v(6);
    conj(k5) * v(3) - conj(k1 + k5) * v(5) + conj(k1) * v(6);
    conj(k2) * v(5) - (conj(k2) + kPlusE) * v(6) + kPlusE * (v(7) - v(8));
    conj(k2) * v(5) + conj(kMinus) * v(6) + kSum * (v(8) - v(7));
    kPlusPfrXPrime * (v(7) - v(6) - v(8))];

end
