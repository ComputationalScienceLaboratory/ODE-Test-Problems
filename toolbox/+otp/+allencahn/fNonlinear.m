% Linear-nonlinear splitting: f = f_linear + f_nonlinear
% f_linear(u) = Jac*u,  f_nonlinear(u) = f(u)-Jac*u
% uL = linearization point, typically the solution at the beginning of the
% time step

function du = fNonlinear(t, u, ~, ~, beta, forcing, uL)

du = beta*( - u.^3 + 3*(uL.^2).*u ) + forcing(t);

end
