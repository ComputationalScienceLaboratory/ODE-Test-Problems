function du = jacobianAdjointVectorProduct(t, u, v, Theta, Alpha, Nu, Rho, Dx, Dxt, D3xt)

u_x = Dx*u;

du = (2*Alpha)*(Theta*(u.*(Dxt*v)) + (1 - Theta)*(u_x.*v + Dxt*(u.*v))) + Rho*(Dxt*v) + Nu*(D3xt*v);

end