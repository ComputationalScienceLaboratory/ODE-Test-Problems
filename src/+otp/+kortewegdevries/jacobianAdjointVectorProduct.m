function Javp = jacobianAdjointVectorProduct(~, u, v, theta, alpha, nu, rho, ~, Dx, ~, Dxt, D3xt)

u_x = Dx*u;

Javp = (2*alpha)*(theta*(u.*(Dxt*v)) ...
    + (1 - theta)*(u_x.*v + Dxt*(u.*v))) ...
    + rho*(Dxt*v) ...
    + nu*(D3xt*v);

end