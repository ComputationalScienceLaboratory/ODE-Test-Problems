function j = jac(~, u, D, L)

j = -L*L - L - spdiags(u, 0, numel(u), numel(u))*D - spdiags(D*u, 0, numel(u), numel(u));

end
