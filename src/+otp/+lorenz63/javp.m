function Javp = javp(~, y, v, sigma, rho, beta)

Javp = [ ...
    -sigma*v(1) + (rho - y(3))*v(2) + y(2)*v(3); ...
    sigma*v(1) - v(2) + y(1)*v(3); ...
    -y(1)*v(2) - beta*v(3)];

end
