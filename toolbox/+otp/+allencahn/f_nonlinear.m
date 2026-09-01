% Linear-nonlinear splitting: f = f_linear + f_nonlinear
% f_linear(u) = Jac*u,  f_nonlinear(u) = f(u)-Jac*u

function du = f_nonlinear(t, u, ~, ~, beta, forcing)

du = beta * (u - u.^3) - beta * (u - 3*u.^3) + forcing(t);

end
