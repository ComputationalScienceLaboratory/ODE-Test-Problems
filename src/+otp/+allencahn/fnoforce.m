function du = fnoforce(~, u, L, alpha, beta, ~)

du = alpha*L*u + beta * (u - u.^3);

end
