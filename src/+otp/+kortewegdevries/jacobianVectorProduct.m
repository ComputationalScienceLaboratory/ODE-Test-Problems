function Jvp = jacobianVectorProduct(~, u, v, theta, alpha, nu, rho, ~, Dx, D3x, ~, ~)

u_x = Dx*u;
v_x = Dx*v;

Jvp = (2*alpha)*(theta*(Dx*(u.*v)) ...
    + (1 - theta)*(u_x.*v + u.*v_x)) ...
    + rho*v_x ...
    + nu*(D3x*v);

end
