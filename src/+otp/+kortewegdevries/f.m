function du = f(t, u, Theta, Alpha, Nu, Rho, Dx, D3x)

u_x = Dx*u;
du = Alpha*(Theta*(Dx*(u.^2)) + 2*(1 - Theta)*(u.*u_x)) + Rho*u_x + Nu*(D3x*u);

end