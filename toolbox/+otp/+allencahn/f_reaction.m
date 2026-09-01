function du = f_reaction(t, u, ~, ~, beta, forcing)

du = beta * (u - u.^3) + forcing(t);

end
