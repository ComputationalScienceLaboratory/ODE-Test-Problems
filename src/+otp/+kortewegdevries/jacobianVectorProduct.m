function du = jacobianVectorProduct(t, u, v, Theta, Alpha, Nu, Rho, Dx, D3x)

u_x = Dx*u;
v_x = Dx*v;

du = (2*Alpha)*(Theta*(Dx*(u.*v)) + (1 - Theta)*(u_x.*v + u.*v_x)) + Rho*v_x + Nu*(D3x*v);

end
