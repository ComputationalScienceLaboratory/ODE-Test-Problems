function du = jacobian(~, u, theta, alpha, nu, rho, nx, Dx, D3x, ~, ~)

u_x = Dx*u;

U = spdiags(u, 0, nx, nx);
U_x = spdiags(u_x, 0, nx, nx);

du = (2*alpha)*(theta*(Dx*U) ...
    + (1 - theta)*(U_x + U*Dx)) ...
    + rho*Dx ...
    + nu*D3x;

end