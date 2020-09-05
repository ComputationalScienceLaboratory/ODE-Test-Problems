function du = f(~, u, D, L)

du = - L*(L*u + u) - u.*(D*u);

end
