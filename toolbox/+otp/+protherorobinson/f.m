function dy = f(t, y, lambda, phi, dphi)

dy = lambda * (y - phi(t)) + dphi(t);

end
