% Linear-nonlinear splitting: f = f_linear + f_nonlinear
% f_linear(u) = Jac(uL)*u,  f_nonlinear(u) = f(u)-Jac(uL)*u
% uL = linearization point, typically the solution at the beginning of the
% time step


function du = fLinear(~, u, L, alpha, beta, ~, uL)

du = alpha*L*u + beta * (u - 3*uL.^2.*u);

end
