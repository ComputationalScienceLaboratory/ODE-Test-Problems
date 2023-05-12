function du = jacobian(t, u, Theta, Alpha, Nu, Rho, Dx, D3x, Nx)

u_x = Dx*u;

U = spdiags(u, 0, Nx, Nx);
U_x = spdiags(u_x, 0, Nx, Nx);

du = (2*Alpha)*(Theta*(Dx*U) + (1 - Theta)*(U_x + U*Dx)) + Rho*Dx + Nu*D3x;

end