function Javp = jacobianAdjointVectorProduct(~, y, v, sigma, rho, beta)

Javp = [ ...
    -conj(sigma)*v(1, :) + conj(rho - y(3, :)).*v(2, :) + conj(y(2, :)).*v(3, :); ...
    conj(sigma)*v(1, :) - v(2, :) + conj(y(1, :)).*v(3, :); ...
    -conj(y(1, :)).*v(2, :) - conj(beta)*v(3, :)];

end
