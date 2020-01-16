function du = f(~, u, L, alpha)

du = alpha*L*u + u - u.^3;

end
