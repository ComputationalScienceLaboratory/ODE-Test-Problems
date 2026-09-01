% Linear-nonlinear splitting: f = f_linear + f_nonlinear
% f_linear(u) = Jac*u,  f_nonlinear(u) = f(u)-Jac*u

function du = f_linear(~, u, L, alpha, beta, ~)

du = alpha*L*u + beta * (u - 3*u.^3);

end
