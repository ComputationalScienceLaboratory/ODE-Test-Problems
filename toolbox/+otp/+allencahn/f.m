function du = f(t, u, L, alpha, beta, forcing)

du = alpha*L*u + beta * (u - u.^3) + forcing(t);

end
