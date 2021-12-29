function du = fconstforce(~, u, L, alpha, beta, forcing)

du = alpha*L*u + beta * (u - u.^3) + forcing;

end
